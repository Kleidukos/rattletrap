module Rattletrap.Encode.LoadoutAttribute
  ( putLoadoutAttribute
  )
where

import Rattletrap.Encode.Word32le
import Rattletrap.Encode.Word8le
import Rattletrap.Type.LoadoutAttribute

import qualified Data.Binary.Bits.Put as BinaryBits

putLoadoutAttribute :: LoadoutAttribute -> BinaryBits.BitPut ()
putLoadoutAttribute loadoutAttribute = do
  putWord8Bits (loadoutAttributeVersion loadoutAttribute)
  putWord32Bits (loadoutAttributeBody loadoutAttribute)
  putWord32Bits (loadoutAttributeDecal loadoutAttribute)
  putWord32Bits (loadoutAttributeWheels loadoutAttribute)
  putWord32Bits (loadoutAttributeRocketTrail loadoutAttribute)
  putWord32Bits (loadoutAttributeAntenna loadoutAttribute)
  putWord32Bits (loadoutAttributeTopper loadoutAttribute)
  putWord32Bits (loadoutAttributeUnknown1 loadoutAttribute)
  putOptional (loadoutAttributeUnknown2 loadoutAttribute) putWord32Bits
  putOptional (loadoutAttributeEngineAudio loadoutAttribute) putWord32Bits
  putOptional (loadoutAttributeTrail loadoutAttribute) putWord32Bits
  putOptional (loadoutAttributeGoalExplosion loadoutAttribute) putWord32Bits
  putOptional (loadoutAttributeBanner loadoutAttribute) putWord32Bits
  putOptional (loadoutAttributeUnknown3 loadoutAttribute) putWord32Bits
  putOptional (loadoutAttributeUnknown4 loadoutAttribute) putWord32Bits
  putOptional (loadoutAttributeUnknown5 loadoutAttribute) putWord32Bits
  putOptional (loadoutAttributeUnknown6 loadoutAttribute) putWord32Bits

putOptional :: Maybe a -> (a -> BinaryBits.BitPut ()) -> BinaryBits.BitPut ()
putOptional m f = case m of
  Just x -> f x
  Nothing -> pure ()
