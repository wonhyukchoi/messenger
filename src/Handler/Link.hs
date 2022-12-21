{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Handler.Link where

import Import

getMessagesWithLink :: DB [Entity Message]
getMessagesWithLink = selectList [MessageHasLink ==. True] [Asc MessageId]

getLinkR :: Handler Html
getLinkR = do
  messagesWithLink <- runDB getMessagesWithLink
  defaultLayout $ do
    setTitle "Links"
    $(widgetFile "link")

-- getHomeR :: Handler Html
-- getHomeR = do
--   let handlerName = "getHomeR" :: Text
--   (formWidget, formEnctype) <- generateFormPost inputForm
--   allMessages <- runDB getAllMessages

--   defaultLayout $ do
--     aDomId <- newIdent
--     setTitle "Landing page"
--     toWidgetHead
--       [hamlet|
--                 <meta name=handler content=#{handlerName}>
--             |]
--     $(widgetFile "homepage")