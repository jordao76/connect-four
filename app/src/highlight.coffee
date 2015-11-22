$ = jQuery

$.fn.highlight = ->
  ($ this).each ->
    el = $ this
    $ '<div/>'
      .width el.outerWidth()
      .height el.outerHeight()
      .addClass 'highlighted-tile'
      .css
        'left': el.offset().left
        'top': el.offset().top
      .appendTo 'body'
      .fadeOut 1000
      .queue -> ($ this).remove()
