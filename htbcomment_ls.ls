p = prelude

cacheHour = 10
cacheMSec = cacheHour * 60 * 60 * 1000

dt = new Date()
now = dt.getTime()

displayComment = (bookmarks) ->
  $('#comments').append(
    p.concatMap(
      ((b) -> b.comment + '<br/>'),
      p.take(20, p.filter(((b) -> b.comment), bookmarks))))

# cacheがあればcacheから、なければajaxでentryデータを取得して、表示する
getAndDisplay = (url, dispFunc) ->
  cache = localStorage[url]

  if cache && JSON.parse(cache).createtd > now - cacheMSec
    json = JSON.parse(cache) # get cache
    console.log(json.bookmarks)
    dispFunc(json.bookmarks)
  else
    bkmUrl = "http://b.hatena.ne.jp/entry/jsonlite/" + url
    $('#dump').append('api access...')
    $.getJSON(bkmUrl, ((json) ->
      json.createtd = now
      localStorage[url] = JSON.stringify(json) # set cache
      dispFunc(json.bookmarks)
    ))

$(->
  chrome.tabs.getSelected(window.id, ((tab) ->
    getAndDisplay(tab.url, displayComment)
  )))
