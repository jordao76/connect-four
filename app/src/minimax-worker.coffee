{MinimaxAgent} = require 'aye-aye'
{ConnectFour, openColumns} = require './connect-four'
Game = ConnectFour

# returns random j such that i ≤ j < n
random = (i, n) -> Math.floor(Math.random()*(n-i)+i)

# Fisher–Yates
shuffle = (a) ->
  n = a.length
  return a if n is 0
  for i in [0...n-1]
    j = random i, n
    [a[i],a[j]] = [a[j],a[i]]
  a

ConnectFour::possibleActions = -> shuffle openColumns @a

player = null
game = null

self.onmessage = (e) ->
  switch e.data.command
    when 'setup'
      game = new Game
      depth = e.data.args.depth
      player = computerPlayer depth
    when 'play'
      lastAction = e.data.args.lastAction
      game = game.play lastAction if lastAction?
      action = player.play game
      game = game.play action
      self.postMessage {action}

computerPlayer = (depth = 3) ->
  agent = new MinimaxAgent depth
  play: (game) ->
    return if game.isTerminal()
    agent.nextAction game
