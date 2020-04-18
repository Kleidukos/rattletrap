module Rattletrap.Decode.Attribute
  ( decodeAttributesBits
  )
where

import Rattletrap.Decode.AttributeValue
import Rattletrap.Decode.Common
import Rattletrap.Decode.CompressedWord
import Rattletrap.Type.Attribute
import Rattletrap.Type.ClassAttributeMap
import Rattletrap.Type.Common
import Rattletrap.Type.CompressedWord
import Rattletrap.Type.Str
import Rattletrap.Type.Word32le

decodeAttributesBits
  :: (Int, Int, Int)
  -> ClassAttributeMap
  -> Map CompressedWord Word32le
  -> CompressedWord
  -> DecodeBits [Attribute]
decodeAttributesBits version classes actors actor = do
  hasAttribute <- getBool
  if hasAttribute
    then
      (:)
      <$> decodeAttributeBits version classes actors actor
      <*> decodeAttributesBits version classes actors actor
    else pure []

decodeAttributeBits
  :: (Int, Int, Int)
  -> ClassAttributeMap
  -> Map CompressedWord Word32le
  -> CompressedWord
  -> DecodeBits Attribute
decodeAttributeBits version classes actors actor = do
  attributes <- lookupAttributeMap classes actors actor
  limit <- lookupAttributeIdLimit attributes actor
  attribute <- decodeCompressedWordBits limit
  name <- lookupAttributeName classes attributes attribute
  Attribute attribute name
    <$> decodeAttributeValueBits
          version
          (classAttributeMapObjectMap classes)
          name

lookupAttributeMap
  :: ClassAttributeMap
  -> Map CompressedWord Word32le
  -> CompressedWord
  -> DecodeBits (Map Word32le Word32le)
lookupAttributeMap classes actors actor = fromMaybe
  ("[RT01] could not get attribute map for " <> show actor)
  (getAttributeMap classes actors actor)

lookupAttributeIdLimit
  :: Map Word32le Word32le -> CompressedWord -> DecodeBits Word
lookupAttributeIdLimit attributes actor = fromMaybe
  ("[RT02] could not get attribute ID limit for " <> show actor)
  (getAttributeIdLimit attributes)

lookupAttributeName
  :: ClassAttributeMap
  -> Map Word32le Word32le
  -> CompressedWord
  -> DecodeBits Str
lookupAttributeName classes attributes attribute = fromMaybe
  ("[RT03] could not get attribute name for " <> show attribute)
  (getAttributeName classes attributes attribute)

fromMaybe :: String -> Maybe a -> DecodeBits a
fromMaybe message = maybe (fail message) pure
