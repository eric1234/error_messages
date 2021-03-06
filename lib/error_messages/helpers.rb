module ErrorMessages::Helpers

  # Display any flash messages set in a container to be easily styled.
  def flash_messages(*flash_types)
    flash_types = flash.keys if flash_types.empty?
    flash_types.collect do |type|
      type = type.to_sym
      next if flash[type].blank?
      content = if flash[type].is_a? String
        flash[type]
      else
        items = flash[type].collect do |item|
          content_tag 'li', item
        end
        content_tag 'ul', items.join.html_safe
      end
      # A wrapper div helps fix some javascript up
      content = content_tag 'div', content
      content_tag 'div', content, :class => "flash-#{type} flash-block"
    end.compact.join.html_safe
  end

end
