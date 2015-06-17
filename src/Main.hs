{-# LANGUAGE OverloadedStrings #-}
 
import           Control.Concurrent        (forkIO)
import           Control.Monad             (forever, unless)
 
import qualified Data.ByteString.Lazy      as BL
 
import           Network.Connection
import qualified Network.WebSockets        as WS
import qualified Network.WebSockets.Stream as WS
 
import           Data.Text                 (Text)
import qualified Data.Text                 as T
import qualified Data.Text.IO              as T
  
app :: WS.ClientApp ()
app conn = do
    putStrLn "Connected!"
 
    _ <- forkIO $ forever $ do
          msg <- WS.receiveData conn
          T.putStrLn msg
 
    let loop = do
          line <- T.getLine
          unless (T.null line) $ WS.sendTextData conn line >> loop
 
    loop
    WS.sendClose conn ("Bye!" :: Text)
 
main :: IO ()
main = do
  ctx <- initConnectionContext
  con <- connectTo ctx $ ConnectionParams
                          { connectionHostname  = hostname
                          , connectionPort      = port
                          , connectionUseSecure =
                            Just $ TLSSettingsSimple
                              { settingDisableCertificateValidation = True
                              , settingDisableSession = False
                              , settingUseServerName  = False
                              }
                          , connectionUseSocks  = Nothing
                          }
  stream <- WS.makeStream (fmap Just $ connectionGetChunk con)
                          (maybe (return ()) (connectionPut con . BL.toStrict))
  WS.runClientWithStream stream hostname path WS.defaultConnectionOptions [] app
 where
   hostname = "echo.websocket.org"
   port = 443
   path = "/"