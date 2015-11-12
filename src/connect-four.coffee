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
  flatten (a[i+j+0...i+j+4] for i in [0...4] for j in [0...6*7] by 7)

isWin = (a, W) ->
  (winnableRows a).some (r) -> r.every (e) -> e is W

module.exports = {
  _, X, O
  empty
  isWin
}
