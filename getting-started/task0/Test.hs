module Main (main) where

import Task
import Test.Hspec
import Test.Hspec.QuickCheck

main :: IO ()
main = hspec $ do
  prop "should return an even number" $
    \x -> even (multiplyByTwo x)
  prop "should be the result of summing with itself" $
    \x -> multiplyByTwo x == x + x