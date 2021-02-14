{-# LANGUAGE TemplateHaskell #-}

module Rattletrap.Type.Attribute.PickupNew where

import Rattletrap.Type.Common
import qualified Rattletrap.Type.U32 as U32
import qualified Rattletrap.Type.U8 as U8
import Rattletrap.Decode.Common
import qualified Rattletrap.BitPut as BitPut

data PickupNew = PickupNew
  { instigatorId :: Maybe U32.U32
  , pickedUp :: U8.U8
  }
  deriving (Eq, Show)

$(deriveJson ''PickupNew)

bitPut :: PickupNew -> BitPut.BitPut
bitPut pickupAttributeNew = do
  case instigatorId pickupAttributeNew of
    Nothing -> BitPut.bool False
    Just instigatorId_ -> do
      BitPut.bool True
      U32.bitPut instigatorId_
  U8.bitPut (pickedUp pickupAttributeNew)

bitGet :: BitGet PickupNew
bitGet = do
  instigator <- getBool
  PickupNew
    <$> decodeWhen instigator U32.bitGet
    <*> U8.bitGet
