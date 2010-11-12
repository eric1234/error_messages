Rails.application.routes.draw do
  resources :error_messages, :only => :index if Rails.env.development?
end
