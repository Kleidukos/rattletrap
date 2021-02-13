{-# LANGUAGE TemplateHaskell #-}

module Rattletrap.Type.Float32le where

import Rattletrap.Type.Common
import Rattletrap.Utility.Bytes
import Rattletrap.Decode.Common

import qualified Data.Binary as Binary
import qualified Data.Binary.Bits.Put as BinaryBits
import qualified Data.Binary.Put as Binary
import qualified Data.ByteString.Lazy as LazyBytes

newtype Float32le = Float32le
  { float32leValue :: Float
  } deriving (Eq, Ord, Show)

$(deriveJson ''Float32le)

putFloat32 :: Float32le -> Binary.Put
putFloat32 = Binary.putFloatle . float32leValue

putFloat32Bits :: Float32le -> BinaryBits.BitPut ()
putFloat32Bits float32 = do
  let bytes = LazyBytes.toStrict (Binary.runPut (putFloat32 float32))
  BinaryBits.putByteString (reverseBytes bytes)

decodeFloat32le :: Decode Float32le
decodeFloat32le = Float32le <$> getFloatle

decodeFloat32leBits :: DecodeBits Float32le
decodeFloat32leBits = toBits decodeFloat32le 4
