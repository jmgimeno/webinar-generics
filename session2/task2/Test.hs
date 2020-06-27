module Main (main) where

import Task
import Test.Hspec
import Test.Hspec.QuickCheck
import Test.QuickCheck

instance Enumerate a => Enumerate (Maybe a)
instance Enumerate a => Enumerate [a]

enumerateMaybe :: Enumerate a => Int -> [Maybe a]
enumerateMaybe n
  | n <= 0    = []
  | otherwise = Nothing : map Just (enumerate n)

enumerateList :: Enumerate a => Int -> [[a]]
enumerateList n
  | n <= 0    = []
  | otherwise = [] : [ x : xs | (i, j) <- split n
                              , x <- enumerate i
                              , xs <- enumerateList j ]

main :: IO ()
main = hspec $ do
  prop "works for Maybe Int" $
    \n -> n >= 0 ==> enumerate n == (enumerateMaybe n :: [Maybe Int])
  prop "works for Maybe Bool" $
    \n -> n >= 0 ==> enumerate n == (enumerateMaybe n :: [Maybe Bool])
  prop "works for [Int]" $
    \n -> n >= 0 ==> let p = n `mod` 10 in enumerate p == (enumerateList p :: [[Int]])
  prop "works for [Bool]" $
    \n -> n >= 0 ==> let p = n `mod` 10 in enumerate p == (enumerateList p :: [[Bool]])