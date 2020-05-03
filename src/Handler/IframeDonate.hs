{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# OPTIONS_GHC -Wno-missing-export-lists #-}

module Handler.IframeDonate where

import Import
import LndClient.Data.AddInvoice

--
-- TODO
--

getIframeDonateR :: Handler Html
getIframeDonateR = do
  (formWidget, formEnctype) <-
    generateFormPost $ renderBootstrap3 BootstrapInlineForm maForm
  let moneyAmount = MsgConst $ pack $ show defMoneyAmount
  noLayout $ do
    setTitleI MsgIframeDonateRTitle
    $(widgetFile "iframe-donate")

postIframeDonateR :: Handler Html
postIframeDonateR = do
  ((fr, formWidget), formEnctype) <-
    runFormPost $ renderBootstrap3 BootstrapInlineForm maForm
  let moneyAmount =
        MsgConst $ pack $ show $ case fr of
          FormSuccess ma -> ma
          _ -> defMoneyAmount
  noLayout $ do
    setTitleI MsgIframeDonateRTitle
    $(widgetFile "iframe-donate")

strictAddInvoice :: MoneyAmount -> Handler (Maybe AddInvoiceResponse)
strictAddInvoice ma = do
  env <- appLndEnv <$> getYesod
  maybeRPCResponse <$> addInvoice env req
  where
    req = hashifyAddInvoiceRequest $ AddInvoiceRequest Nothing ma Nothing

maForm :: AForm Handler MoneyAmount
maForm =
  areq (selectFieldList ms) (bfs MsgNothing) (Just defMoneyAmount)
  where
    -- without noscript wrapper this can be used instead of custom submit button
    --  <* bootstrapSubmit (BootstrapSubmit MsgIframeDonateRTitle "btn-default" [])

    ms = [("0.01 mBTC" :: Text, MoneyAmount 1000), ("0.1 mBTC", MoneyAmount 10000)]

defMoneyAmount :: MoneyAmount
defMoneyAmount = MoneyAmount 1000

formId :: Text
formId = "ln-donate-form"
