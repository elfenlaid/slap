{-# LANGUAGE OverloadedStrings #-}

module HTTP.Slap.Auth where 

import Network.Wreq
import Control.Lens
import Data.Aeson.Lens
import Data.Aeson
import qualified Data.Text as T
import qualified Data.ByteString.Lazy as LBS

import Data.Aeson.Slap.Types

type Url = String

rtmStartUrl :: Url
rtmStartUrl = "https://slack.com/api/rtm.start"

getRawStartResponse :: String -> IO LBS.ByteString
getRawStartResponse token = do
    r <- getWith opts rtmStartUrl
    return $ r ^. responseBody
  where opts = defaults & param "token" .~ [T.pack token]

