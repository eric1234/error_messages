require 'error_messages'
ActionView::Base.send :include, ErrorMessages
ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  type = html_tag.scan(/type\=\"([^\"]+)\"/).first.first + 'WithErrors' rescue nil
  %Q{<span class="fieldWithErrors #{type}">#{html_tag}</span>}
end