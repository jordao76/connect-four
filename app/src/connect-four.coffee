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

# array with all 4-tuple indices of board positions
# where a player can win the game
winnableIndices = do ->
  res = []
  for i in [0...4]
    # rows
    for j in [0...6]
      k=i+j*7
      res.push [k,k+1,k+2,k+3]
    # left diagonals
    for j in [0...3]
      k=i+j*7
      res.push [k,k+7+1,k+7*2+2,k+7*3+3]
  for j in [0...3]
    # columns
    for i in [0...7]
      k=i+j*7
      res.push [k,k+7,k+7*2,k+7*3]
    # right diagonals
    for i in [3...7]
      k=i+j*7
      res.push [k,k+7-1,k+7*2-2,k+7*3-3]
  res

isWin = (a, W) ->
  for [i1,i2,i3,i4] in winnableIndices
    return yes if a[i1] is W and a[i2] is W and a[i3] is W and a[i4] is W
  no

isFull = (a) ->
  for e in a
    return no if e is _
  yes

isTerminal = (a) ->
  (isWin a, X) or (isWin a, O) or (isFull a)

openColumns = (a) ->
  i for i in [0...7] when a[i] is _

freePositions = (a) ->
  i for i in [0...42] when a[i] is _

openPosition = (a, columnIndex) ->
  for rowIndex in [5..0]
    index = rowIndex*7+columnIndex
    return index if a[index] is _

# this is a bit faster than using Array::slice
copy = (a) ->
  i = 42
  b = new Array i
  b[i] = a[i] while i--
  b

play = (a, columnIndex, W) ->
  index = openPosition a, columnIndex
  b = copy a
  b[index] = W
  b

scores = [1,10,100,1000,10000]
evaluate = (a) ->
  score = 0
  for indices in winnableIndices
    [x, o] = [0, 0]
    for i in indices
      ++x if a[i] is X
      ++o if a[i] is O
    score += scores[x] - scores[o] if x is 0 or o is 0
  score

class ConnectFour
  constructor: (@a = empty, @nextPlayer = X, @depth = 0) ->
  isWin: (W) -> isWin @a, W
  isTerminal: -> @depth >= 7 and isTerminal @a
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
