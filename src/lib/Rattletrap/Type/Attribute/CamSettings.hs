module Rattletrap.Type.Attribute.CamSettings where

import qualified Rattletrap.BitGet as BitGet
import qualified Rattletrap.BitPut as BitPut
import Rattletrap.Type.Common
import qualified Rattletrap.Type.F32 as F32
import qualified Rattletrap.Type.Version as Version
import Rattletrap.Utility.Monad

data CamSettings = CamSettings
  { fov :: F32.F32
  , height :: F32.F32
  , angle :: F32.F32
  , distance :: F32.F32
  , stiffness :: F32.F32
  , swivelSpeed :: F32.F32
  , transitionSpeed :: Maybe F32.F32
  }
  deriving (Eq, Show)

$(deriveJson ''CamSettings)

bitPut :: CamSettings -> BitPut.BitPut
bitPut camSettingsAttribute =
  F32.bitPut (fov camSettingsAttribute)
    <> F32.bitPut (height camSettingsAttribute)
    <> F32.bitPut (angle camSettingsAttribute)
    <> F32.bitPut (distance camSettingsAttribute)
    <> F32.bitPut (stiffness camSettingsAttribute)
    <> F32.bitPut (swivelSpeed camSettingsAttribute)
    <> foldMap F32.bitPut (transitionSpeed camSettingsAttribute)

bitGet :: Version.Version -> BitGet.BitGet CamSettings
bitGet version =
  CamSettings
    <$> F32.bitGet
    <*> F32.bitGet
    <*> F32.bitGet
    <*> F32.bitGet
    <*> F32.bitGet
    <*> F32.bitGet
    <*> whenMaybe (hasTransitionSpeed version) F32.bitGet

hasTransitionSpeed :: Version.Version -> Bool
hasTransitionSpeed v =
  Version.major v >= 868 && Version.minor v >= 20 && Version.patch v >= 0
