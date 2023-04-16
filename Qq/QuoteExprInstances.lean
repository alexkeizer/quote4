import Qq.QuoteExpr
import Qq.Macro

open Lean (Level ToExpr)

namespace Qq

instance (α : Sort 0) : QuoteUnivOf α := ⟨Level.ofNat 0⟩
instance (α : Sort 1) : QuoteUnivOf α := ⟨Level.ofNat 1⟩
instance (α : Sort 2) : QuoteUnivOf α := ⟨Level.ofNat 2⟩
instance (α : Sort 3) : QuoteUnivOf α := ⟨Level.ofNat 3⟩
instance (α : Sort 4) : QuoteUnivOf α := ⟨Level.ofNat 4⟩
instance (α : Sort 5) : QuoteUnivOf α := ⟨Level.ofNat 5⟩
instance (α : Sort 6) : QuoteUnivOf α := ⟨Level.ofNat 6⟩
instance (α : Sort 7) : QuoteUnivOf α := ⟨Level.ofNat 7⟩
instance (α : Sort 8) : QuoteUnivOf α := ⟨Level.ofNat 8⟩


/--
  Define a fallback instance of `QuoteExpr` for implementors of `ToExpr`
-/
instance (priority := low) {α : Type u} [ToExpr α] [QuoteUnivOf α] : QuoteExpr α where
  quoteTypeExpr := ToExpr.toTypeExpr α
  quoteExpr a   := ToExpr.toExpr a



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