module Rattletrap.Encode.Int8le
  ( putInt8Bits
  )
where

import Rattletrap.Type.Int8le
import Rattletrap.Utility.Bytes

import qualified Data.Binary.Bits.Put as BinaryBits
import qualified Data.Binary.Put as Binary
import qualified Data.ByteString.Lazy as LazyBytes

putInt8 :: Int8le -> Binary.Put
putInt8 int8 = Binary.putInt8 (int8leValue int8)

putInt8Bits :: Int8le -> BinaryBits.BitPut ()
putInt8Bits int8 = do
  let bytes = LazyBytes.toStrict (Binary.runPut (putInt8 int8))
  BinaryBits.putByteString (reverseBytes bytes)
