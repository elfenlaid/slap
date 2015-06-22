{-# LANGUAGE OverloadedStrings #-}

odule Data.Aeson.Slap.Types (
      Profile(..)
    , User (..)
    ) where

import Data.Aeson
import Control.Applicative
import Data.Slap.Types

instance FromJSON Profile where
    parseJSON (Object v) = Profile <$>
                         v .:? "first_name" <*>
                         v .:? "last_name" <*>
                         v .:? "real_name" <*>
                         v .:? "email"
    parseJSON _          = mzero      

instance FromJson User where 
    parseJSON (Object v) = User <$>
                         v .: "id" <*>
                         v .: "name" <*>
                         v .: "deleted" <*>
                         v .: "profile"
