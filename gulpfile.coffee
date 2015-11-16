# coffeelint: disable=max_line_length

gulp = require 'gulp'
$ = (require 'gulp-load-plugins')()
run = require 'run-sequence'

onError = (error) ->
  $.util.log error
  process.exit 1 # note: shouldn't exit on a live-reload/watch environment

# build

gulp.task 'lint', ->
  gulp.src ['./gulpfile.coffee', './app/src/**/*.coffee']
    .pipe $.coffeelint()
    .pipe $.coffeelint.reporter()
    .pipe $.coffeelint.reporter 'failOnWarning'

gulp.task 'test', ['lint'], ->
  gulp.src ['./test/**/*.coffee', '!./test/**/perf*.coffee']
    .pipe $.mocha()
    .on 'error', onError

gulp.task 'scripts', ['test'], ->
  browserify = require 'browserify'
  source = require 'vinyl-source-stream'
  buffer = require 'vinyl-buffer'
  coffeeify = require 'coffeeify'

  transform = (sourceFile, targetFile) ->
    browserify entries: ["./app/src/#{sourceFile}"], extensions: ['.coffee'], debug: true
      .transform(coffeeify)
      .bundle()
      .pipe source targetFile
      .pipe buffer()
      .pipe $.sourcemaps.init loadMaps: true
      .pipe $.uglify()
      .pipe $.sourcemaps.write './'
      .pipe gulp.dest 'dist/src'

  transform 'index.coffee', 'main.min.js'
  transform 'minimax-worker.coffee', 'minimax-worker.min.js'

gulp.task 'jade', ->
  gulp.src 'app/*.jade'
    .pipe $.jade pretty: yes
    .pipe gulp.dest '.tmp'

gulp.task 'html', ['jade'], ->
  gulp.src '.tmp/*.html'
    .pipe $.useref searchPath: 'app'
    .pipe $.if '*.css', $.csso()
    .pipe $.if '*.html', $.minifyHtml conditionals: true
    .pipe gulp.dest 'dist'

gulp.task 'clean',
  require 'del'
    .bind null, ['dist', '.tmp']

gulp.task 'build', (done) ->
  run 'clean', ['scripts', 'html'], done

gulp.task 'default', ['build']

# performance test

gulp.task 'perf', ->
  gulp.src ['./test/**/perf*.coffee']
    .pipe $.mocha()
    .on 'error', onError

# serve

gulp.task 'connect', ['build'], ->
  connect = require 'connect'
  serveStatic = require 'serve-static'
  app = connect()
    .use (require 'connect-livereload') port: 35729
    .use serveStatic 'dist'
    .use '/bower_components', serveStatic './bower_components'

  require 'http'
    .createServer app
    .listen 9000
    .on 'listening', ->
      $.util.log 'Started connect web server on http://localhost:9000'

gulp.task 'watch', ['connect'], ->
  gulp.watch ['app/**/*.coffee'], ['scripts']
  gulp.watch ['app/*.jade', 'app/css/**/*.css'], ['html']

  $.livereload.listen()
  gulp.watch ['dist/*.html', 'dist/css/**/*.css', 'dist/src/**/*.js']
    .on 'change', $.livereload.changed

gulp.task 'serve', ['watch'], ->
  (require 'opn') 'http://localhost:9000'
