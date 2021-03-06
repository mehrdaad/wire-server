{-# LANGUAGE OverloadedStrings #-}

-- This file is part of the Wire Server implementation.
--
-- Copyright (C) 2020 Wire Swiss GmbH <opensource@wire.com>
--
-- This program is free software: you can redistribute it and/or modify it under
-- the terms of the GNU Affero General Public License as published by the Free
-- Software Foundation, either version 3 of the License, or (at your option) any
-- later version.
--
-- This program is distributed in the hope that it will be useful, but WITHOUT
-- ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
-- FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
-- details.
--
-- You should have received a copy of the GNU Affero General Public License along
-- with this program. If not, see <https://www.gnu.org/licenses/>.

module Galley.Types.IdMapping
  ( PostIdMappingRequest (..),
    mkPostIdMappingRequest,
    PostIdMappingResponse (..),
  )
where

import Data.Aeson
import Data.Coerce (coerce)
import Data.Id (Id, Mapped, Remote)
import Data.Qualified (Qualified)
import Imports

-- | Request used for inter-service communication between Galley and Brig to ensure that ID
-- mappings discovered in one service are also known in the other.
--
-- The type of Id (user or conversation) doesn't matter, since it's all the same table.
-- Therefore, we use @()@.
newtype PostIdMappingRequest = PostIdMappingRequest
  {reqQualifiedId :: Qualified (Id (Remote ()))}
  deriving stock (Eq, Show)

mkPostIdMappingRequest :: Qualified (Id (Remote a)) -> PostIdMappingRequest
mkPostIdMappingRequest = PostIdMappingRequest . coerce

instance ToJSON PostIdMappingRequest where
  toJSON (PostIdMappingRequest qualifiedId) =
    object ["qualified_id" .= qualifiedId]

instance FromJSON PostIdMappingRequest where
  parseJSON = withObject "PostIdMappingRequest" $ \o ->
    PostIdMappingRequest <$> o .: "qualified_id"

-- | Response used for inter-service communication between Galley and Brig to ensure that ID
-- mappings discovered in one service are also known in the other.
--
-- The type of Id (user or conversation) doesn't matter, since it's all the same table.
-- Therefore, we use @()@.
newtype PostIdMappingResponse = PostIdMappingResponse
  {resMappedId :: Id (Mapped ())}
  deriving stock (Eq, Show)

instance ToJSON PostIdMappingResponse where
  toJSON (PostIdMappingResponse mappedId) =
    object ["mapped_id" .= mappedId]

instance FromJSON PostIdMappingResponse where
  parseJSON = withObject "PostIdMappingResponse" $ \o ->
    PostIdMappingResponse <$> o .: "mapped_id"
