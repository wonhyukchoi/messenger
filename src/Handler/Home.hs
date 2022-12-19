{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Handler.Home where

import qualified Data.List as List
import Data.Time.Clock (getCurrentTime)
import Import

-- import Network.Wai.Middleware.Approot (hardcoded)
-- import Yesod.Form.Bootstrap3 (BootstrapFormLayout (..), renderBootstrap3)
-- import Text.Julius (RawJS (..))

-- This is a handler function for the GET request method on the HomeR
-- resource pattern. All of your resource patterns are defined in
-- config/routes.yesodroutes
--
-- The majority of the code you will write in Yesod lives in these handler
-- functions. You can spread them across multiple files if you are so
-- inclined, or create a single monolithic file.
getHomeR :: Handler Html
getHomeR = do
  (formWidget, formEnctype) <- generateFormPost inputForm
  let submission = Nothing :: Maybe Text
      handlerName = "getHomeR" :: Text

  defaultLayout $ do
    aDomId <- newIdent
    setTitle "Landing page"
    toWidgetHead
      [hamlet|
                <meta name=handler content=#{handlerName}>
            |]
    $(widgetFile "homepage")

postHomeR :: Handler Html
postHomeR = do
  ((result, formWidget), formEnctype) <- runFormPost inputForm
  let handlerName = "postHomeR" :: Text
      submission = case result of
        FormFailure _ -> error "This should never happen!"
        FormMissing -> Nothing
        FormSuccess res -> case res of
          InputText _ msg -> Just msg
          _ -> error "Unimplemented Error"

  defaultLayout $ do
    aDomId <- newIdent
    setTitle "Messenger"
    toWidgetHead
      [hamlet|
                <meta name=handler content=#{handlerName}>
            |]
    $(widgetFile "homepage")

sampleMetadata :: MessageMetadata
sampleMetadata = MessageMetadata Nothing False

data UserInput
  = InputText MessageMetadata Text
  | InputImage MessageMetadata ByteString
  | InputVideo MessageMetadata ByteString

data MessageMetadata = MessageMetadata
  { msgResponseTo :: Maybe MessageId,
    msgHasLink :: Bool
  }

inputForm :: Form UserInput -- aka Html -> MForm Handler (FormResult , Widget)
inputForm =
  renderDivs $ InputText sampleMetadata <$> areq textField formSettings Nothing
  where
    formSettings =
      FieldSettings
        { fsLabel = "Enter your message: ",
          fsTooltip = Nothing,
          fsId = Nothing,
          fsName = Nothing,
          fsAttrs =
            [ ("class", "form-control"),
              ("placeholder", "Enter message here...")
            ]
        }

insertUserInput ::
  MonadIO m =>
  UserInput ->
  ReaderT SqlBackend m MessageId
insertUserInput = \case
  InputText MessageMetadata {..} msg -> do
    timestamp <- liftIO getCurrentTime
    senderId <- List.head <$> selectKeysList [] []
    let nonTextOption = Nothing
    insert $ Message senderId msg nonTextOption nonTextOption nonTextOption msgResponseTo msgHasLink timestamp
  _ -> error "Not Implemented Error"