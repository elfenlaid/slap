module Data.Slap.Types (
      Profile(..)
    , User(..)
    , Self(..)
    , Channel(..)
    , IM(..)
    , Group(..)
    , ConfContext(..)
    , Error(..)
    , Id
    ) where

import Data.Text (Text)

type Id = Text

data Profile = Profile {
      profileFirstName :: Maybe Text
    , profileLastName  :: Maybe Text
    , profileRealName  :: Maybe Text
    , profileEmail     :: Maybe Text
    } deriving (Show, Eq)

data User = User {
      userId      :: Id
    , userName    :: Text
    , userDeleted :: Bool
    , userProfile :: Maybe Profile
    } deriving (Show, Eq)

data Self = Self {
      selfId   :: Id
    , selfName :: Text
    } deriving (Show, Eq)

data Channel = Channel {
      channelId      :: Id
    , channelName    :: Text
    , channelMembers :: Maybe [Id]
    } deriving (Show, Eq)

data IM = IM {
      imId       :: Id
    , imWithUser :: Id
    } deriving (Show, Eq)

data Group = Group {
      groupId      :: Id
    , groupName    :: Text
    , groupMembers :: Maybe [Id]
    } deriving (Show, Eq)

data ConfContext = ConfContext {
      confSelf     :: Self
    , confUsers    :: [User]
    , confChannels :: [Channel]
    , confIms      :: [IM]
    , confGroups   :: [Group]
    } deriving (Show)

data Error = Error {
      errorCode :: Integer
    , errorMsg :: Text
    } deriving (Show)
