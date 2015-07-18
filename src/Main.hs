{-# LANGUAGE RecordWildCards   #-}

import Data.Slap.Config
import Network.HTTP.Slap.Auth
import Network.WebSockets.Slap.Connection
import qualified Data.Text as T
import qualified Data.Text.IO as T
import Control.Monad

main :: IO ()
main = do
    config <- mkConfigFromFile "bot.conf"
    case config of
      (Just cfg) -> startBot cfg
      Nothing -> error "provide config file"

startBot :: Config -> IO ()
startBot Config{..} = do
    resp <- getRTMStart (T.unpack configToken)
    case resp of
      (Right (RTMResponse url _)) -> listen url
      (Left err) -> error err
  where listen url = do
          con <- connectTo url
          case con of
            (Left err) -> error err
            (Right con) -> forever $ do
                            txt <- receiveData con
                            T.putStrLn txt
