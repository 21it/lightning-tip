{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}

module LightningTip.Types
  ( CurrencyCode (..),
    PaymentStatus (..),
  )
where

import Database.Persist.TH (derivePersistField)
import GHC.Generics (Generic)

data CurrencyCode
  = BTC
  deriving (Generic, Show, Read, Eq)

data PaymentStatus
  = PaymentStatusNew
  | PaymentStatusSettled
  | PaymentStatusExpired
  deriving (Generic, Show, Read, Eq)

derivePersistField "CurrencyCode"

derivePersistField "PaymentStatus"
