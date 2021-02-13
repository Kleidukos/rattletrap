{-# LANGUAGE TemplateHaskell #-}

module Rattletrap.Type.QWordAttribute where

import Rattletrap.Type.Common
import Rattletrap.Type.Word64le
import Rattletrap.Decode.Common

import qualified Data.Binary.Bits.Put as BinaryBits

newtype QWordAttribute = QWordAttribute
  { qWordAttributeValue :: Word64le
  } deriving (Eq, Ord, Show)

$(deriveJson ''QWordAttribute)

putQWordAttribute :: QWordAttribute -> BinaryBits.BitPut ()
putQWordAttribute qWordAttribute =
  putWord64Bits (qWordAttributeValue qWordAttribute)

decodeQWordAttributeBits :: DecodeBits QWordAttribute
decodeQWordAttributeBits = QWordAttribute <$> decodeWord64leBits
