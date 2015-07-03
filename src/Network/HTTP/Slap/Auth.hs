{-# LANGUAGE OverloadedStrings #-}

module Network.HTTP.Slap.Auth where

import Network.Wreq
import Control.Lens
import Data.Aeson.Lens
import Data.Aeson
import Data.Text (Text)
import qualified Data.Text as T
import qualified Data.ByteString.Lazy as LBS

import qualified Data.Aeson.Slap.Types as Types

type Url = String
type Error = String
type Token = String
data RTMResponse = RTMResponse Url (Maybe Types.ConfContext)
    deriving Show

rtmStartUrl :: Url
rtmStartUrl = "https://slack.com/api/rtm.start"

getRTMStartRaw :: Token -> IO LBS.ByteString
getRTMStartRaw token = do
    r <- getWith opts rtmStartUrl
    return $ r ^. responseBody
  where opts = defaults & param "token" .~ [T.pack token]

getRTMStart :: Token -> IO (Either Error RTMResponse)
getRTMStart token = do
    r <- getRTMStartRaw token
    case decode r :: Maybe Value of
        Just v  -> return (composeResponse r v)
        Nothing -> return (Left "failed to parse json")
  where composeResponse s v
            | (Just url) <- v ^? key "url" . _String   = Right (RTMResponse (T.unpack url) (decode s))
            | (Just err) <- v ^? key "error" . _String = Left (T.unpack err)
            | otherwise = Left "uknown error"
