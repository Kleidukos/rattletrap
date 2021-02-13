{-# LANGUAGE TemplateHaskell #-}

module Rattletrap.Type.Attribute.UniqueId where

import Rattletrap.Type.Common
import Rattletrap.Type.RemoteId
import Rattletrap.Type.Word8le
import Rattletrap.Decode.Common
import Rattletrap.Encode.Common

data UniqueIdAttribute = UniqueIdAttribute
  { uniqueIdAttributeSystemId :: Word8le
  , uniqueIdAttributeRemoteId :: RemoteId
  , uniqueIdAttributeLocalId :: Word8le
  }
  deriving (Eq, Show)

$(deriveJson ''UniqueIdAttribute)

putUniqueIdAttribute :: UniqueIdAttribute -> BitPut ()
putUniqueIdAttribute uniqueIdAttribute = do
  putWord8Bits (uniqueIdAttributeSystemId uniqueIdAttribute)
  putRemoteId (uniqueIdAttributeRemoteId uniqueIdAttribute)
  putWord8Bits (uniqueIdAttributeLocalId uniqueIdAttribute)

decodeUniqueIdAttributeBits :: (Int, Int, Int) -> BitGet UniqueIdAttribute
decodeUniqueIdAttributeBits version = do
  systemId <- decodeWord8leBits
  UniqueIdAttribute systemId
    <$> decodeRemoteIdBits version systemId
    <*> decodeWord8leBits
