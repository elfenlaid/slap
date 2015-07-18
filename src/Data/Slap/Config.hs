{-# LANGUAGE OverloadedStrings #-}

module Data.Slap.Config
    (
    Config(..),
    mkConfigFromFile
    ) where

import Data.Text (Text)
import Control.Monad (liftM, mzero)
import qualified Data.ByteString.Lazy as BL

import Data.Aeson

data Config = Config
    { configToken :: Text }
  deriving Show

instance FromJSON Config where
    parseJSON (Object o) = Config <$> o .: "token"
    parseJSON _ = mzero

mkConfigFromFile :: FilePath -> IO (Maybe Config)
mkConfigFromFile = liftM decode . BL.readFile
