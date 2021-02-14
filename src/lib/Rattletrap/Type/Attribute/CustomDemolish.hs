{-# LANGUAGE TemplateHaskell #-}

module Rattletrap.Type.Attribute.CustomDemolish where

import Rattletrap.Type.Common
import qualified Rattletrap.Type.Attribute.Demolish as Demolish
import qualified Rattletrap.Type.I32 as I32
import qualified Rattletrap.BitPut as BitPut
import qualified Rattletrap.BitGet as BitGet

data CustomDemolish = CustomDemolish
  { flag :: Bool
  , id :: I32.I32
  , demolish :: Demolish.Demolish
  }
  deriving (Eq, Show)

$(deriveJson ''CustomDemolish)

bitPut :: CustomDemolish -> BitPut.BitPut
bitPut x = do
  BitPut.bool (flag x)
  I32.bitPut (Rattletrap.Type.Attribute.CustomDemolish.id x)
  Demolish.bitPut (demolish x)

bitGet
  :: (Int, Int, Int) -> BitGet.BitGet CustomDemolish
bitGet version =
  CustomDemolish
    <$> BitGet.bool
    <*> I32.bitGet
    <*> Demolish.bitGet version
