{-# LANGUAGE OverloadedStrings #-}

module Data.Aeson.Slap.Types (
      Profile
    , User
    , Self
    , Channel
    , IM
    , Group
    , ConfContext
    , Data.Slap.Types.Error
    ) where

import Data.Aeson
import Control.Applicative
import Data.Slap.Types
import Control.Monad

instance FromJSON Profile where
    parseJSON (Object v) = Profile <$>
                         v .:? "first_name" <*>
                         v .:? "last_name" <*>
                         v .:? "real_name" <*>
                         v .:? "email"
    parseJSON _          = mzero

instance FromJSON User where
    parseJSON (Object v) = User <$>
                         v .: "id" <*>
                         v .: "name" <*>
                         v .: "deleted" <*>
                         v .:? "profile"
    parseJSON _          = mzero

instance FromJSON Self where
    parseJSON (Object v) = Self <$>
                         v .: "id" <*>
                         v .: "name"
    parseJSON _          = mzero

instance FromJSON Channel where
    parseJSON (Object v) = Channel <$>
                         v .: "id" <*>
                         v .: "name" <*>
                         v .:? "members"
    parseJSON _          = mzero

instance FromJSON IM where
    parseJSON (Object v) = IM <$>
                         v .: "id" <*>
                         v .: "user"
    parseJSON _          = mzero

instance FromJSON Group where
    parseJSON (Object v) = Group <$>
                         v .: "id" <*>
                         v .: "name" <*>
                         v .:? "members"
    parseJSON _          = mzero

instance FromJSON ConfContext where
    parseJSON (Object v) = ConfContext <$>
                         v .: "self" <*>
                         v .: "users" <*>
                         v .: "channels" <*>
                         v .: "ims" <*>
                         v .: "groups"
    parseJSON _          = mzero

instance FromJSON Error where
    parseJSON (Object v) = Data.Slap.Types.Error <$>
                         v .: "code" <*>
                         v .: "msg"
    parseJSON _          = mzero
