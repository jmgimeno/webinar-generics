{-# language DeriveGeneric, ScopedTypeVariables, StandaloneDeriving #-}
module Main (main) where

import qualified GHC.Generics as GHC
import Common
import Task
import Test.Hspec
import Test.Hspec.QuickCheck
import Test.QuickCheck.Arbitrary.Generic

deriving instance GHC.Generic Address
deriving instance GHC.Generic PlaceKind

instance Arbitrary Address where
  arbitrary = genericArbitrary
instance Arbitrary PlaceKind where
  arbitrary = genericArbitrary

main :: IO ()
main = hspec $ do
  prop "Place to generic" $
    \k s c -> from (Place k s c) == This (Field k `And` Field s `And` Field c)
  prop "Place from generic" $
    \k s c -> Place k s c == to (This (Field k `And` Field s `And` Field c))
  prop "Address to and from are inverses" $
    \(a :: Address) -> to (from a) == a
  prop "PlaceKind to and from are inverses" $
    \(pk :: PlaceKind) -> to (from pk) == pk