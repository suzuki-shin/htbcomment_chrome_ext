$(document).ready(function() {
  chrome.tabs.getSelected(window.id, function (tab) {
    var url = "http://b.hatena.ne.jp/entry/jsonlite/" + tab.url;
//  $("#dump").append($.dump(url));
    $.getJSON(url, function(json){
    var j = 0;
      for (var i in json.bookmarks) {
        var b = json.bookmarks[i];
        if (! b.comment) continue;
        $("#comments").append(b.comment + '<br />');
        j++;
        if (j > 20) break;
      }
    });
  });
});
