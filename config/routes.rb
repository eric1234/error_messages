ActionController::Routing::Routes.draw do |map|
  map.resources :error_messages, :only => :index if Rails.env.development?
end
