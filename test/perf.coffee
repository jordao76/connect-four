# coffeelint: disable=max_line_length

(require 'chai').should()
Benchmark = require 'benchmark'
{
  _, X, O
  empty,
  isWin,
  ConnectFour
} = require '../app/src/connect-four'

run = (s, f) ->
  new Benchmark.Suite()
    .add s, f
    .on 'cycle', (e) -> it e.target, ->
    .run async: false

describe 'Connect Four benchmarks', ->
  @timeout 60*1000

  describe 'minimax state', ->

    {MinimaxAgent} = require 'aye-aye'
    agent = new MinimaxAgent 3
    playTurn = (state) -> state.play agent.nextAction state

    run 'minimax depth 3 play turn from initial conditions', -> playTurn new ConnectFour

    state = new ConnectFour
    state = playTurn state for i in [0...10]
    state.isTerminal().should.be.false
    run 'minimax depth 3 play turn after 10 turns', -> playTurn state

    state = playTurn state for i in [0...10]
    state.isTerminal().should.be.false
    run 'minimax depth 3 play turn after 20 turns', -> playTurn state
