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
  let handlerName = "getHomeR" :: Text
  (formWidget, formEnctype) <- generateFormPost inputForm
  allMessages <- runDB getAllMessages

  defaultLayout $ do
    aDomId <- newIdent
    setTitle "Landing page"
    toWidgetHead
      [hamlet|
                <meta name=handler content=#{handlerName}>
            |]
    $(widgetFile "homepage")

postHomeR :: Handler ()
postHomeR = do
  ((result, _), _) <- runFormPost inputForm
  case result of
    FormFailure _ -> error "This should never happen!"
    FormMissing -> return ()
    FormSuccess input -> void $ runDB $ insertUserInput input
  redirect HomeR

-- TODO: Improve this simple version
hasLink :: Text -> Bool
hasLink = isInfixOf "http" 

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
  renderDivs $ generateMetadata <$> areq textField formSettings Nothing
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
    generateMetadata :: Text -> UserInput
    generateMetadata userInput = InputText meta userInput
      where meta = MessageMetadata Nothing $ hasLink userInput

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

getAllMessages :: DB [Entity Message]
getAllMessages = selectList [] [Asc MessageId]

displayMessage :: Message -> Text
displayMessage = messageMsgBody
