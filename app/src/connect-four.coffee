# coffeelint: disable=max_line_length
{MAX, MIN} = require 'aye-aye'

[_, X, O] = [0, 1, 2]

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
  # sort based on bottom-up board position
  res.sort (x, y) -> (Math.min y...) - (Math.min x...)

winner = (a) ->
  for [i1,i2,i3,i4] in winnableIndices
    return a[i1] if a[i1] isnt _ and a[i1] is a[i2] is a[i3] is a[i4]
  null

isWin = (a, W) -> (winner a) is W

wonIndices = (a, [i1,i2,i3,i4]) ->
  a[i1] isnt _ and a[i1] is a[i2] is a[i3] is a[i4]

winOn = (a) ->
  for indices in winnableIndices
    return indices if wonIndices a, indices
  []

isFull = (a) ->
  for i in [0...7]
    return no if a[i] is _
  yes

isTerminal = (a) ->
  (isFull a) or !!(winner a)

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

repr = (a) ->
  boardStr = ""
  for row in [0...6]
    for col in [0...7]
      piece = a[row * 7 + col]
      if piece is X
        boardStr += "X "
      else if piece is O
        boardStr += "O "
      else
        boardStr += "_ "
    boardStr += "\n"
  boardStr

class ConnectFour
  constructor: (@a = empty, @nextPlayer = X, @depth = 0) ->
  isWin: (W) -> isWin @a, W
  winOn: -> winOn @a
  winner: -> winner @a
  isTerminal: -> @depth >= 7 and isTerminal @a
  nextAgent: -> if @nextPlayer is X then MAX else MIN
  utility: -> evaluate @a
  freePositions: -> freePositions @a
  openPosition: (columnIndex) -> openPosition @a, columnIndex
  possibleActions: -> openColumns @a
  play: (columnIndex) ->
    new @constructor (play @a, columnIndex, @nextPlayer), @opponent(), @depth + 1
  opponent: -> if @nextPlayer is X then O else X
  toString: -> repr @a

module.exports = {
  _, X, O
  empty
  winner, isWin, winOn, isFull, isTerminal
  freePositions, openColumns, openPosition, play, evaluate
  ConnectFour
}
