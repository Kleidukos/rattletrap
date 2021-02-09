module Rattletrap.Decode.Cache
  ( decodeCache
  ) where

import Rattletrap.Decode.AttributeMapping
import Rattletrap.Decode.Common
import Rattletrap.Decode.List
import Rattletrap.Decode.Word32le
import Rattletrap.Type.Cache

decodeCache :: Decode Cache
decodeCache =
  Cache
    <$> decodeWord32le
    <*> decodeWord32le
    <*> decodeWord32le
    <*> decodeList decodeAttributeMapping
