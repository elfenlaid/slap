{-# LANGUAGE RecordWildCards   #-}
{-# LANGUAGE ViewPatterns #-}

import Data.Slap.Config
import Network.HTTP.Slap.Auth
import Network.WebSockets.Slap.Connection
import qualified Data.Text as T
import qualified Data.Text.IO as T
import Control.Monad (forever)

main :: IO ()
main = do
    config <- mkConfigFromFile "bot.conf"
    maybe (error "provide config file") startBot config

startBot :: Config -> IO ()
startBot Config{..} = do
    resp <- getStartResponse configToken
    case resp of
      StartResponse {startURL = url} -> connect (T.unpack url)
      StartError {startError = err}  -> error (T.unpack err)
  where connect (parseUrlCreds -> Just creds) = connectTo creds >>= listen
        connect url = error $ "Failed to create creds for url " ++ url
        listen con = forever $ do
                        txt <- receiveData con
                        T.putStrLn txt
