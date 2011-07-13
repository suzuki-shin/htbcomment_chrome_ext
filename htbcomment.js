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
  chrome.tabs.getSelected(window.id, function (tab) {
    if (! localStorage[tab.url]) {
      var url = "http://b.hatena.ne.jp/entry/jsonlite/" + tab.url;
     $("#dump").append('api access...');
      console.log('api access...');
      $.getJSON(url, function(json){
        localStorage[tab.url] = JSON.stringify(json); // set cache
//      $("#dump").append($.dump(json));
        displayComment(json.bookmarks);
      });
    }
    else {
      var json = JSON.parse(localStorage[tab.url]); // get cache
      console.log(json);
      displayComment(json.bookmarks);
    }
  });
});
