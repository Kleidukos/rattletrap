module Rattletrap.Encode.Initialization
  ( putInitialization
  ) where

import Rattletrap.Encode.Int8Vector
import Rattletrap.Encode.Vector
import Rattletrap.Type.Initialization

import qualified Data.Binary.Bits.Put as BinaryBits

putInitialization :: Initialization -> BinaryBits.BitPut ()
putInitialization initialization = do
  case initializationLocation initialization of
    Nothing -> pure ()
    Just location -> putVector location
  case initializationRotation initialization of
    Nothing -> pure ()
    Just rotation -> putInt8Vector rotation
