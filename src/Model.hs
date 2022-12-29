{-# LANGUAGE EmptyDataDecls             #-}
{-# LANGUAGE FlexibleInstances          #-}
{-# LANGUAGE GADTs                      #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE NoImplicitPrelude          #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE TemplateHaskell            #-}
{-# LANGUAGE TypeFamilies               #-}
{-# LANGUAGE DerivingStrategies         #-}
{-# LANGUAGE StandaloneDeriving         #-}
{-# LANGUAGE UndecidableInstances       #-}
{-# LANGUAGE DataKinds                  #-}
{-# OPTIONS_GHC -Wno-name-shadowing     #-}
-- {-# OPTIONS_GHC -ddump-splices          #-}
module Model where

import ClassyPrelude.Yesod
import Database.Persist.Quasi
import qualified Data.Text as Text

-- You can define all of your database entities in the entities file.
-- You can find more information on persistent and how to declare entities
-- at:
-- http://www.yesodweb.com/book/persistent/
share [mkPersist sqlSettings, mkMigrate "migrateAll"]
    $(persistFileWith lowerCaseSettings "config/models.persistentmodels")

displayMessage :: Message -> Text
displayMessage msg = Text.unwords [ "("
                                  ,time
                                  , ")"
                                  , sender
                                  , ":"
                                  , content
                                  ]
  where time    = formatW3 $ messageTimestamp msg
        sender  = Text.pack $ show $ messageSender_id msg
        content = messageMsgBody msg