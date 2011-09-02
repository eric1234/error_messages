# We are an engine instead of a simple Railtie for two reasons:
#
#   * We are using the Rails asset pipeline which requires an engine.
#   * Our test page allows us a controller.
class ErrorMessages::Railtie < Rails::Engine

  # Let everybody know about our snazzy helper :)
  initializer 'error_messages.helpers' do
    ActiveSupport.on_load(:action_view) do
      include ErrorMessages::Helpers
    end
  end

  # The default implementation of field_error_proc not very good. It
  # doesn't help you style the different field types. It also is based
  # on the old error model of:
  #
  #   * List of errors at the top
  #   * Fields highlighted on the form to help people find the fields
  #     the top is complaining about.
  #
  # But the list at the top was often not useful because it assumed
  # everything had a simple name (i.e. email, phone number, etc.). But
  # often the "question" be asked of the user was an entire paragraph.
  # Or multiple fields had the same name ("Mother First Name",
  # "Fathers First Name" would often just show up as "First Name"
  # because they are both related objects and it was just conveying the
  # field name not the field name with relationship).
  #
  # Add to this, Rails has taken out the helper that does the list at
  # the top. So you have to install a plugin to really use it now.
  #
  # I like the in-line notification. Makes it obvious which field has
  # the problem. The problem is where to put the message (value too long,
  # can't be blank, etc).
  #
  # Our solution is to put it in the container but have it hidden by
  # default. When they use positioning and JavaScript to show the
  # message when the field gets focus.
  initializer 'error_messages.field_error_proc' do
    ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
      type = html_tag.scan(/type\=\"([^\"]+)\"/).first.first rescue nil
      type = 'textarea' if !type && html_tag.include?('<textarea')
      type = 'select' if !type && html_tag.include?('<select')
      type += '-with-errors' if type
      if type
        # Type is known so attach error message
        messages = instance.error_message.collect do |e|
          e[0] = e.first.capitalize
          "<span>#{e}</span>"
        end.join
        %Q{
          <span class="field-with-errors #{type}">
            #{html_tag}
            <span class="error-messages" style="display: none">#{messages}</span>
          </span>
        }.html_safe
      else
        # Labels and unknown attributes
        %Q{<span class="field-with-errors">#{html_tag}</span>}.html_safe
      end
    end
  end
end
