var p, cacheHour, cacheMSec, displayComment;
p = prelude;
cacheHour = 10;
cacheMSec = cacheHour * 60 * 60 * 1000;
displayComment = function(bookmarks){
  var i$, ref$, len$, b, results$ = [];
  for (i$ = 0, len$ = (ref$ = p.take(20, p.filter(fn$, bookmarks))).length; i$ < len$; ++i$) {
    b = ref$[i$];
    results$.push($('#comments').append(b.comment + '<br />'));
  }
  return results$;
  function fn$(b){
    return b.comment;
  }
};
$(function(){
  var dt, now;
  dt = new Date();
  now = dt.getTime();
  return chrome.tabs.getSelected(window.id, function(tab){
    var cache, json, url;
    cache = localStorage[tab.url];
    if (cache && JSON.parse(cache).createtd > now - cacheMSec) {
      json = JSON.parse(cache);
      console.log(json.bookmarks);
      return displayComment(json.bookmarks);
    } else {
      url = "http://b.hatena.ne.jp/entry/jsonlite/" + tab.url;
      $('#dump').append('api access!...');
      return $.getJSON(url, function(json){
        json.createtd = now;
        localStorage[tab.url] = JSON.stringify(json);
        return displayComment(json.bookmarks);
      });
    }
  });
});