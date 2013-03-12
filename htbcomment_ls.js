(function(){
  var p, cacheHour, cacheMSec, dt, now, displayComment, getAndDisplay;
  p = prelude;
  cacheHour = 10;
  cacheMSec = cacheHour * 60 * 60 * 1000;
  dt = new Date();
  now = dt.getTime();
  displayComment = function(bookmarks){
    return $('#comments').append(p.concatMap(function(it){
      return it.comment + '<br/>';
    }, p.take(20, p.filter(function(it){
      return it.comment;
    }, bookmarks))));
  };
  getAndDisplay = function(url, dispFunc){
    var cache, json, bkmUrl;
    cache = localStorage[url];
    if (cache && JSON.parse(cache).createtd > now - cacheMSec) {
      json = JSON.parse(cache);
      console.log(json.bookmarks);
      return dispFunc(json.bookmarks);
    } else {
      bkmUrl = "http://b.hatena.ne.jp/entry/jsonlite/" + url;
      $('#dump').append('api access...');
      return $.getJSON(bkmUrl, function(json){
        if ((json != null ? json.bookmarks : void 8) != null) {
          dispFunc(json.bookmarks);
        }
        return localStorage[url] = JSON.stringify(import$({
          createtd: now,
          bookmarks: []
        }, json));
      });
    }
  };
  $(function(){
    return chrome.tabs.getSelected(window.id, function(tab){
      return getAndDisplay(tab.url, displayComment);
    });
  });
  function import$(obj, src){
    var own = {}.hasOwnProperty;
    for (var key in src) if (own.call(src, key)) obj[key] = src[key];
    return obj;
  }
}).call(this);
