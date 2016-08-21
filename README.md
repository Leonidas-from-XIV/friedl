friedl - A wigglegram viewer
============================

`friedl` is an embeddable viewer for wigglegrams, that is multi-image series of
the same object.

How to use
----------

Provided you have a `div` like this that you'd like to replace by the
wigglegram widget:

```html
<div id="wigglegram"></div>
```

Load the `elm.js` into your page, in the `head`:

```html
<script src="elm.js"></script>
```

Then you can specify your images to be wiggled in left-to-right order and let
your `div` be replaced:

```html
<script type="text/javascript">
  var images =
    [ "https://xivilization.net/~marek/wiggle/tree0.jpg"
    , "https://xivilization.net/~marek/wiggle/tree1.jpg"
    , "https://xivilization.net/~marek/wiggle/tree2.jpg"
    , "https://xivilization.net/~marek/wiggle/tree3.jpg"
    ];
  var div = document.getElementById('wigglegram');
  var wigglegram = Elm.Main.embed(div, images);
</script>
```

Name
----

Yes, it is named after [Jeffrey Friedl](http://regex.info/blog/jfriedl-links/about),
who made the first [wigglegram that I liked](http://regex.info/blog/2016-08-13/2721)
and [wrote how to make these](http://regex.info/blog/2014-12-15/2500).

License
-------

Apache License, Version 2.0
