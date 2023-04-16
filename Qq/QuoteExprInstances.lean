import Qq.QuoteExpr
import Qq.Macro

open Lean (Level ToExpr)

namespace Qq

/--
  Define a fallback instance of `QuoteExpr` for implementors of `ToExpr`
-/
instance (priority := low) {α : Type u} [ToExpr α] [ToLevel.{u}] : QuoteExpr α where
  quoteTypeExpr := ToExpr.toTypeExpr α
  quoteExpr a   := ToExpr.toExpr a

/--
  Define a fallback instance of `ToExpr` for implementors of `QuoteExpr`
-/
instance (priority := low) {α : Type u} [QuoteExpr α] : ToExpr α where
  toTypeExpr := @quoteTypeExpr α _ 
  toExpr := quoteExpr

instance (a b : Nat) : QuoteExpr (a < b) where
  quoteTypeExpr := q($a < $b)
  quoteExpr := go where
    go {a b : Nat} (h : a < b) : Q($a < $b) := match a, b with
    | 0, 0      => by contradiction
    | 0, b+1    => q(Nat.zero_lt_succ $b)
    | a+1, b+1  =>
      have h := Nat.lt_of_succ_lt_succ h
      let h := go h
      q(@Nat.succ_lt_succ $a $b $h)


instance (n : Nat) : QuoteExpr (Fin n) where
  quoteTypeExpr := q(Fin $n)
  quoteExpr := fun ⟨i, h⟩ => q(⟨$i, $h⟩)

end Qq