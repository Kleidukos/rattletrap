module Rattletrap.Encode.RemoteId
  ( putRemoteId
  )
where

import Rattletrap.Encode.Bitstream
import Rattletrap.Encode.Word64le
import Rattletrap.Type.RemoteId
import Rattletrap.Utility.Bytes

import qualified Data.Binary.Bits.Put as BinaryBits
import qualified Data.ByteString as Bytes

putRemoteId :: RemoteId -> BinaryBits.BitPut ()
putRemoteId remoteId = case remoteId of
  RemoteIdPlayStation name bytes -> do
    let rawName = reverseBytes (padBytes (16 :: Int) (encodeLatin1 name))
    BinaryBits.putByteString rawName
    BinaryBits.putByteString (Bytes.pack bytes)
  RemoteIdPsyNet x -> putBitstream x
  RemoteIdSplitscreen word24 -> BinaryBits.putWord32be 24 word24
  RemoteIdSteam word64 -> putWord64Bits word64
  RemoteIdSwitch a b c d -> do
    putWord64Bits a
    putWord64Bits b
    putWord64Bits c
    putWord64Bits d
  RemoteIdXbox word64 -> putWord64Bits word64
