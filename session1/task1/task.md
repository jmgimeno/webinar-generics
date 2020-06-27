## Representations

In this exercise we define two data types, `Address` and `PlaceKind`.
The goal is for you to write their `Generic` instances,
which are composed by the description of its representation,
and the conversion functions in both directions.

Use the basic combinators introduced in the first section,
which we show here as reference:

```haskell
data Field a = Field a

data Unit    = Unit
data And a b = And a b

data Void
data Or  a b = This a | That b

class Generic a where
  type Rep a :: Type
  from :: a -> Rep a
  to   :: Rep a -> a
```