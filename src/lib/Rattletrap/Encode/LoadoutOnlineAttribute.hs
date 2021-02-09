module Rattletrap.Encode.LoadoutOnlineAttribute
  ( putLoadoutOnlineAttribute
  ) where

import Rattletrap.Encode.ProductAttribute
import Rattletrap.Encode.Word8le
import Rattletrap.Type.LoadoutOnlineAttribute
import Rattletrap.Type.Word8le

import qualified Data.Binary.Bits.Put as BinaryBits

putLoadoutOnlineAttribute :: LoadoutOnlineAttribute -> BinaryBits.BitPut ()
putLoadoutOnlineAttribute loadoutAttribute = do
  let attributes = loadoutAttributeValue loadoutAttribute
  putWord8Bits (Word8le (fromIntegral (length attributes)))
  mapM_ putProductAttributes attributes
