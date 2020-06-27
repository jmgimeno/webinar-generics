{-# language DataKinds, DeriveGeneric, ScopedTypeVariables, TypeApplications #-}
module Main (main) where

import Data.Proxy
import qualified GHC.Generics as GHC
import Task
import Test.Hspec
import Test.Hspec.QuickCheck
import Test.QuickCheck.Arbitrary.Generic

data Person = Person { name :: String, age :: Int }
            deriving (Show, GHC.Generic)

instance Arbitrary Person where
  arbitrary = genericArbitrary

main :: IO ()
main = hspec $ do
  prop "should return the name" $
    \(p :: Person) -> get (Proxy @"name") p == name p
  prop "should return the age" $
      \(p :: Person) -> get (Proxy @"age") p == age p