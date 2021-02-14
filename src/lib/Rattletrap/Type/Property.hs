{-# LANGUAGE TemplateHaskell #-}

module Rattletrap.Type.Property where

import Rattletrap.Type.Common
import qualified Rattletrap.Type.PropertyValue as PropertyValue
import qualified Rattletrap.Type.Str as Str
import qualified Rattletrap.Type.U64 as U64
import Rattletrap.Decode.Common
import Rattletrap.Encode.Common

data Property = Property
  { kind :: Str.Str
  , size :: U64.U64
  -- ^ Not used.
  , value :: PropertyValue.PropertyValue Property
  }
  deriving (Eq, Show)

$(deriveJson ''Property)

bytePut :: Property -> BytePut
bytePut property = do
  Str.bytePut (kind property)
  U64.bytePut (size property)
  PropertyValue.bytePut bytePut (value property)

byteGet :: ByteGet Property
byteGet = do
  kind_ <- Str.byteGet
  Property kind_ <$> U64.byteGet <*> PropertyValue.byteGet byteGet kind_
