{-# LANGUAGE TemplateHaskell #-}

module Rattletrap.Type.AttributeValue where

import Rattletrap.Type.Common
import qualified Rattletrap.Type.Attribute.AppliedDamage as AppliedDamage
import qualified Rattletrap.Type.Attribute.Boolean as Boolean
import qualified Rattletrap.Type.Attribute.Byte as Byte
import qualified Rattletrap.Type.Attribute.CamSettings as CamSettings
import qualified Rattletrap.Type.Attribute.ClubColors as ClubColors
import qualified Rattletrap.Type.Attribute.CustomDemolish as CustomDemolish
import qualified Rattletrap.Type.Attribute.DamageState as DamageState
import qualified Rattletrap.Type.Attribute.Demolish as Demolish
import qualified Rattletrap.Type.Attribute.Enum as Enum
import qualified Rattletrap.Type.Attribute.Explosion as Explosion
import qualified Rattletrap.Type.Attribute.ExtendedExplosion as ExtendedExplosion
import qualified Rattletrap.Type.Attribute.FlaggedByte as FlaggedByte
import qualified Rattletrap.Type.Attribute.FlaggedInt as FlaggedInt
import qualified Rattletrap.Type.Attribute.Float as Float
import qualified Rattletrap.Type.Attribute.GameMode as GameMode
import qualified Rattletrap.Type.Attribute.Int64 as Int64
import qualified Rattletrap.Type.Attribute.Int as Int
import qualified Rattletrap.Type.Attribute.Loadout as Loadout
import qualified Rattletrap.Type.Attribute.LoadoutOnline as LoadoutOnline
import qualified Rattletrap.Type.Attribute.Loadouts as Loadouts
import qualified Rattletrap.Type.Attribute.LoadoutsOnline as LoadoutsOnline
import qualified Rattletrap.Type.Attribute.Location as Location
import qualified Rattletrap.Type.Attribute.MusicStinger as MusicStinger
import qualified Rattletrap.Type.Attribute.PartyLeader as PartyLeader
import qualified Rattletrap.Type.Attribute.Pickup as Pickup
import qualified Rattletrap.Type.Attribute.PickupNew as PickupNew
import qualified Rattletrap.Type.Attribute.PlayerHistoryKey as PlayerHistoryKey
import qualified Rattletrap.Type.Attribute.PrivateMatchSettings as PrivateMatchSettings
import qualified Rattletrap.Type.Attribute.QWord as QWord
import qualified Rattletrap.Type.Attribute.Reservation as Reservation
import qualified Rattletrap.Type.Attribute.RigidBodyState as RigidBodyState
import qualified Rattletrap.Type.Attribute.StatEvent as StatEvent
import qualified Rattletrap.Type.Attribute.String as String
import qualified Rattletrap.Type.Attribute.TeamPaint as TeamPaint
import qualified Rattletrap.Type.Attribute.Title as Title
import qualified Rattletrap.Type.Attribute.UniqueId as UniqueId
import qualified Rattletrap.Type.Attribute.WeldedInfo as WeldedInfo
import qualified Rattletrap.Data as Data
import Rattletrap.Decode.Common
import qualified Rattletrap.Type.AttributeType as AttributeType
import qualified Rattletrap.Type.Str as Str
import qualified Rattletrap.Type.U32 as U32
import Rattletrap.Encode.Common

import qualified Data.Map as Map

data AttributeValue
  = AppliedDamage AppliedDamage.AppliedDamageAttribute
  | Boolean Boolean.BooleanAttribute
  | Byte Byte.ByteAttribute
  | CamSettings CamSettings.CamSettingsAttribute
  | ClubColors ClubColors.ClubColorsAttribute
  | CustomDemolish CustomDemolish.CustomDemolishAttribute
  | DamageState DamageState.DamageStateAttribute
  | Demolish Demolish.DemolishAttribute
  | Enum Enum.EnumAttribute
  | Explosion Explosion.ExplosionAttribute
  | ExtendedExplosion ExtendedExplosion.ExtendedExplosionAttribute
  | FlaggedInt FlaggedInt.FlaggedIntAttribute
  | FlaggedByte FlaggedByte.FlaggedByteAttribute
  | Float Float.FloatAttribute
  | GameMode GameMode.GameModeAttribute
  | Int Int.IntAttribute
  | Int64 Int64.Int64Attribute
  | Loadout Loadout.LoadoutAttribute
  | LoadoutOnline LoadoutOnline.LoadoutOnlineAttribute
  | Loadouts Loadouts.LoadoutsAttribute
  | LoadoutsOnline LoadoutsOnline.LoadoutsOnlineAttribute
  | Location Location.LocationAttribute
  | MusicStinger MusicStinger.MusicStingerAttribute
  | PartyLeader PartyLeader.PartyLeaderAttribute
  | Pickup Pickup.PickupAttribute
  | PickupNew PickupNew.PickupNewAttribute
  | PlayerHistoryKey PlayerHistoryKey.PlayerHistoryKeyAttribute
  | PrivateMatchSettings PrivateMatchSettings.PrivateMatchSettingsAttribute
  | QWord QWord.QWordAttribute
  | Reservation Reservation.ReservationAttribute
  | RigidBodyState RigidBodyState.RigidBodyStateAttribute
  | StatEvent StatEvent.StatEventAttribute
  | String String.StringAttribute
  | TeamPaint TeamPaint.TeamPaintAttribute
  | Title Title.TitleAttribute
  | UniqueId UniqueId.UniqueIdAttribute
  | WeldedInfo WeldedInfo.WeldedInfoAttribute
  deriving (Eq, Show)

$(deriveJson ''AttributeValue)

bitPut :: AttributeValue -> BitPut ()
bitPut value = case value of
  AppliedDamage x -> AppliedDamage.bitPut x
  Boolean x -> Boolean.bitPut x
  Byte x -> Byte.bitPut x
  CamSettings x -> CamSettings.bitPut x
  ClubColors x -> ClubColors.bitPut x
  CustomDemolish x -> CustomDemolish.bitPut x
  DamageState x -> DamageState.bitPut x
  Demolish x -> Demolish.bitPut x
  Enum x -> Enum.bitPut x
  Explosion x -> Explosion.bitPut x
  ExtendedExplosion x -> ExtendedExplosion.bitPut x
  FlaggedInt x -> FlaggedInt.bitPut x
  FlaggedByte x -> FlaggedByte.bitPut x
  Float x -> Float.bitPut x
  GameMode x -> GameMode.bitPut x
  Int x -> Int.bitPut x
  Int64 x -> Int64.putInt64Attribute x
  Loadout x -> Loadout.bitPut x
  LoadoutOnline x -> LoadoutOnline.bitPut x
  Loadouts x -> Loadouts.bitPut x
  LoadoutsOnline x -> LoadoutsOnline.bitPut x
  Location x -> Location.bitPut x
  MusicStinger x -> MusicStinger.bitPut x
  PartyLeader x -> PartyLeader.bitPut x
  Pickup x -> Pickup.bitPut x
  PickupNew x -> PickupNew.bitPut x
  PlayerHistoryKey x -> PlayerHistoryKey.bitPut x
  PrivateMatchSettings x -> PrivateMatchSettings.bitPut x
  QWord x -> QWord.bitPut x
  Reservation x -> Reservation.bitPut x
  RigidBodyState x -> RigidBodyState.bitPut x
  StatEvent x -> StatEvent.bitPut x
  String x -> String.bitPut x
  TeamPaint x -> TeamPaint.bitPut x
  Title x -> Title.bitPut x
  UniqueId x -> UniqueId.bitPut x
  WeldedInfo x -> WeldedInfo.bitPut x

bitGet
  :: (Int, Int, Int) -> Map U32.U32 Str.Str -> Str.Str -> BitGet AttributeValue
bitGet version objectMap name = do
  constructor <- maybe
    (fail ("[RT04] don't know how to get attribute value " <> show name))
    pure
    (Map.lookup (Str.toText name) Data.attributeTypes)
  case constructor of
    AttributeType.AppliedDamage -> AppliedDamage <$> AppliedDamage.bitGet version
    AttributeType.Boolean -> Boolean <$> Boolean.bitGet
    AttributeType.Byte -> Byte <$> Byte.bitGet
    AttributeType.CamSettings -> CamSettings <$> CamSettings.bitGet version
    AttributeType.ClubColors -> ClubColors <$> ClubColors.bitGet
    AttributeType.CustomDemolish -> CustomDemolish <$> CustomDemolish.bitGet version
    AttributeType.DamageState -> DamageState <$> DamageState.bitGet version
    AttributeType.Demolish -> Demolish <$> Demolish.bitGet version
    AttributeType.Enum -> Enum <$> Enum.bitGet
    AttributeType.Explosion -> Explosion <$> Explosion.bitGet version
    AttributeType.ExtendedExplosion -> ExtendedExplosion <$> ExtendedExplosion.bitGet version
    AttributeType.FlaggedInt -> FlaggedInt <$> FlaggedInt.bitGet
    AttributeType.FlaggedByte -> FlaggedByte <$> FlaggedByte.bitGet
    AttributeType.Float -> Float <$> Float.bitGet
    AttributeType.GameMode -> GameMode <$> GameMode.bitGet version
    AttributeType.Int -> Int <$> Int.bitGet
    AttributeType.Int64 -> Int64 <$> Int64.bitGet
    AttributeType.Loadout -> Loadout <$> Loadout.bitGet
    AttributeType.LoadoutOnline -> LoadoutOnline <$> LoadoutOnline.bitGet version objectMap
    AttributeType.Loadouts -> Loadouts <$> Loadouts.bitGet
    AttributeType.LoadoutsOnline -> LoadoutsOnline <$> LoadoutsOnline.bitGet version objectMap
    AttributeType.Location -> Location <$> Location.bitGet version
    AttributeType.MusicStinger -> MusicStinger <$> MusicStinger.bitGet
    AttributeType.PartyLeader -> PartyLeader <$> PartyLeader.bitGet version
    AttributeType.Pickup -> Pickup <$> Pickup.bitGet
    AttributeType.PickupNew -> PickupNew <$> PickupNew.bitGet
    AttributeType.PlayerHistoryKey -> PlayerHistoryKey <$> PlayerHistoryKey.bitGet
    AttributeType.PrivateMatchSettings -> PrivateMatchSettings <$> PrivateMatchSettings.bitGet
    AttributeType.QWord -> QWord <$> QWord.bitGet
    AttributeType.Reservation -> Reservation <$> Reservation.bitGet version
    AttributeType.RigidBodyState -> RigidBodyState <$> RigidBodyState.bitGet version
    AttributeType.StatEvent -> StatEvent <$> StatEvent.bitGet
    AttributeType.String -> String <$> String.bitGet
    AttributeType.TeamPaint -> TeamPaint <$> TeamPaint.bitGet
    AttributeType.Title -> Title <$> Title.bitGet
    AttributeType.UniqueId -> UniqueId <$> UniqueId.bitGet version
    AttributeType.WeldedInfo -> WeldedInfo <$> WeldedInfo.bitGet version
