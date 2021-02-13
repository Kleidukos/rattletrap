{-# LANGUAGE TemplateHaskell #-}

module Rattletrap.Type.Attribute where

import Rattletrap.Type.AttributeValue
import Rattletrap.Type.Common
import Rattletrap.Type.CompressedWord
import Rattletrap.Type.Str
import Rattletrap.Decode.Common
import Rattletrap.Type.ClassAttributeMap
import Rattletrap.Type.Word32le
import Rattletrap.Encode.Common

import qualified Data.Binary.Bits.Put as BinaryBits

data Attribute = Attribute
  { attributeId :: CompressedWord
  , attributeName :: Str
  -- ^ Read-only! Changing an attribute's name requires editing the class
  -- attribute map.
  , attributeValue :: AttributeValue
  }
  deriving (Eq, Show)

$(deriveJson ''Attribute)

putAttributes :: [Attribute] -> BitPut ()
putAttributes attributes = case attributes of
  [] -> BinaryBits.putBool False
  [attribute] -> do
    putAttribute attribute
    BinaryBits.putBool False
  first : rest -> do
    putAttribute first
    putAttributes rest

putAttribute :: Attribute -> BitPut ()
putAttribute attribute = do
  BinaryBits.putBool True
  putCompressedWord (attributeId attribute)
  putAttributeValue (attributeValue attribute)

decodeAttributesBits
  :: (Int, Int, Int)
  -> ClassAttributeMap
  -> Map CompressedWord Word32le
  -> CompressedWord
  -> BitGet [Attribute]
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
  -> BitGet Attribute
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
  -> BitGet (Map Word32le Word32le)
lookupAttributeMap classes actors actor = fromMaybe
  ("[RT01] could not get attribute map for " <> show actor)
  (getAttributeMap classes actors actor)

lookupAttributeIdLimit
  :: Map Word32le Word32le -> CompressedWord -> BitGet Word
lookupAttributeIdLimit attributes actor = fromMaybe
  ("[RT02] could not get attribute ID limit for " <> show actor)
  (getAttributeIdLimit attributes)

lookupAttributeName
  :: ClassAttributeMap
  -> Map Word32le Word32le
  -> CompressedWord
  -> BitGet Str
lookupAttributeName classes attributes attribute = fromMaybe
  ("[RT03] could not get attribute name for " <> show attribute)
  (getAttributeName classes attributes attribute)

fromMaybe :: String -> Maybe a -> BitGet a
fromMaybe message = maybe (fail message) pure
