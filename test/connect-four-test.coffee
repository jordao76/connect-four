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
    it 'should be true for row wins', ->
      ws = (W) -> [
        [
          W, W, W, W, _, _, _
          _, _, _, _, _, _, _
          _, _, _, _, _, _, _
          _, _, _, _, _, _, _
          _, _, _, _, _, _, _
          _, _, _, _, _, _, _
        ]
        [
          _, _, _, _, _, _, _
          _, _, _, W, W, W, W
          _, _, _, _, _, _, _
          _, _, _, _, _, _, _
          _, _, _, _, _, _, _
          _, _, _, _, _, _, _
        ]
        [
          _, _, _, _, _, _, _
          _, _, _, _, _, _, _
          _, _, _, _, _, _, _
          _, _, W, W, W, W, _
          _, _, _, _, _, _, _
          _, _, _, _, _, _, _
        ]
        [
          _, _, _, _, _, _, _
          _, _, _, _, _, _, _
          _, _, _, _, _, _, _
          _, _, _, _, _, _, _
          _, _, _, _, _, _, _
          W, W, W, W, _, _, _
        ]
      ]
      (isWin x, X).should.be.true for x in ws X
      (isWin o, O).should.be.true for o in ws O
    it 'should be true for column wins', ->
      ws = (W) -> [
        [
          W, _, _, _, _, _, _
          W, _, _, _, _, _, _
          W, _, _, _, _, _, _
          W, _, _, _, _, _, _
          _, _, _, _, _, _, _
          _, _, _, _, _, _, _
        ]
        [
          _, _, _, _, _, _, _
          _, _, _, W, _, _, _
          _, _, _, W, _, _, _
          _, _, _, W, _, _, _
          _, _, _, W, _, _, _
          _, _, _, _, _, _, _
        ]
        [
          _, _, _, _, _, _, _
          _, _, _, _, _, _, _
          _, _, _, _, _, _, W
          _, _, _, _, _, _, W
          _, _, _, _, _, _, W
          _, _, _, _, _, _, W
        ]
      ]
      (isWin x, X).should.be.true for x in ws X
      (isWin o, O).should.be.true for o in ws O
    it 'should be true for left-to-right diagonal wins', ->
      ws = (W) -> [
        [
          W, _, _, _, _, _, _
          _, W, _, _, _, _, _
          _, _, W, _, _, _, _
          _, _, _, W, _, _, _
          _, _, _, _, _, _, _
          _, _, _, _, _, _, _
        ]
        [
          _, _, _, _, _, _, _
          _, _, _, _, _, _, _
          _, _, _, W, _, _, _
          _, _, _, _, W, _, _
          _, _, _, _, _, W, _
          _, _, _, _, _, _, W
        ]
      ]
      (isWin x, X).should.be.true for x in ws X
      (isWin o, O).should.be.true for o in ws O
    it 'should be true for right-to-left diagonal wins', ->
      ws = (W) -> [
        [
          _, _, _, _, _, _, W
          _, _, _, _, _, W, _
          _, _, _, _, W, _, _
          _, _, _, W, _, _, _
          _, _, _, _, _, _, _
          _, _, _, _, _, _, _
        ]
        [
          _, _, _, _, _, _, _
          _, _, _, _, _, _, _
          _, _, _, W, _, _, _
          _, _, W, _, _, _, _
          _, W, _, _, _, _, _
          W, _, _, _, _, _, _
        ]
        [
          _, _, _, _, _, _, _
          _, _, _, _, _, W, _
          _, _, _, _, W, _, _
          _, _, _, W, _, _, _
          _, _, W, _, _, _, _
          _, _, _, _, _, _, _
        ]
      ]
      (isWin x, X).should.be.true for x in ws X
      (isWin o, O).should.be.true for o in ws O
