{-# language DataKinds,
             DefaultSignatures,
             FlexibleContexts,
             FlexibleInstances,
             FunctionalDependencies,
             KindSignatures,
             PolyKinds,
             TypeFamilies,
             TypeOperators,
             UndecidableInstances #-}
module Task where

import Data.Kind
import Data.Proxy
import GHC.Generics
import GHC.TypeLits

get :: (Generic whole, GGet field (Rep whole) part)
    => Proxy field -> whole -> part
get field whole = gget field (from whole)

class GGet field repr part | repr field -> part where
  gget :: Proxy field -> repr x -> part

-- we cannot write it due to the functional dependency
-- instance GGet field U1 part where
--   gget = error "this should never be called"

instance (GGet field repr1 part, GGet field repr2 part) 
  => GGet field (repr1 :+: repr2) part where
    gget field (L1 a) = gget field a
    gget field (R1 b) = gget field b

instance GGet field repr part => GGet field (D1 d repr) part where
  gget field (M1 x) = gget field x 

instance GGet field repr part => GGet field (C1 c repr) part where
  gget field (M1 x) = gget field x

-- The big trick: check a product in order
-- =======================================

-- 1. if the field name coincides, we have found it
--    { field :: part, ..rest }
instance {-# OVERLAPS #-}
         GGet field (S1 ('MetaSel ('Just field) su ss ds) (K1 r part) :*: rest) part where
  gget _ (M1 (K1 x) :*: _) = x

-- 2. otherwise, keep working
--    { other, ..rest }
instance {-# OVERLAPPABLE #-}
         (GGet field rest part)
         => GGet field (other :*: rest) part where
  gget field (_ :*: x) = gget field x

-- 3. if we get to the end, it'd better be the field
--    { field :: part }
instance {-# OVERLAPS #-}
         GGet field (S1 ('MetaSel ('Just field) su ss ds) (K1 r part)) part where
  gget _ (M1 (K1 x)) = x  -- similar to case (1)

-- END OF FILE