import Qq
open Qq Lean


def listToExpr {α : Type} [ToExpr α] : List α → Q(List $α)
  | []       => q([])
  | a :: as  => q($a :: $(listToExpr as))