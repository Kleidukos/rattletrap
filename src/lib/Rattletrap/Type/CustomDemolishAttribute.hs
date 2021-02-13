{-# LANGUAGE TemplateHaskell #-}

module Rattletrap.Type.CustomDemolishAttribute where

import Rattletrap.Type.Common
import Rattletrap.Type.DemolishAttribute
import Rattletrap.Type.Int32le
import Rattletrap.Decode.Common

import qualified Data.Binary.Bits.Put as BinaryBits

data CustomDemolishAttribute = CustomDemolishAttribute
  { customDemolishAttributeFlag :: Bool
  , customDemolishAttributeId :: Int32le
  , customDemolishAttributeDemolish :: DemolishAttribute
  }
  deriving (Eq, Ord, Show)

$(deriveJson ''CustomDemolishAttribute)

putCustomDemolishAttribute :: CustomDemolishAttribute -> BinaryBits.BitPut ()
putCustomDemolishAttribute x = do
  BinaryBits.putBool (customDemolishAttributeFlag x)
  putInt32Bits (customDemolishAttributeId x)
  putDemolishAttribute (customDemolishAttributeDemolish x)

decodeCustomDemolishAttributeBits
  :: (Int, Int, Int) -> DecodeBits CustomDemolishAttribute
decodeCustomDemolishAttributeBits version =
  CustomDemolishAttribute
    <$> getBool
    <*> decodeInt32leBits
    <*> decodeDemolishAttributeBits version
