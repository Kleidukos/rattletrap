{-# LANGUAGE TemplateHaskell #-}

module Rattletrap.Type.Attribute.AppliedDamage where

import Rattletrap.Type.Common
import qualified Rattletrap.Type.I32 as I32
import qualified Rattletrap.Type.Vector as Vector
import qualified Rattletrap.Type.U8 as U8
import Rattletrap.Decode.Common
import Rattletrap.Encode.Common

data AppliedDamageAttribute = AppliedDamageAttribute
  { unknown1 :: U8.U8
  , location :: Vector.Vector
  , unknown3 :: I32.I32
  , unknown4 :: I32.I32
  }
  deriving (Eq, Show)

$(deriveJson ''AppliedDamageAttribute)

bitPut :: AppliedDamageAttribute -> BitPut ()
bitPut appliedDamageAttribute = do
  U8.bitPut (unknown1 appliedDamageAttribute)
  Vector.bitPut (location appliedDamageAttribute)
  I32.bitPut (unknown3 appliedDamageAttribute)
  I32.bitPut (unknown4 appliedDamageAttribute)

bitGet
  :: (Int, Int, Int) -> BitGet AppliedDamageAttribute
bitGet version =
  AppliedDamageAttribute
    <$> U8.bitGet
    <*> Vector.bitGet version
    <*> I32.bitGet
    <*> I32.bitGet
