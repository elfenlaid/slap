module Data.Slap (
      Profile(..)
    , User(..)
    ) where 

import Data.Text (Text)

data Profile = Profile {
      profileFirstName :: Maybe Text
    , profileLastName  :: Maybe Text
    , profileRealName  :: Maybe Text
    , profileEmail     :: Maybe Text
    } deriving (Show, Eq)

data User = User { 
      userId      :: Text
    , userName    :: Text
    , userDeleted :: Bool
    , userProfile :: Profile
    } deriving (Show, Eq)