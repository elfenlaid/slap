{-# LANGUAGE OverloadedStrings #-}

module Network.HTTP.Slap.Auth (
      getStartResponse
    , getRawStartResponse
    , StartResponse(..)
    ) where

import Network.Wreq
import Control.Lens
import Data.Aeson.Lens
import Data.Aeson
import Data.Text (Text)
import Control.Monad (mzero)
import Data.Maybe (fromMaybe)
import qualified Data.Text as T
import qualified Data.ByteString.Lazy as LBS
import qualified Data.Aeson.Slap.Types as Types

type Url = Text
type Error = Text
type Token = Text

instance FromJSON StartResponse where
    parseJSON v | (Just err) <- v ^? key "error" . _String = pure (StartError err)
                | (Object o) <- v = StartResponse <$> (parseJSON v) <*> o .: "url"
                | otherwise = mzero

data StartResponse = StartResponse {
      startContext :: Types.ConfContext
    , startURL     :: Url }
    | StartError {
      startError   :: Error }
    deriving Show

rtmStartUrl :: Url
rtmStartUrl = "https://slack.com/api/rtm.start"

getRawStartResponse :: Token -> IO LBS.ByteString
getRawStartResponse token = do
    r <- getWith opts (T.unpack rtmStartUrl)
    return $ r ^. responseBody
  where opts = defaults & param "token" .~ [token]

getStartResponse :: Token -> IO StartResponse
getStartResponse token = do
    response <- getRawStartResponse token
    return $ fromMaybe (error "Failed to decode response")
                       (decode response)
