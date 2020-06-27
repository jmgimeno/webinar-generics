{-# language TypeFamilies, EmptyDataDeriving #-}
module Common where

import Data.Kind

data Field a = Field a deriving (Eq)

data Unit    = Unit    deriving (Eq)
data And a b = And a b deriving (Eq)

data Void                      deriving (Eq)
data Or  a b = This a | That b deriving (Eq)

class Generic a where
  type Rep a :: Type
  from :: a -> Rep a
  to   :: Rep a -> a
