# coffeelint: disable=max_line_length

(require 'chai').should()
{
  _, X, O
  empty,
  isWin
} = require '../src/connect-four'

describe 'Connect Four operations', ->

  describe 'isWin', ->

    it 'should be false for an empty board', ->
      (isWin empty, X).should.be.false
      (isWin empty, O).should.be.false
