# coffeelint: disable=max_line_length

# parameters

srcPath = './app'
destPath = './dist'
testPath = './test'
scriptPath = '/src' # within srcPath and destPath, only used with browserify
coffeeGlobs = ['./gulpfile.coffee', "#{srcPath}/**/*.coffee", "#{testPath}/**/*.coffee"]
perfGlob = "#{testPath}/**/perf*.coffee"
scriptTransforms =
  'index.coffee': 'index.min.js'
  'minimax-worker.coffee': 'minimax-worker.min.js'

gulp = require 'gulp'
$ = (require 'gulp-load-plugins')()
run = require 'run-sequence'

onError = (error) ->
  $.util.log error
  process.exit 1 # note: shouldn't exit on a live-reload/watch environment

# build

gulp.task 'lint', ->
  gulp.src coffeeGlobs
    .pipe $.coffeelint()
    .pipe $.coffeelint.reporter()
    .pipe $.coffeelint.reporter 'failOnWarning'

gulp.task 'test', ['lint'], ->
  gulp.src ["#{testPath}/**/*.coffee", "!#{perfGlob}"]
    .pipe $.mocha()
    .on 'error', onError

gulp.task 'scripts', ['test'], ->
  browserify = require 'browserify'
  source = require 'vinyl-source-stream'
  buffer = require 'vinyl-buffer'
  coffeeify = require 'coffeeify'

  transform = (sourceFile, destFile) ->
    browserify entries: ["#{srcPath}#{scriptPath}/#{sourceFile}"], extensions: ['.coffee'], debug: true
      .transform coffeeify
      .bundle()
      .pipe source destFile
      .pipe buffer()
      .pipe $.sourcemaps.init loadMaps: true
      .pipe $.uglify()
      .pipe $.sourcemaps.write './'
      .pipe gulp.dest "#{destPath}#{scriptPath}"

  for sourceFile, destFile of scriptTransforms
    transform sourceFile, destFile

gulp.task 'jade', ->
  gulp.src "#{srcPath}/**/*.jade"
    .pipe $.jade pretty: yes
    .pipe gulp.dest '.tmp'

gulp.task 'html', ['jade'], ->
  gulp.src ["#{srcPath}/**/*.html", '.tmp/**/*.html']
    .pipe $.useref searchPath: srcPath
    .pipe $.if '*.css', $.csso()
    .pipe $.if '*.html', $.htmlmin collapseWhitespace: true
    .pipe gulp.dest destPath

gulp.task 'clean',
  require 'del'
    .bind null, [destPath, '.tmp', '.publish']

gulp.task 'build', (done) ->
  run 'clean', ['scripts', 'html'], done

gulp.task 'default', ['build']

# performance test

gulp.task 'perf', ['lint'], ->
  gulp.src perfGlob
    .pipe $.mocha()
    .on 'error', onError

# serve

gulp.task 'connect', ['build'], ->
  connect = require 'connect'
  serveStatic = require 'serve-static'
  app = connect()
    .use (require 'connect-livereload') port: 35729
    .use serveStatic destPath
    .use '/bower_components', serveStatic './bower_components'

  require 'http'
    .createServer app
    .listen 9000
    .on 'listening', ->
      $.util.log 'Started connect web server on http://localhost:9000'

gulp.task 'watch', ['connect'], ->
  gulp.watch ["#{srcPath}/**/*.coffee"], ['scripts']
  gulp.watch ["#{srcPath}/**/*.html", "#{srcPath}/**/*.jade", "#{srcPath}/**/*.css"], ['html']

  $.livereload.listen()
  gulp.watch ["#{destPath}/**/*.html", "#{destPath}/**/*.css", "#{destPath}/**/*.js"]
    .on 'change', $.livereload.changed

gulp.task 'serve', ['watch'], ->
  (require 'opn') 'http://localhost:9000'

# deploy

gulp.task 'cdnize', ['build'], ->
  gulp.src "#{destPath}/index.html"
    .pipe $.cdnizer [
      {
        file: '/bower_components/jquery/dist/jquery.min.js'
        package: 'jquery'
        cdn: 'http://code.jquery.com/jquery-${ version }.min.js'
      }
      {
        file: '/bower_components/bootstrap/dist/css/bootstrap.min.css'
        package: 'bootstrap'
        cdn: 'https://maxcdn.bootstrapcdn.com/bootstrap/${ version }/css/bootstrap.min.css'
      }
      {
        file: '/bower_components/bootstrap/dist/js/bootstrap.min.js'
        package: 'bootstrap'
        cdn: 'https://maxcdn.bootstrapcdn.com/bootstrap/${ version }/js/bootstrap.min.js'
      }
      {
        file: '/bower_components/spin.js/spin.min.js'
        package: 'spin.js'
        cdn: 'https://cdnjs.cloudflare.com/ajax/libs/spin.js/${ version }/spin.min.js'
      }
    ]
    .pipe gulp.dest destPath

gulp.task 'deploy', ['cdnize'], ->
  gulp.src "#{destPath}/**/*"
    .pipe $.ghPages()
