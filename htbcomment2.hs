{-# LANGUAGE EmptyDataDecls    #-}
module Htbcomment2 (main) where

import Prelude
import FFI
-- import MyPrelude
import JS
-- import ChromeExt
-- import Hah.Types
-- import Hah.Configs

main :: Fay ()
main = do
  ready $ do
--     div <- select "#comments"
    wid <- getWindowId
    chromeTabsGetselected wid $ \tab -> do
      let url' = baseUrl ++ (js "url" tab)
      select "#dump" >>= append "api access..."
      getJSON url' $ \entry -> displayComment (bookmarksFromJs "bookmarks" entry)
      return ()
    return ()


baseUrl = "http://b.hatena.ne.jp/entry/jsonlite/"

cacheHour :: Int
cacheHour = 10
cacheMSec :: Int
cacheMSec = cacheHour * 60 * 60 * 1000;

-- chromeTabsGetselected :: Int -> (String -> Fay ()) -> Fay ()
chromeTabsGetselected :: Int -> (Tab -> Fay ()) -> Fay ()
chromeTabsGetselected = ffi "chrome.tabs.getSelected(%1, %2)"

getWindowId :: Fay Int
getWindowId = ffi "window.id"

getJSON :: String -> (Entry -> Fay ()) -> Fay ()
getJSON = ffi "$.getJSON(%1, %2)"

displayComment :: [Bookmark] -> Fay ()
displayComment [] = return ()
displayComment (b:bs) = case (js "comment" b) of
  "" -> displayComment bs
  c  -> do
    select "#comments" >>= append (c ++ "<br>")
    displayComment bs

-- {"active":true,"favIconUrl":"http://www.alc.co.jp/favicon.ico","highlighted":true,
--  "id":13,"incognito":false,"index":3,"pinned":false,"selected":true,"status":"complete",
--  "title":"英語・語学の学習情報サイト「スペースアルク」：アルク",
--  "url":"http://www.alc.co.jp/","windowId":1}
data Tab = Tab {
    active :: Bool
  , url :: String
  , favIconUrl :: String
  , index :: Int
  , title :: String
  , windowId :: Int
  } deriving (Show)

data Entry = Entry {
    getTitle :: String
  , getCount :: Int
  , getUrl' :: String
  , getEntryUrl :: String
  , getScreenshot :: String
  , getEid :: String
  , getBookmarks :: [Bookmark]
  } deriving (Show)

data Bookmark = Bookmark {
    user :: String
  , tags :: [String]
  , timestamp :: String
  , comment :: String
  } deriving (Show)

fromJSON :: String -> Fay a
fromJSON = ffi "JSON.parse(%1)"

-- toTabFromJSON j = Tab (active j) (url j) (favIconUrl j) (index j)  (title j) (windowId j)
-- toTabFromJSON j = Tab (active j) (show (url j)) (show (favIconUrl j)) (index j) (show (title j)) (windowId j)

-- jsStrConcat :: String -> String -> String
-- jsStrConcat = ffi "%1 + %2"

-- jsStrToHsStr :: String -> String
-- jsStrToHsStr = init . tail
js :: String -> a -> String
js = ffi "%2[%1]"

bookmarksFromJs :: String -> a -> [Bookmark]
bookmarksFromJs = ffi "%2[%1]"