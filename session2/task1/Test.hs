{-# language ScopedTypeVariables #-}
module Main (main) where

import Task
import Test.Hspec
import Test.Hspec.QuickCheck

instance NotEq Int where
  neq = (/=)

instance NotEq a => NotEq [a]
instance NotEq a => NotEq (Maybe a)

main :: IO ()
main = hspec $ do
  prop "check with [Int]" $
    \(x :: [Int]) (y :: [Int]) -> (neq x y) == (x /= y)
  prop "check with Maybe Int" $
    \(x :: Maybe Int) (y :: Maybe Int) -> (neq x y) == (x /= y)