# coffeelint: disable=max_line_length

$ = jQuery

{X, O, ConnectFour} = require './connect-four'

{showSpinner, hideSpinner} = require './spinner'
require './highlight'

$ ->

  game = null
  lastAction = null

  playable = ->
    className =
      if game.nextPlayer is X then 'x-playable-tile' else 'o-playable-tile'
    for i in game.freePositions()
      $ "##{i}"
        .addClass className
    className

  unplayable = ->
    $ '.tile'
      .removeClass 'x-playable-tile'
      .removeClass 'o-playable-tile'
      .removeClass 'human-playable-tile'
      .off 'click'

  markWin = ->
    for i in game.winOn()
      wonClass = if game.isWin X then 'x-won-tile' else 'o-won-tile'
      ($ "##{i}").addClass wonClass

  checkGameOver = ->
    return no unless game.isTerminal()
    endText = switch
      when game.isWin X then 'X Wins!'
      when game.isWin O then 'O Wins!'
      else 'Draw!'
    $ '#end-text'
      .text endText
    $ '#modal-game-over'
      .modal('show')
    yes

  playAction = (action) ->
    columnIndex = action % 7
    hideSpinner()
    index = game.openPosition columnIndex
    playerText = game.nextPlayer.toLowerCase()
    $ "##{index}"
      .addClass playerText + '-tile'
      .highlight()
    game = game.play action
    lastAction = action
    next()

  # player :: {
  #   setup : (done: ->) ->
  #   teardown : ->
  #   play : ->
  # }

  playerX = null
  playerO = null

  next = ->
    unplayable()
    markWin()
    player = if game.nextPlayer is X then playerX else playerO
    player.play()

  players =
    human: -> humanPlayer()
    computer: -> computerPlayer 4

  createPlayerX = ->
    playerName = ($ '#btn-player-x').text()
    players[playerName]()
  createPlayerO = ->
    playerName = ($ '#btn-player-o').text()
    players[playerName]()

  swapPlayers = ->
    $x = $ '#btn-player-x'
    $o = $ '#btn-player-o'
    tmp = $x.text()
    $x.text $o.text()
    $o.text tmp

  $ '.player'
    .on 'click', ->
      $player = $ this
      playerFor = $player.data 'player-for'
      $btn = $ "#btn-player-#{playerFor}"
      playerName = $player.text()
      currentPlayerName = $btn.text()
      if currentPlayerName isnt playerName
        $btn.text playerName
        setup()

  humanPlayer = ->
    int = (s) -> parseInt s, 10
    setup: (done) -> done()
    play: ->
      return if checkGameOver()
      playableClassName = playable()
      $ ".#{playableClassName}"
        .addClass 'human-playable-tile'
        .on 'click', ->
          $tile = $ this
          action = int $tile.get(0).id
          playAction action

  computerPlayer = (depth = 3) ->
    worker = new Worker 'src/minimax-worker.min.js'
    setup: (done) ->
      worker.onmessage = (e) -> playAction e.data.action
      worker.postMessage command: 'setup', args: {depth}
      done()
    play: ->
      return if checkGameOver()
      playable()
      showSpinner()
      worker.postMessage command: 'play', args: {lastAction}
    teardown: -> worker.terminate()

  setup = ->
    teardown()
    game = new ConnectFour
    game.lastPlayedPosition = null # start with the full board open
    lastAction = null
    [playerX, playerO] = [createPlayerX(), createPlayerO()]
    playerX.setup -> playerO.setup -> next()

  teardown = ->
    playerX?.teardown?()
    playerO?.teardown?()
    hideSpinner()
    $ '.tic-tac-toe'
      .removeClass 'x-won-board'
      .removeClass 'o-won-board'
    $ '.tile'
      .removeClass 'x-tile'
      .removeClass 'o-tile'
      .removeClass 'x-won-tile'
      .removeClass 'o-won-tile'

  newGame = ->
    swapPlayers()
    setup()

  $ '#btn-new-game'
    .on 'click', newGame

  setup()
