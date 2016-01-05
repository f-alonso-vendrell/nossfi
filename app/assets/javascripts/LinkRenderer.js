 // original by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
  function strip_tags(input, allowed) {
    var tags = /<\/?([a-z][a-z0-9]*)\b[^>]*>/gi,
      commentsAndPhpTags = /<!--[\s\S]*?-->|<\?(?:php)?[\s\S]*?\?>/gi;

    // making sure the allowed arg is a string containing only tags in lowercase (<a><b><c>)
    allowed = (((allowed || "") + "").toLowerCase().match(/<[a-z][a-z0-9]*>/g) || []).join('');

    return input.replace(commentsAndPhpTags, '').replace(tags, function ($0, $1) {
      return allowed.indexOf('<' + $1.toLowerCase() + '>') > -1 ? $0 : '';
    });
  };

function linkRenderer (instance, td, row, col, prop, value, cellProperties) {

  	if ( value == null)
  	{
  		Handsontable.renderers.TextRenderer.apply(this, arguments);
  		return td;

  	}

    var data = value.split("|");

    if (data.length!=2)
    {
       Handsontable.renderers.TextRenderer.apply(this, arguments);
    }
    else
    {
        var label = Handsontable.helper.stringify(data[0]);
        label=strip_tags(label, '<em><b><strong><a><big>');
        var link = Handsontable.helper.stringify(data[1]);
        var escaped = strip_tags(link, '<em><b><strong><a><big>');

        if (link.indexOf('http') === 0) {

          td.innerHTML = "<a href="+escaped+">"+label+"</a>";

        }
        else
        {
          Handsontable.renderers.TextRenderer.apply(this, arguments);
        }
    }

    

    return td;
};