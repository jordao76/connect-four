# coffeelint: disable=max_line_length

gulp = require 'gulp'
$ = (require 'gulp-load-plugins')()
run = require 'run-sequence'

onError = (error) ->
  $.util.log error
  process.exit 1 # note: shouldn't exit on a live-reload/watch environment

# build

gulp.task 'lint', ->
  gulp.src ['./gulpfile.coffee', './src/**/*.coffee']
    .pipe $.coffeelint()
    .pipe $.coffeelint.reporter()
    .pipe $.coffeelint.reporter 'failOnWarning'

gulp.task 'test', ['lint'], ->
  gulp.src ['./test/**/*.coffee']
    .pipe $.mocha()
    .on 'error', onError

gulp.task 'compile', ->
  gulp.src './src/**/*.coffee'
    .pipe $.coffee bare: yes
    .on 'error', onError
    .pipe gulp.dest './lib'

gulp.task 'clean',
  require 'del'
    .bind null, ['lib']

gulp.task 'build', (done) ->
  run 'clean', 'test', 'compile', done

gulp.task 'default', ['build']
