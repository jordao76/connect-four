# coffeelint: disable=max_line_length

(require 'chai').should()
{MinimaxAgent} = require 'aye-aye'
{_, X, O, ConnectFour} = require '../src/connect-four'

minimax = new MinimaxAgent 2

playTurn = (state) ->
  return null if state.isTerminal()
  state.play minimax.nextAction state

play = (state) ->
  until state.isTerminal()
    state = playTurn state
  state

describe "Connect Four minimax state", ->

  it 'X should win given the right conditions', ->
    state = new ConnectFour [
      _, _, _, _, _, _, _
      _, _, _, _, _, _, _
      _, _, _, _, _, _, _
      _, _, _, O, _, X, _
      _, _, O, O, X, X, O
      _, _, O, X, X, X, O
    ]
    state = play state
    state.isWin(X).should.be.true
    state.isWin(O).should.be.false

  it 'O should win given the right conditions', ->
    state = new ConnectFour [
      _, _, _, _, _, _, _
      _, _, _, _, _, _, _
      _, _, _, _, O, O, _
      _, _, _, O, X, X, _
      _, _, O, O, X, X, _
      _, _, O, X, X, X, O
    ]
    state = play state
    state.isWin(X).should.be.false
    state.isWin(O).should.be.true
