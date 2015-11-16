# coffeelint: disable=max_line_length
{MAX, MIN} = require 'aye-aye'

[_, X, O] = [' ', 'X', 'O']

# empty board
empty = [
  _, _, _, _, _, _, _
  _, _, _, _, _, _, _
  _, _, _, _, _, _, _
  _, _, _, _, _, _, _
  _, _, _, _, _, _, _
  _, _, _, _, _, _, _
]

flatten = (a) -> a.reduce (l, r) -> l.concat r

winnableRows = (a) ->
  flatten (a[i+j...i+j+4] for i in [0...4] for j in [0...6*7] by 7)

winnableColumns = (a) ->
  flatten ([a[i+j*7],a[i+7+j*7],a[i+7*2+j*7],a[i+7*3+j*7]] for i in [0...7] for j in [0...3])

winnableDiagonalsL = (a) ->
  flatten ([a[i+j*7],a[i+7+1+j*7],a[i+7*2+2+j*7],a[i+7*3+3+j*7]] for i in [0...4] for j in [0...3])

winnableDiagonalsR = (a) ->
  flatten ([a[i+j*7],a[i+7-1+j*7],a[i+7*2-2+j*7],a[i+7*3-3+j*7]] for i in [3...7] for j in [0...3])

winnableLines = (a) ->
  [(winnableRows a)..., (winnableColumns a)..., (winnableDiagonalsL a)..., (winnableDiagonalsR a)...]

isWin = (a, W) ->
  (winnableLines a).some (r) -> r.every (e) -> e is W

isFull = (a) ->
  not a.some (e) -> e is _

isTerminal = (a) ->
  (isFull a) or (isWin a, X) or (isWin a, O)

openColumns = (a) ->
  i for e, i in a[0...7] when e is _

freePositions = (a) ->
  i for e, i in a[0...42] when e is _

play = (a, columnIndex, W) ->
  for rowIndex in [5..0]
    index = rowIndex*7+columnIndex
    break if a[index] is _
  [a[0...index]..., W, a[index+1..]...]

evaluate = (a) ->
  score = 0
  for l in winnableLines a
    [x, o] = [0, 0]
    for w in l
      ++x if w is X
      ++o if w is O
    score += 10**x - 10**o if x is 0 or o is 0
  score

class ConnectFour
  constructor: (@a = empty, @nextPlayer = X, @depth = 0) ->
  isWin: (W) -> isWin @a, W
  isTerminal: -> isTerminal @a
  nextAgent: -> if @nextPlayer is X then MAX else MIN
  utility: -> evaluate @a
  freePositions: -> freePositions @a
  possibleActions: -> openColumns @a
  play: (columnIndex) ->
    new @constructor (play @a, columnIndex, @nextPlayer), @opponent(), @depth + 1
  opponent: -> if @nextPlayer is X then O else X

module.exports = {
  _, X, O
  empty
  isWin, isFull, isTerminal
  freePositions, openColumns, play, evaluate
  ConnectFour
}
