{-# language DefaultSignatures,
             FlexibleContexts,
             FlexibleInstances,
             KindSignatures,
             TypeOperators #-}
module Task where

import Data.Kind
import GHC.Generics

class NotEq a where
  neq :: a -> a -> Bool

  default
    neq :: (Generic a, GNotEq (Rep a))
        => a -> a -> Bool
  neq x y = gneq (from x) (from y)  -- generic implementation

class GNotEq (f :: Type -> Type) where
  gneq :: f x -> f x -> Bool

instance GNotEq U1 where
  gneq _ _ = False

instance (NotEq t) => GNotEq (K1 i t) where
  gneq (K1 x) (K1 y) = neq x y

instance (GNotEq r, GNotEq s) => GNotEq (r :+: s) where
  gneq (L1 x) (L1 y) = gneq x y
  gneq (R1 x) (R1 y) = gneq x y
  gneq _      _      = True

instance (GNotEq r, GNotEq s) => GNotEq (r :*: s) where
  gneq (x1 :*: x2) (y1 :*: y2) = gneq x1 y1 || gneq x2 y2

-- We'll talk about this in the next session
instance (GNotEq r) => GNotEq (M1 t m r) where
  gneq (M1 x) (M1 y) = gneq x y

-- END OF FILE