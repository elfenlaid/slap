{-# LANGUAGE OverloadedStrings #-}

module Data.Aeson.Slap.Types (
      Profile(..)
    , User (..)
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
                         v .: "profile"
    parseJSON _          = mzero      
