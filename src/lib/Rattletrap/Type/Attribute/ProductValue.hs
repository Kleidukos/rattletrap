module Rattletrap.Type.Attribute.ProductValue where

import qualified Data.Foldable as Foldable
import qualified Data.Word as Word
import qualified Rattletrap.BitGet as BitGet
import qualified Rattletrap.BitPut as BitPut
import qualified Rattletrap.Schema as Schema
import qualified Rattletrap.Type.CompressedWord as CompressedWord
import qualified Rattletrap.Type.Str as Str
import qualified Rattletrap.Type.U32 as U32
import qualified Rattletrap.Type.Version as Version
import qualified Rattletrap.Utility.Json as Json
import qualified Rattletrap.Utility.Monad as Monad

data ProductValue
  = PaintedOld CompressedWord.CompressedWord
  | PaintedNew Word.Word32
  | TeamEditionOld CompressedWord.CompressedWord
  | TeamEditionNew Word.Word32
  | SpecialEdition Word.Word32
  | UserColorOld (Maybe Word.Word32)
  | UserColorNew U32.U32
  | TitleId Str.Str
  deriving (Eq, Show)

instance Json.FromJSON ProductValue where
  parseJSON = Json.withObject "ProductValue" $ \object -> Foldable.asum
    [ fmap PaintedOld $ Json.required object "painted_old"
    , fmap PaintedNew $ Json.required object "painted_new"
    , fmap TeamEditionOld $ Json.required object "team_edition_old"
    , fmap TeamEditionNew $ Json.required object "team_edition_new"
    , fmap SpecialEdition $ Json.required object "special_edition"
    , fmap UserColorOld $ Json.required object "user_color_old"
    , fmap UserColorNew $ Json.required object "user_color_new"
    , fmap TitleId $ Json.required object "title_id"
    ]

instance Json.ToJSON ProductValue where
  toJSON x = case x of
    PaintedOld y -> Json.object [Json.pair "painted_old" y]
    PaintedNew y -> Json.object [Json.pair "painted_new" y]
    TeamEditionOld y -> Json.object [Json.pair "team_edition_old" y]
    TeamEditionNew y -> Json.object [Json.pair "team_edition_new" y]
    SpecialEdition y -> Json.object [Json.pair "special_edition" y]
    UserColorOld y -> Json.object [Json.pair "user_color_old" y]
    UserColorNew y -> Json.object [Json.pair "user_color_new" y]
    TitleId y -> Json.object [Json.pair "title_id" y]

schema :: Schema.Schema
schema = Schema.named "attribute-product-value" . Schema.oneOf $ fmap
  (\(k, v) -> Schema.object [(Json.pair k v, True)])
  [ ("painted_old", Schema.ref CompressedWord.schema)
  , ("painted_new", Schema.ref Schema.integer)
  , ("team_edition_old", Schema.ref CompressedWord.schema)
  , ("team_edition_new", Schema.ref Schema.integer)
  , ("special_edition", Schema.ref Schema.integer)
  , ("user_color_old", Schema.json $ Schema.maybe Schema.integer)
  , ("user_color_new", Schema.ref U32.schema)
  , ("title_id", Schema.ref Str.schema)
  ]

bitPut :: ProductValue -> BitPut.BitPut
bitPut val = case val of
  PaintedOld x -> CompressedWord.bitPut x
  PaintedNew x -> BitPut.bits 31 x
  TeamEditionOld x -> CompressedWord.bitPut x
  TeamEditionNew x -> BitPut.bits 31 x
  SpecialEdition x -> BitPut.bits 31 x
  UserColorOld x -> case x of
    Nothing -> BitPut.bool False
    Just y -> BitPut.bool True <> BitPut.bits 31 y
  UserColorNew x -> U32.bitPut x
  TitleId x -> Str.bitPut x

bitGet
  :: Version.Version -> U32.U32 -> Maybe Str.Str -> BitGet.BitGet ProductValue
bitGet version objectId maybeObjectName =
  case fmap Str.toString maybeObjectName of
    Just "TAGame.ProductAttribute_Painted_TA" -> decodePainted version
    Just "TAGame.ProductAttribute_SpecialEdition_TA" -> decodeSpecialEdition
    Just "TAGame.ProductAttribute_TeamEdition_TA" -> decodeTeamEdition version
    Just "TAGame.ProductAttribute_TitleID_TA" -> decodeTitle
    Just "TAGame.ProductAttribute_UserColor_TA" -> decodeColor version
    Just objectName -> fail
      ("[RT05] unknown object name "
      <> show objectName
      <> " for ID "
      <> show objectId
      )
    Nothing -> fail ("[RT06] missing object name for ID " <> show objectId)

decodeSpecialEdition :: BitGet.BitGet ProductValue
decodeSpecialEdition = fmap SpecialEdition $ BitGet.bits 31

decodePainted :: Version.Version -> BitGet.BitGet ProductValue
decodePainted version = if hasNewPainted version
  then fmap PaintedNew $ BitGet.bits 31
  else fmap PaintedOld $ CompressedWord.bitGet 13

decodeTeamEdition :: Version.Version -> BitGet.BitGet ProductValue
decodeTeamEdition version = if hasNewPainted version
  then fmap TeamEditionNew $ BitGet.bits 31
  else fmap TeamEditionOld $ CompressedWord.bitGet 13

decodeColor :: Version.Version -> BitGet.BitGet ProductValue
decodeColor version = if Version.atLeast 868 23 8 version
  then fmap UserColorNew U32.bitGet
  else do
    hasValue <- BitGet.bool
    fmap UserColorOld $ Monad.whenMaybe hasValue (BitGet.bits 31)

hasNewPainted :: Version.Version -> Bool
hasNewPainted = Version.atLeast 868 18 0

decodeTitle :: BitGet.BitGet ProductValue
decodeTitle = fmap TitleId Str.bitGet
