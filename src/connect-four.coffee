# coffeelint: disable=max_line_length

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

module.exports = {
  _, X, O
  empty
  isWin, isFull, isTerminal
}
