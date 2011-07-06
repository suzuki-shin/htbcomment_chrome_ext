$(document).ready(function() {
  var url = "http://b.hatena.ne.jp/entry/jsonlite/" + "http://semooh.jp/jquery/api/ajax/jQuery.ajax/options/";
  $.getJSON(url, function(json){
// 	$("#dump").append($.dump(json.bookmarks));
    for (var i in json.bookmarks) {
	  var b = json.bookmarks[i];
      if (! b.comment) continue;
      $("#comments").append(b.comment + '<br />');
	}
  });
});
