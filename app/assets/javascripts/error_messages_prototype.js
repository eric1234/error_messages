if(typeof(Effect) != 'undefined' && !window.location.search.match(/disable_error_animation/))
  Event.observe(document, 'dom:loaded', function() {
    $w('notice info alert message success').each(function(flash_type) {
      $$('.flash-'+flash_type).each(function(flash_message) {
        Effect.BlindUp(flash_message, {delay: 3});
        Effect.Fade(flash_message, {delay: 3});
      });
    });
  });

Event.observe(document, 'dom:loaded', function() {
  var messages = $$('.error-messages');
  var position = messages.length;
  function hideAll() {messages.each(Element.hide)}
  messages.each(function(msg) {
    var input;
    var container = msg.up('.field-with-errors');
    // Necessary for IE 7 zIndex bug. See:
    // http://www.quirksmode.org/bugreports/archives/2006/01/Explorer_z_index_bug.html
    container.setStyle({zIndex: position--});
    var hover = $w('file checkbox radio');
    if(hover.any(function(type) {return container.hasClassName(type+'-with-errors')})) {
      input = container.down('input');
      input.observe('mouseover', function() {hideAll(); msg.show()});
      input.observe('mouseout', function() {hideAll()});
    } else {
      if(input = container.down('select')) {
        input.observe('mouseover', function() {hideAll(); msg.show()});
        input.observe('mouseout', function() {hideAll()});
      } else {
        input = container.down('textarea');
        if(!input) input = container.down('input');
        input.observe('focus', function() {hideAll(); msg.show()})
        input.observe('blur', function() {hideAll()})
      }
    }
  });
});
