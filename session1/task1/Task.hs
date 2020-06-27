{-# language InstanceSigs,
             TypeFamilies,
             TypeOperators #-}
module Task where

import Common

data Address
  = Place { kind    :: Maybe PlaceKind
          , street  :: String
          , country :: String }
  | POBox { number  :: Int }
  deriving (Eq, Show)

data PlaceKind
  = Person
  | Company { name :: String }
  deriving (Eq, Show)

instance Generic Address where
  type Rep Address = (Field (Maybe PlaceKind) `And` Field String `And` Field String) `Or` Field Int

  from :: Address -> Rep Address
  from (Place k s c)
    = This (Field k `And` Field s `And` Field c)
  from (POBox n)
    = That (Field n)

  to :: Rep Address -> Address
  to (This (Field k `And` Field s `And` Field c)) = Place k s c
  to (That (Field n)) = POBox n
  
instance Generic PlaceKind where
  type Rep PlaceKind = Unit `Or` Field String

  from :: PlaceKind -> Rep PlaceKind
  from Person = This Unit
  from (Company n) = That (Field n)

  to :: Rep PlaceKind -> PlaceKind
  to (This Unit) = Person
  to (That (Field n)) = Company n

-- END OF FILE