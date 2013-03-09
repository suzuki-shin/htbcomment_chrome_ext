{-# LANGUAGE EmptyDataDecls    #-}
module Htbcomment2 (main) where

import Prelude
import FFI
-- import MyPrelude
import JS
-- import ChromeExt

baseUrl :: String
baseUrl = "http://b.hatena.ne.jp/entry/jsonlite/"
cacheHour :: Int
cacheHour = 10
cacheMSec :: Int
cacheMSec = cacheHour * 60 * 60 * 1000;

main :: Fay ()
main = do
  ready $ do
--     select "#dump" >>= append "debug xxx"
    wid <- getWindowId
    chromeTabsGetselected wid $ \tab ->
      getJSON (baseUrl ++ (propStr "url" tab)) $ \e ->
--       getCacheAnd (baseUrl ++ (propStr "url" tab)) $ \e ->
        displayComment (propBookmarks "bookmarks" e)


chromeTabsGetselected :: Int -> (a -> Fay ()) -> Fay ()
chromeTabsGetselected = ffi "chrome.tabs.getSelected(%1, %2)"

getWindowId :: Fay Int
getWindowId = ffi "window.id"


setCache :: String -> a -> Fay ()
setCache url json = localStorageSet url $ show json

-- getCache :: String -> Maybe String
getCache :: String -> Maybe a
getCache url = case localStorageGet url of
  Null -> Nothing
  Nullable cache -> Just $ jsonParse cache
--   cache -> Just $ jsonParse cache

getCacheAnd :: String -> (a -> Fay ()) -> Fay ()
getCacheAnd url f = case getCache url of
   Just entry -> do
     putStrLn "Just"
     putStrLn $ show entry
     putStrLn "----------"
--      putStrLn $ show (propBookmarks "bookmarks" entry)
     f entry
   Nothing -> do
     select "#dump" >>= append "api access..."
     putStrLn "nothing"
     getJSON url $ \entry -> do
       f entry
       setCache url entry


displayComment :: [Bookmark] -> Fay ()
displayComment [] = return ()
displayComment (b:bs) = case (propStr "comment" b) of
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

propStr :: String -> a -> String
propStr = ffi "%2[%1]"

propBookmarks :: String -> a -> [Bookmark]
propBookmarks = ffi "%2[%1]"

jsonParse :: String -> a
jsonParse = ffi "JSON.parse(%1)"
