{-# LANGUAGE OverloadedStrings #-}

module Data.Aeson.Slap.Types (
      Profile(..)
    , User (..)
    , Self (..)
    , ConfContext (..)
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

instance FromJSON ConfContext where
    parseJSON (Object v) = ConfContext <$>
                         v .: "self" <*>
                         v .: "users"
    parseJSON _          = mzero   