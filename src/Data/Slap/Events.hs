module Data.Slap.Events
    (
      Event(..)
    ) where

import Data.Text(Text)
import Data.Slap.Types

data Event = Hello
           | Message { msgChannel :: Id
                     , msgUser :: Id
                     , msgText :: Text }
           | UserTyping { utChannel :: Id
                        , utUser :: Id }
           | Error { err :: Data.Slap.Types.Error }
           | Reply { replyTo :: Text
                   , replyOk :: Bool }
                   -- parse error in reply
           | Ping
           | Pong
       deriving (Show)
