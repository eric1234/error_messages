# The only reason this is an engine instead of just a simple Railtie
# is to allow the test page for development mode. Maybe there is a
# better way to do this?
class ErrorMessages::Engine < Rails::Engine

  initializer 'error_messages.helpers' do
    ActionView::Base.send :include, ErrorMessages::Helpers
  end

  initializer 'error_messages.field_error_proc' do
    ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
      type = html_tag.scan(/type\=\"([^\"]+)\"/).first.first + 'WithErrors' rescue nil
      %Q{<span class="fieldWithErrors #{type}">#{html_tag}</span>}.html_safe
    end
  end

  rake_tasks do
    load "error_messages/assets.rake"
  end
end
