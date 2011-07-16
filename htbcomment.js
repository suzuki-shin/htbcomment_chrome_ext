var cacheHour = 10;
var cacheMSec = cacheHour * 60 * 60 * 1000;
// var cacheMSec = 30000;

function displayComment(bookmarks) {
  var comment_num = 0;
  for (var i in bookmarks) {
    var b = bookmarks[i];
    if (! b.comment) continue;
    $("#comments").append(b.comment + '<br />');
    comment_num++;
    if (comment_num> 20) break;
  }
}

$(document).ready(function() {
  var dt = new Date();
  var now = dt.getTime();
  chrome.tabs.getSelected(window.id, function (tab) {
    var cache = localStorage[tab.url];
    //     $("#dump").append(now);
    //     $("#dump").append('<br>');
    //     $("#dump").append(JSON.parse(cache).createtd); // get cache
    if (cache && JSON.parse(cache).createtd > now - cacheMSec) {
      var json = JSON.parse(cache); // get cache
      //      $("#dump").append($.dump(json));
      //       console.log(json);
      displayComment(json.bookmarks);
    }
    else {
      var url = "http://b.hatena.ne.jp/entry/jsonlite/" + tab.url;
      $("#dump").append('api access...');
      //       console.log('api access...');
      $.getJSON(url, function(json){
        json.createtd = now;
        //         $("#dump").append($.dump(json));
        localStorage[tab.url] = JSON.stringify(json); // set cache
        displayComment(json.bookmarks);
      });
    }
  });
});
