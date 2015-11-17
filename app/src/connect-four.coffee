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

winnableLines = (a) ->
  res = []
  for i in [0...4]
    # rows
    for j in [0...6*7] by 7
      res.push a[i+j...i+j+4]
    # left diagonals
    for j in [0...3]
      res.push [a[i+j*7],a[i+7+1+j*7],a[i+7*2+2+j*7],a[i+7*3+3+j*7]]
  for j in [0...3]
    # columns
    for i in [0...7]
      res.push [a[i+j*7],a[i+7+j*7],a[i+7*2+j*7],a[i+7*3+j*7]]
    # right diagonals
    for i in [3...7]
      res.push [a[i+j*7],a[i+7-1+j*7],a[i+7*2-2+j*7],a[i+7*3-3+j*7]]
  res

isWin = (a, W) ->
  for [a,b,c,d] in winnableLines a
    return yes if a is W and b is W and c is W and d is W
  no

isFull = (a) ->
  for e in a
    return no if e is _
  yes

isTerminal = (a) ->
  (isWin a, X) or (isWin a, O) or (isFull a)

openColumns = (a) ->
  i for e, i in a[0...7] when e is _

freePositions = (a) ->
  i for e, i in a[0...42] when e is _

openPosition = (a, columnIndex) ->
  for rowIndex in [5..0]
    index = rowIndex*7+columnIndex
    return index if a[index] is _

play = (a, columnIndex, W) ->
  index = openPosition a, columnIndex
  b = a.slice()
  b[index] = W
  b

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
  openPosition: (columnIndex) -> openPosition @a, columnIndex
  possibleActions: -> openColumns @a
  play: (columnIndex) ->
    new @constructor (play @a, columnIndex, @nextPlayer), @opponent(), @depth + 1
  opponent: -> if @nextPlayer is X then O else X

module.exports = {
  _, X, O
  empty
  isWin, isFull, isTerminal
  freePositions, openColumns, openPosition, play, evaluate
  ConnectFour
}
