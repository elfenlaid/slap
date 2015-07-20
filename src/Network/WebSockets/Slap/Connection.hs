{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}

module Network.WebSockets.Slap.Connection (
      Connection
    , connectTo
    , receiveData
    , sendData
    , close
    , parseUrlCreds
    ) where


import           Control.Concurrent        (forkIO)
import           Control.Monad             (forever)
import           Data.Word                 (Word16)

import           Network                   (PortNumber (..))
import           Network.Connection        (ConnectionParams (..),
                                            TLSSettings (..))
import qualified Network.Connection        as Con
import qualified Network.URI               as URI
import qualified Network.WebSockets        as WS
import qualified Network.WebSockets.Stream as WS

import           Data.Text                 (Text)
import qualified Data.Text                 as T
import qualified Data.Text.IO              as T
import qualified Data.ByteString.Lazy      as BL

import           Control.Concurrent.Chan   (Chan, newChan, readChan, writeChan)

type ConnectionChan = (Chan Text)
type WebSocketUrl = String
type Error = String

data Connection = Connection {
      connection :: WS.Connection
    , conInput   :: ConnectionChan
    , conOutput  :: ConnectionChan
    }

data UrlCreds = UrlCreds {
      urlPort :: PortNumber
    , urlHost :: String
    , urlPath :: String
    } deriving (Eq, Show)

parseUrlCreds :: WebSocketUrl -> Maybe UrlCreds
parseUrlCreds url = do
    uri <- URI.parseURI url
    port <- getPort (URI.uriScheme uri)
    auth <- URI.uriAuthority uri
    return UrlCreds { urlPort = port
                    , urlHost = URI.uriRegName auth
                    , urlPath = getPath (URI.uriPath uri) }
  where getPort "wss:" = Just 443
        getPort _      = Nothing
        getPath "" = "/"
        getPath p  = p

close :: Connection -> IO ()
close con = WS.sendClose (connection con) ("Bye!" :: Text)

sendData :: Connection -> Text -> IO ()
sendData Connection{..} = writeChan conOutput

receiveData :: Connection -> IO Text
receiveData Connection{..} = readChan conInput

connectTo :: UrlCreds -> IO Connection
connectTo creds = do
    ctx <- Con.initConnectionContext
    con <- Con.connectTo ctx params
    let reader = (fmap Just $ Con.connectionGetChunk con)
    let writer = (maybe (return ()) (Con.connectionPut con . BL.toStrict))
    stream <- WS.makeStream reader writer
    WS.runClientWithStream stream hostname path opts [] makeConnection

  where hostname = urlHost creds
        port = urlPort creds
        path = urlPath creds
        params = ConnectionParams
                    { connectionHostname  = hostname
                    , connectionPort      = port
                    , connectionUseSecure =
                      Just $ TLSSettingsSimple
                        { settingDisableCertificateValidation = True
                        , settingDisableSession = False
                        , settingUseServerName  = False }
                    , connectionUseSocks  = Nothing }
        opts = WS.defaultConnectionOptions

makeConnection :: WS.ClientApp Connection
makeConnection con = do
    putStrLn "Connected!"
    inChan <- newChan
    outChan <- newChan

    _ <- forkIO $ forever $ do
          msg <- WS.receiveData con
          writeChan inChan msg

    _ <- forkIO $ forever $ do
          chunk <- readChan outChan
          WS.sendTextData con chunk

    return Connection { connection = con, conOutput = outChan, conInput = inChan }
