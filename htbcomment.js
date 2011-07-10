$(document).ready(function() {
  var comment_num = 0;
  chrome.tabs.getSelected(window.id, function (tab) {
//      $("#dump").append($.dump(tab));
    var url = "http://b.hatena.ne.jp/entry/jsonlite/" + tab.url;
    $.getJSON(url, function(json){
      for (var i in json.bookmarks) {
        var b = json.bookmarks[i];
        if (! b.comment) continue;
        $("#comments").append(b.comment + '<br />');
        comment_num++;
        if (comment_num> 20) break;
      }
    });
  });
});
