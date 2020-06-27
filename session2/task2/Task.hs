{-# language DefaultSignatures,
             FlexibleContexts,
             FlexibleInstances,
             KindSignatures,
             TypeOperators #-}
module Task where

import Data.Kind
import GHC.Generics

class Enumerate a where
  enumerate :: Int -> [a]

  default
    enumerate :: (Generic a, GEnumerate (Rep a))
              => Int -> [a]
  enumerate n = map to (genumerate n)

instance Enumerate Int where
  enumerate x = [0 .. x - 1]
instance Enumerate Bool where
  enumerate n
   | n <= 0    = []
   | otherwise = [False, True]

class GEnumerate (f :: Type -> Type) where
  genumerate :: Int -> [f a]

split :: Int -> [(Int, Int)]
split n = [ (i, n - i) | i <- [1 .. n - 1] ]

instance GEnumerate U1 where
  genumerate n
    | n <= 0    = []
    | otherwise = [U1]

instance Enumerate t => GEnumerate (K1 i t) where
  genumerate n = map K1 (enumerate n)
    
instance (GEnumerate r, GEnumerate s) => GEnumerate (r :+: s) where
  genumerate n = map L1 (genumerate n) ++ map R1 (genumerate n)
    
instance (GEnumerate r, GEnumerate s) => GEnumerate (r :*: s) where
  genumerate n = [ll :*: rr | (l, r) <- split n
                            , ll <- genumerate l
                            , rr <- genumerate r] 
     
-- rest of instances:
-- * K1 i t
-- * r :+: s
-- * r :*: s

-- We'll talk about this in the next session
instance (GEnumerate r) => GEnumerate (M1 t m r) where
  genumerate n = map M1 (genumerate n)

-- END OF FILE