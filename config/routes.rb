Rails.application.routes.draw do
  resources :walls, only: %i(show create)

  namespace :api do
    post '/upload-requests', to: 'images#upload_request'
    post '/photos', to: 'images#photos'
  end

  root to: 'static#homepage'
end

