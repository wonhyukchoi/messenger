{-# LANGUAGE OverloadedStrings #-}

module Auth.Secret (googleClientSecret) where

import Data.ByteString ( ByteString )

-- | Due to the typing limitations of OAuth2 tools for YesodAuth,
-- we must include this as a raw string as opposed to a json file.
googleClientSecret :: ByteString
googleClientSecret = ""