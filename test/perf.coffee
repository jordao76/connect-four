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

    state = new ConnectFour
    [turn, step] = [0, 10]
    until state.isTerminal()
      run "minimax depth #{agent.depth} play turn after #{turn} turns", -> playTurn state
      for i in [0...step]
        turn++
        state = playTurn state unless state.isTerminal()
