{-# LANGUAGE EmptyDataDecls    #-}
module Htbcomment2 (main) where

import Prelude
import FFI
-- import MyPrelude
import JS
-- import ChromeExt

main :: Fay ()
main = do
  ready $ do
    wid <- getWindowId
    chromeTabsGetselected wid $ \tab -> do
      let url' = baseUrl ++ (toStrFromJs "url" tab)
      select "#dump" >>= append "api access..."
      getJSON url' $ \entry -> displayComment (toBookmarksFromJs "bookmarks" entry)
      return ()
    return ()


baseUrl = "http://b.hatena.ne.jp/entry/jsonlite/"

cacheHour :: Int
cacheHour = 10
cacheMSec :: Int
cacheMSec = cacheHour * 60 * 60 * 1000;

-- chromeTabsGetselected :: Int -> (String -> Fay ()) -> Fay ()
-- chromeTabsGetselected :: Int -> (Tab -> Fay ()) -> Fay ()
chromeTabsGetselected :: Int -> (a -> Fay ()) -> Fay ()
chromeTabsGetselected = ffi "chrome.tabs.getSelected(%1, %2)"

getWindowId :: Fay Int
getWindowId = ffi "window.id"

-- getJSON :: String -> (Entry -> Fay ()) -> Fay ()
getJSON :: String -> (a -> Fay ()) -> Fay ()
getJSON = ffi "$.getJSON(%1, %2)"

displayComment :: [Bookmark] -> Fay ()
displayComment [] = return ()
displayComment (b:bs) = case (toStrFromJs "comment" b) of
  "" -> displayComment bs
  c  -> do
    select "#comments" >>= append (c ++ "<br>")
    displayComment bs

data Tab = Tab {
    active :: Bool
  , url :: String
  , favIconUrl :: String
  , index :: Int
  , title :: String
  , windowId :: Int
  } deriving (Show)

data Bookmark = Bookmark {
    user :: String
  , tags :: [String]
  , timestamp :: String
  , comment :: String
  } deriving (Show)

toStrFromJs :: String -> a -> String
toStrFromJs = ffi "%2[%1]"

toBookmarksFromJs :: String -> a -> [Bookmark]
toBookmarksFromJs = ffi "%2[%1]"