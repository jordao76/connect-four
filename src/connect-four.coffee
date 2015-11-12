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

winnableDiagonals = (a) ->
  flatten ([a[i+j*7],a[i+7+1+j*7],a[i+7*2+2+j*7],a[i+7*3+3+j*7]] for i in [0...4] for j in [0...3])

winnableLines = (a) ->
  [(winnableRows a)..., (winnableColumns a)..., (winnableDiagonals a)...]

isWin = (a, W) ->
  (winnableLines a).some (r) -> r.every (e) -> e is W

module.exports = {
  _, X, O
  empty
  isWin
}
