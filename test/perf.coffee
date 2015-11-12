# coffeelint: disable=max_line_length

(require 'chai').should()
Benchmark = require 'benchmark'
{
  _, X, O
  empty,
  isWin
} = require '../src/connect-four'

run = (s, f) ->
  new Benchmark.Suite()
    .add s, -> f()
    .on 'cycle', (e) -> it e.target, ->
    .run async: false

describe 'Connect Four benchmarks', ->
  @timeout 60*1000

  describe 'isWin', ->
    draw = [
      O, X, X, O, X, O, X
      X, O, X, O, X, O, X
      X, O, X, O, O, X, O
      X, O, O, X, O, X, O
      O, X, X, O, X, X, X
      O, X, O, X, X, O, O
    ]
    run 'isWin (on draw)', -> isWin draw, X
    xWinsFirstRow = [
      X, X, X, X, X, O, X
      X, O, X, O, X, O, X
      X, O, X, O, O, X, O
      O, O, O, X, O, X, O
      O, X, X, O, X, X, X
      O, X, O, X, X, O, O
    ]
    run 'isWin (X wins on the first row)', -> isWin xWinsFirstRow, X
    xWinsLastDiagonal = [
      O, X, X, O, X, O, X
      X, O, X, O, X, O, X
      X, O, X, O, O, X, X
      X, O, O, X, O, X, O
      O, X, X, O, X, X, X
      O, X, O, X, X, O, O
    ]
    run 'isWin (X wins on the last diagonal)', -> isWin xWinsLastDiagonal, X
