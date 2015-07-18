
module Data.Slap.Events
    (
      Event(..)
    ) where

import Data.Text(Text)
import Data.Slap.Types

data Event =
    Message { msgChannel :: Id
            , msgUser    :: Id
            , msgText    :: Text }
    | UserTyping { utChannel :: Id
                 , utUser    :: Id }
    | Reply { replyTo :: Text
            , replyOk :: Bool }
    | Error Data.Slap.Types.Error
    | Ping
    | Pong
    | Hello
  deriving (Show)
