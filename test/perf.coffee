# coffeelint: disable=max_line_length

(require 'chai').should()
Benchmark = require 'benchmark'
{
  _, X, O
  empty,
  isWin
} = require '../src/connect-four'

describe 'Connect Four benchmarks', ->

  describe 'isWin', ->
    @timeout 60*1000
    a =
      [
        O, X, X, O, X, O, X
        X, O, X, O, X, O, X
        X, O, X, O, O, X, O
        X, O, O, X, O, X, O
        O, X, X, O, X, X, X
        O, X, O, X, X, O, O
      ]
    new Benchmark.Suite()
      .add 'isWin', -> isWin a, X
      .on 'cycle', (e) -> it 'on draw, ' + e.target, ->
      .run async: false
