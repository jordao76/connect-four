# coffeelint: disable=max_line_length

(require 'chai').should()
{
  _, X, O
  empty,
  isWin, isFull, isTerminal
  openColumns, play, evaluate
} = require '../src/connect-four'

draw = [
  O, X, X, O, X, O, X
  X, O, X, O, X, O, X
  X, O, X, O, O, X, O
  X, O, O, X, O, X, O
  O, X, X, O, X, X, X
  O, X, O, X, X, O, O
]
game = [
  _, _, _, _, _, _, _
  _, _, _, _, _, _, _
  _, _, _, O, _, _, _
  _, _, _, X, _, _, _
  _, _, _, O, X, _, _
  _, _, O, X, X, O, _
]
xWins = [
  X, X, X, X, _, _, _
  _, _, _, _, _, _, _
  _, _, _, _, _, _, _
  _, _, _, _, _, _, _
  _, _, _, _, _, _, _
  _, _, _, _, _, _, _
]
oWins = [
  _, _, _, _, _, _, _
  _, _, _, _, _, _, _
  _, _, _, O, _, _, _
  _, _, _, _, O, _, _
  _, _, _, _, _, O, _
  _, _, _, _, _, _, O
]

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
        game,
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
    it 'should be false for draw', ->
      (isWin draw, X).should.be.false
      (isWin draw, O).should.be.false

  describe 'isFull', ->
    it 'should be false for an empty board', ->
      (isFull empty).should.be.false
    it 'should be true for draw', ->
      (isFull draw).should.be.true
    it 'should be false for game-in-progress', ->
      (isFull game).should.be.false
    it 'should be false for wins', ->
      (isFull xWins).should.be.false
      (isFull oWins).should.be.false

  describe 'isTerminal', ->
    it 'should be false for an empty board', ->
      (isTerminal empty).should.be.false
    it 'should be true for draw', ->
      (isTerminal draw).should.be.true
    it 'should be false for game-in-progress', ->
      (isTerminal game).should.be.false
    it 'should be true for wins', ->
      (isTerminal xWins).should.be.true
      (isTerminal oWins).should.be.true

  describe 'openColumns', ->
    it 'all should be open for an empty board', ->
      (openColumns empty).should.deep.equal [0...7]
    it 'none should be open for draw', ->
      (openColumns draw).should.deep.equal []
    it 'available columns should be open', ->
      game = [
        O, _, _, O, _, _, _
        O, _, _, X, _, _, _
        O, _, _, O, _, _, _
        X, _, _, X, _, _, _
        X, _, _, O, X, _, _
        X, _, O, X, X, O, _
      ]
      (openColumns game).should.deep.equal [1, 2, 4, 5, 6]

  describe 'evaluate', ->
    it 'should be zero for an empty board', ->
      (evaluate empty).should.equal 0
    it 'should be positive for an X win', ->
      (evaluate xWins).should.be.above 0
    it 'should be negative for an O win', ->
      (evaluate oWins).should.be.below 0
    it 'should be zero for a draw', ->
      (evaluate draw).should.equal 0
    it 'should correctly evaluate a game in progress', ->
      (evaluate game).should.be.below (evaluate xWins)
      (evaluate game).should.be.above (evaluate oWins)

  describe 'play', ->
    it 'should play at the right positions', ->
      (play empty, 0, X).should.deep.equal [
        _, _, _, _, _, _, _
        _, _, _, _, _, _, _
        _, _, _, _, _, _, _
        _, _, _, _, _, _, _
        _, _, _, _, _, _, _
        X, _, _, _, _, _, _
      ]
      (play [
        _, _, _, _, _, _, _
        _, _, _, _, _, _, _
        _, _, _, _, _, _, _
        _, _, _, _, _, _, _
        _, _, _, X, _, _, _
        _, _, O, X, O, _, _
      ], 3, X).should.deep.equal [
        _, _, _, _, _, _, _
        _, _, _, _, _, _, _
        _, _, _, _, _, _, _
        _, _, _, X, _, _, _
        _, _, _, X, _, _, _
        _, _, O, X, O, _, _
      ]
      (play [
        _, _, _, _, _, _, _
        _, _, _, O, _, _, _
        _, _, _, X, _, _, _
        _, _, _, O, _, _, _
        _, _, _, X, _, _, _
        _, _, O, X, O, _, _
      ], 3, O).should.deep.equal [
        _, _, _, O, _, _, _
        _, _, _, O, _, _, _
        _, _, _, X, _, _, _
        _, _, _, O, _, _, _
        _, _, _, X, _, _, _
        _, _, O, X, O, _, _
      ]
