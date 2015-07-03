{-# LANGUAGE OverloadedStrings #-}

module Data.Aeson.Slap.Events
    (
      Events.Event
    ) where

import Data.Text (Text)
import qualified Data.Text as Text
import Data.Aeson
import Data.Aeson.Types
import Data.Aeson.Lens
import Control.Lens
import Control.Applicative
import Control.Monad
import qualified Data.Aeson.Slap.Types as Types
import qualified Data.Slap.Types as Types
import qualified Data.Slap.Events as Events


instance FromJSON Events.Event where
    parseJSON v@(Object o)
        | (Just t) <- v ^? key "type" . _String = parseEvent t o
        | otherwise = mzero
    parseJSON _          = mzero

parseEvent :: Text -> Object -> Parser Events.Event
parseEvent "hello" _ = pure Events.Hello
parseEvent "ping"  _ = pure Events.Ping
parseEvent "pong"  _ = pure Events.Pong
parseEvent "message" o = Events.Message <$>
                         o .: "channel" <*>
                         o .: "user" <*>
                         o .: "text"
parseEvent "user_typing" o = Events.UserTyping <$>
                             o .: "channel" <*>
                             o .: "user"
parseEvent "error" o = Events.Error <$> o .: "error"
parseEvent _ _ = mzero
