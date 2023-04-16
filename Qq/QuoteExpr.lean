import Qq.Typ

open Lean (Expr Level)

namespace Qq

/--
  Gives a meta-level representation of the universe in which some type `α` lives
-/
class QuoteUnivOf (α : Sort u) where
  /-- Object representing the universe of `α` -/
  quoteUniv : Level



/--
  Converts a value of type `α` into an expression that represents this value in Lean.

  This class differs from the built-in `ToExpr` in two ways:
    * It allows implementation for `α : Prop`, whereas `ToExpr` is only for `Type _`s
    * We use the `QQ` type family to assert the type of the returned expressions.
      This ensures this type information is available when implementors use the `q(⋅)` macro
      to construct the expression.
-/
class QuoteExpr (α : Sort u) extends QuoteUnivOf α where
  /-- Expression representing the type `α` -/
  quoteTypeExpr : QQ (Expr.sort quoteUniv)
  /-- Convert a value `a : α` into an expression that denotes `a` -/
  quoteExpr     : α → QQ quoteTypeExpr


export QuoteExpr (quoteExpr)

end Qq