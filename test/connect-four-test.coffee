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
    it 'should be false for game-in-progress', ->
      as = [
        [
          _, _, _, _, _, _, _
          _, _, _, _, _, _, _
          _, _, _, O, _, _, _
          _, _, _, X, _, _, _
          _, _, _, O, X, _, _
          _, _, O, X, X, O, _
        ]
        [
          _, _, _, _, _, _, _
          _, _, _, _, _, _, _
          _, _, _, _, _, _, _
          _, _, _, X, _, _, _
          _, _, O, X, _, _, _
          _, _, O, X, _, _, _
        ]
        [
          _, _, _, _, _, _, _
          _, _, _, _, _, _, _
          _, _, _, _, _, _, _
          _, _, _, _, _, _, _
          O, O, O, _, _, _, _
          X, X, X, _, X, _, _
        ]
      ]
      (isWin a, X).should.be.false for a in as
      (isWin a, O).should.be.false for a in as
