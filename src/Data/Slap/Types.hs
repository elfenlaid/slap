module Data.Slap.Types (
      Profile(..)
    , User(..)
    , Self(..)
    , ConfContext(..)
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
    , userProfile :: Maybe Profile
    } deriving (Show, Eq)

data Self = Self {
      selfId :: Text
    , selfName :: Text
    } deriving (Show, Eq)

{-
{
    "ok": true,
    "url": "wss:\/\/ms9.slack-msgs.com\/websocket\/7I5yBpcvk",

    "self": {
        "id": "U023BECGF",
        "name": "bobby",
        "prefs": {
            …
        },
        "created": 1402463766,
        "manual_presence": "active"
    },
    "team": {
        "id": "T024BE7LD",
        "name": "Example Team",
        "email_domain": "",
        "domain": "example",
        "msg_edit_window_mins": -1,
        "over_storage_limit": false
        "prefs": {
            …
        },
        "plan": "std"
    },
    "users": [ … ],

    "channels": [ … ],
    "groups": [ … ],
    "ims": [ … ],

    "bots": [ … ],
}
-}


data ConfContext = ConfContext {
      confSelf :: Self 
    , confUsers :: [User]
    } deriving (Show)