{-# LANGUAGE TemplateHaskell #-}

module Rattletrap.Type.Attribute.LoadoutOnline where

import Rattletrap.Type.Common
import qualified Rattletrap.Type.ProductAttribute as ProductAttribute
import qualified Rattletrap.Type.Word8le as Word8le
import Rattletrap.Decode.Common
import qualified Rattletrap.Type.Str as Str
import qualified Rattletrap.Type.Word32le as Word32le
import Rattletrap.Encode.Common

import qualified Control.Monad as Monad
import qualified Data.Map as Map

newtype LoadoutOnlineAttribute = LoadoutOnlineAttribute
  { loadoutAttributeValue :: [[ProductAttribute.ProductAttribute]]
  } deriving (Eq, Show)

$(deriveJson ''LoadoutOnlineAttribute)

putLoadoutOnlineAttribute :: LoadoutOnlineAttribute -> BitPut ()
putLoadoutOnlineAttribute loadoutAttribute = do
  let attributes = loadoutAttributeValue loadoutAttribute
  Word8le.bitPut (Word8le.fromWord8 (fromIntegral (length attributes)))
  mapM_ ProductAttribute.putProductAttributes attributes

decodeLoadoutOnlineAttributeBits
  :: (Int, Int, Int)
  -> Map.Map Word32le.Word32le Str.Str
  -> BitGet LoadoutOnlineAttribute
decodeLoadoutOnlineAttributeBits version objectMap = do
  size <- Word8le.bitGet
  LoadoutOnlineAttribute <$> Monad.replicateM
    (fromIntegral (Word8le.toWord8 size))
    (ProductAttribute.decodeProductAttributesBits version objectMap)
