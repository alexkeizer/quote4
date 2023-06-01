import Qq
open Qq Lean


def listToExpr {α : Type} [ToExpr α] : List α → Q(List $α)
  | []       => q([])
  | a :: as  => q($a :: $(listToExpr as))

def force_nat : Nat → Nat
  := id

structure Foo where
  n : Nat

example (foo : Foo) : Q(Foo) :=
  let x := 1
  let y := 2
  let z := 1 + 2
  let bar := Foo.mk z
  let _ := force_nat z
  q($bar)