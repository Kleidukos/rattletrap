module Rattletrap.Encode.Cache
  ( putCache
  ) where

import Rattletrap.Encode.AttributeMapping
import Rattletrap.Encode.List
import Rattletrap.Encode.Word32le
import Rattletrap.Type.Cache

import qualified Data.Binary as Binary

putCache :: Cache -> Binary.Put
putCache cache = do
  putWord32 (cacheClassId cache)
  putWord32 (cacheParentCacheId cache)
  putWord32 (cacheCacheId cache)
  putList putAttributeMapping (cacheAttributeMappings cache)
