{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE EmptyDataDecls #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# OPTIONS_GHC -Wno-missing-export-lists #-}

module Model where

import ClassyPrelude.Yesod
import Data.Pool (Pool)
import Database.Persist.Migration
import qualified Database.Persist.Migration.Postgres as P (runMigration)
import Database.Persist.Quasi
import Database.Persist.Sql hiding (Migration, migrate)
import LightningTip.Types
import LndClient.Data.Newtypes as Lnd

-- You can define all of your database entities in the entities file.
-- You can find more information on persistent and how to declare entities
-- at:
-- http://www.yesodweb.com/book/persistent/
--
-- TODO : add search indexes migrations
--
share
  [mkPersist sqlSettings, mkMigrate "migrateAuto"]
  $(persistFileWith lowerCaseSettings "config/models.persistentmodels")

migrateAfter :: Migration
migrateAfter =
  [ 0
      ~> 1
      := [ RawOperation "create Payment search indexes"
             $ lift
               . return
             $ [ MigrateSql
                   "CREATE INDEX ON payment (money_amount, status);"
                   []
               ]
         ]
  ]

migrateAll :: (MonadLogger m, MonadIO m) => Pool SqlBackend -> m ()
migrateAll pool = do
  $(logInfo) "Running Persistent AUTO migrations..."
  liftIO $ runSqlPool (runMigration migrateAuto) pool
  $(logInfo) "Running Persistent AFTER migrations..."
  liftIO $ runSqlPool (P.runMigration defaultSettings migrateAfter) pool
  $(logInfo) "Persistent database migrated!"
