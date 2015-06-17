{-# LANGUAGE OverloadedStrings #-}

module HTTP.Slap.Auth where 

import Network.Wreq
import Control.Lens
import Data.Aeson.Lens
import Data.Aeson
import qualified Data.Text as T

rtmStartUrl :: String 
rtmStartUrl = "https://slack.com/api/rtm.start"

getRawStartResponse :: String -> IO Value
getRawStartResponse token = do
    r <- asJSON =<< getWith opts rtmStartUrl
    return $ r ^. responseBody
  where opts = defaults & param "token" .~ [T.pack token]