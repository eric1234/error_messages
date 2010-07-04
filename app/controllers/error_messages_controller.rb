class ErrorMessagesController < ApplicationController

  def index
    return :nothing => true, :status => :not_found unless Rails.env.development?

    # Cannon messages
    flash.now[:notice] =  'Fuck yea...'
    flash.now[:warning] = 'Oh shit...'
    flash.now[:message] = 'Just letting you know...'

    # Alternate names
    flash.now[:success] = flash[:notice]
    flash.now[:error]   = flash[:warning]
    flash.now[:info]    = flash[:message]
    flash.now[:alert]   = flash[:message]

    # Corner cases
    flash.now[:long] = <<LONG
Some really long ass flash message that should wrap multiple lines in
case someone wants to get WAY more verbose than they should. Of course
peoples screens can be pretty wide so this paragraph could get quite
tedious. But in the name of testing is is well worth the effort.
LONG
    flash.now[:multiple] = ['Message 1', 'Message 2']

    @object = Object.new
    def Object.human_name; 'Object' end
    def Object.human_attribute_name(a); a.to_s.humanize end
    def @object.text; end
    def @object.multiline; end
    def @object.select; end
    def @object.checkbox; end
    def @object.file; end
    def @object.errors
      returning(ActiveRecord::Errors.new(self)) do |errors|
        errors.add_to_base 'Some generic error'
        %w(text multiline select checkbox file).each do |attr_type|
          errors.add attr_type.to_sym, 'error'
        end
      end
    end

    render :layout => false
  end

end