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
  # the problem. The problem is where to put the error message.
  #
  # My solution is to put it in the container but have it hidden by
  # default. When they use positioning and JavaScript to show the
  # message when the field gets focus.
  #
  # Since some fields cannot handle a popup error message well (dates,
  # rich text) you can also add the class "error-before" or
  # "error-after". In this case the error will be on the form (instead
  # of a popup) either above the field or below the field.
  #
  # By default the field name is not includes in the message as it is
  # usually not necessary (and difficult to determine easily). But if
  # you want you can add the attribute data-error-label="Field name" to
  # set a field name which will be includes in the error message.
  initializer 'error_messages.field_error_proc' do
    ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
      type = html_tag.scan(/type\=\"([^\"]+)\"/).first.first rescue nil
      type = 'textarea' if !type && html_tag.include?('<textarea')
      type = 'select' if !type && html_tag.include?('<select')
      type += '-with-errors' if type
      if type # Type is known so attach error message

        label = html_tag.scan(/data\-error\-label\=\"([^\"]+)\"/).first.first rescue nil
        messages = instance.error_message.collect do |e|
          if label
            e = "#{label} #{e}"
          else
            e[0] = e.first.capitalize
          end
          "<span>#{e}</span>"
        end.join

        classes = html_tag.scan(/class\=\"([^\"]+)\"/).first.first rescue ''
        # NOTE: Care is taken to not add whitespace nodes
        case
          when classes.include?('error-before')
            %Q{<span class="field-with-errors #{type}"
                ><span class="inline-error-messages">#{messages}</span><br
                >#{html_tag}</span>}.html_safe
          when classes.include?('error-after')
            %Q{<span class="field-with-errors #{type}"
                >#{html_tag}<br
                ><span class="inline-error-messages">#{messages}</span
              ></span>}.html_safe
          else
            %Q{<span class="field-with-errors #{type}"
              >#{html_tag}<span class="error-messages" style="display: none">#{messages}</span
              ></span>}.html_safe
        end
      else # Labels and unknown attributes
        %Q{<span class="field-with-errors">#{html_tag}</span>}.html_safe
      end
    end
  end
end
