{-# LANGUAGE OverloadedStrings #-}

module Auth.Auth (googleOAuth2Plugin) where

import Data.Aeson ( (.:), FromJSON(parseJSON), Value(Object), decodeStrict )
import Data.Text ( Text )
import Yesod.Auth.OAuth2.Google (oauth2GoogleScoped)
import Yesod.Auth ( AuthPlugin, YesodAuth )

import Auth.Secret (googleClientSecret)

data OAuth2 = OAuth2 { clientId :: Text
                     , clientSecret :: Text
                     }
                     deriving (Show)

instance FromJSON OAuth2 where
    parseJSON (Object v) = OAuth2 <$> v .: "client_id" <*> v .: "client_secret"
    parseJSON _ = error "Invalid value for OAuth2 JSON file"

googleOAuth2Plugin :: YesodAuth m => AuthPlugin m
googleOAuth2Plugin = oauth2GoogleScoped scopes (clientId oauth2) (clientSecret oauth2)
    where oauth2 = case decodeStrict googleClientSecret of
            Nothing  -> error "This should never happen!"
            Just val -> val
          scopes = ["profile", "email", "openid"]