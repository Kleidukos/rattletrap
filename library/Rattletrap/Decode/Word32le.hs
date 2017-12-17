module Rattletrap.Decode.Word32le
  ( decodeWord32le
  , decodeWord32leBits
  ) where

import Rattletrap.Decode.Common
import Rattletrap.Type.Word32le

import qualified Data.Binary.Get as Binary

decodeWord32le :: Decode Word32le
decodeWord32le = Word32le <$> Binary.getWord32le

decodeWord32leBits :: DecodeBits Word32le
decodeWord32leBits = toBits decodeWord32le 4
