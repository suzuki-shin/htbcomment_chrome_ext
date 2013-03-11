p = prelude

cacheHour = 10
cacheMSec = cacheHour * 60 * 60 * 1000

displayComment = (bookmarks) ->
  for b in p.take(20, p.filter(((b) -> b.comment), bookmarks))
    $('#comments').append(b.comment + '<br />')

$(->
  dt = new Date()
  now = dt.getTime()
  chrome.tabs.getSelected(window.id, ((tab) ->
    cache = localStorage[tab.url]
    if cache && JSON.parse(cache).createtd > now - cacheMSec
      json = JSON.parse(cache) # get cache
      console.log(json.bookmarks)
      displayComment(json.bookmarks)
    else
      url = "http://b.hatena.ne.jp/entry/jsonlite/" + tab.url
      $('#dump').append('api access!...')
      $.getJSON(url, ((json) ->
        json.createtd = now
        localStorage[tab.url] = JSON.stringify(json) # set cache
        displayComment(json.bookmarks)
      ))
  )))
