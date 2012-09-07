unless window.location.search.match /disable_error_animation/
  jQuery(document).ready ($) ->
    $(['notice', 'info', 'alert', 'message', 'success']).each (idx, flash_type) ->
      behavior = {duration: 1000, queue: false}
      animate = -> $(".flash-#{flash_type}").fadeOut(behavior).slideUp(behavior)
      setTimeout animate, 3000

jQuery(document).ready ($) ->
  messages = $ '.error-messages'
  position = messages.length
  messages.each (idx, msg) ->
    msg = $ msg
    input = null
    container = msg.closest '.field-with-errors'
    # Necessary for IE 7 zIndex bug. See:
    # http://www.quirksmode.org/bugreports/archives/2006/01/Explorer_z_index_bug.html
    container.css 'z-index', position--
    hover = ['file', 'checkbox', 'radio']
    hovering = false
    for type in hover
      hovering = true if container.hasClass "#{type}-with-errors"
    if hovering
      input = container.find 'input'
      input.mouseover ->
        messages.hide()
        msg.show()
      input.mouseout -> messages.hide()
    else
      if input = container.find('select')[0]
        input.mouseover ->
          messages.hide()
          msg.show()
        input.mouseout -> messages.hide()
      else
        input = container.find 'textarea, input'
        input.focus ->
          messages.hide()
          msg.show()
        input.blur -> messages.hide()
