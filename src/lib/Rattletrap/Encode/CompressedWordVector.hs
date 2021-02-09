module Rattletrap.Encode.CompressedWordVector
  ( putCompressedWordVector
  ) where

import Rattletrap.Encode.CompressedWord
import Rattletrap.Type.CompressedWordVector

import qualified Data.Binary.Bits.Put as BinaryBits

putCompressedWordVector :: CompressedWordVector -> BinaryBits.BitPut ()
putCompressedWordVector compressedWordVector = do
  putCompressedWord (compressedWordVectorX compressedWordVector)
  putCompressedWord (compressedWordVectorY compressedWordVector)
  putCompressedWord (compressedWordVectorZ compressedWordVector)
