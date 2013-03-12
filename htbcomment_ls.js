(function(){
  var p, cacheHour, cacheMSec, dt, now, displayComment, getAndDisplay;
  p = prelude;
  cacheHour = 10;
  cacheMSec = cacheHour * 60 * 60 * 1000;
  dt = new Date();
  now = dt.getTime();
  displayComment = function(bookmarks){
    return $('#comments').append(p.concatMap(function(b){
      return b.comment + '<br/>';
    }, p.take(20, p.filter(function(b){
      return b.comment;
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
        json.createtd = now;
        localStorage[url] = JSON.stringify(json);
        return dispFunc(json.bookmarks);
      });
    }
  };
  $(function(){
    return chrome.tabs.getSelected(window.id, function(tab){
      return getAndDisplay(tab.url, displayComment);
    });
  });
}).call(this);
