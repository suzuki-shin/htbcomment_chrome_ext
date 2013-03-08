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
    putStrLn "Htbcomment2"
--     select "body" >>= append "XXXXXXXXXX ########## "
    div <- select "#comments"
    wid <- getWindowId
    chromeTabsGetselected wid $ \tab -> do
--       let t' = toTabFromJSON tab
--       putStrLn "---1"
--       putStrLn $ show t'
--       putStrLn "---2"
--       putStrLn $ title t'
--       putStrLn "---3"
--       putStrLn $ jsStrToHsStr $ title t'
--       putStrLn "---4"
--       putStrLn $ tail $ title t'
--       putStrLn $ init $ title t'
--       putStrLn $ init $ tail $ title t'
--       putStrLn "---5"
--       putStrLn $ title t' ++ title t'
--       putStrLn "---6"
--       putStrLn $ jsStrConcat (title t') (title t')
--     chromeTabsGetselected wid $ \json -> do
--       tab <- fromJSON json
      putStrLn $ show $ url tab
      select "#dump" >>= append "(url tab)"
--       select "#dump" >>= append (show (url tab)) -- OK
--       putStrLn $ url tab        -- NG ""
--       putStrLn $ arrToStr' $ url tab -- NG ""
      putStrLn $ show tab            -- OK {"active":true,"favIconUrl":"chrome://theme/IDR_EXTENSIONS_FAVICON@2x","highlighted":true,"id":4,"incognito":false,"index":1,"pinned":false,"selected":true,"status":"complete","title":"拡張機能","url":"chrome://extensions/","windowId":1}
--       let url' = baseUrl ++ show (url tab) -- NG http://b.hatena.ne.jp/entry/jsonlite/"chrome://extensions/"
--       let url' = baseUrl ++ arrToStr' (url tab) -- NG http://b.hatena.ne.jp/entry/jsonlite/
--       let url' = baseUrl ++ (url tab)
--       let url' = baseUrl ++ (url t') -- NG http://b.hatena.ne.jp/entry/jsonlite/"chrome://extensions/"
      putStrLn "(js \"url\" tab)"
      putStrLn (js "url" tab)
      putStrLn $ show (js "url" tab)
      let url' = baseUrl ++ (js "url" tab) -- NG http://b.hatena.ne.jp/entry/jsonlite/"chrome://extensions/"
--       let url' = concat[baseUrl, (url t')] -- NG http://b.hatena.ne.jp/entry/jsonlite/"chrome://extensions/"
      putStrLn url'
      select "#dump" >>= append "api access..."
--       getJSON url' $ \entry -> displayComment $ getBookmarks entry
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
displayComment bs = do
  comments <- arrToStr $ concatMap ((++ "<br/>") . getComment) $ take 20 bs
  select "#comments" >>= append comments
  return ()


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
    getUser :: String
  , getTags :: [String]
  , getTimestamp :: String
  , getComment :: String
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