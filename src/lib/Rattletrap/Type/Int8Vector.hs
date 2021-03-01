module Rattletrap.Type.Int8Vector where

import qualified Rattletrap.BitGet as BitGet
import qualified Rattletrap.BitPut as BitPut
import qualified Rattletrap.Schema as Schema
import qualified Rattletrap.Type.I8 as I8
import qualified Rattletrap.Utility.Json as Json
import Rattletrap.Utility.Monad

data Int8Vector = Int8Vector
  { x :: Maybe I8.I8
  , y :: Maybe I8.I8
  , z :: Maybe I8.I8
  }
  deriving (Eq, Show)

instance Json.FromJSON Int8Vector where
  parseJSON = Json.withObject "Int8Vector" $ \object -> do
    x <- Json.optional object "x"
    y <- Json.optional object "y"
    z <- Json.optional object "z"
    pure Int8Vector { x, y, z }

instance Json.ToJSON Int8Vector where
  toJSON a =
    Json.object [Json.pair "x" $ x a, Json.pair "y" $ y a, Json.pair "z" $ z a]

schema :: Schema.Schema
schema = Schema.named "int8Vector" $ Schema.object
  [ (Json.pair "x" . Schema.json $ Schema.maybe I8.schema, False)
  , (Json.pair "y" . Schema.json $ Schema.maybe I8.schema, False)
  , (Json.pair "z" . Schema.json $ Schema.maybe I8.schema, False)
  ]

bitPut :: Int8Vector -> BitPut.BitPut
bitPut int8Vector =
  putInt8VectorField (x int8Vector)
    <> putInt8VectorField (y int8Vector)
    <> putInt8VectorField (z int8Vector)

putInt8VectorField :: Maybe I8.I8 -> BitPut.BitPut
putInt8VectorField maybeField = case maybeField of
  Nothing -> BitPut.bool False
  Just field -> BitPut.bool True <> I8.bitPut field

bitGet :: BitGet.BitGet Int8Vector
bitGet =
  Int8Vector <$> decodeFieldBits <*> decodeFieldBits <*> decodeFieldBits

decodeFieldBits :: BitGet.BitGet (Maybe I8.I8)
decodeFieldBits = do
  hasField <- BitGet.bool
  whenMaybe hasField I8.bitGet
