Rails.application.routes.draw do
  resources :walls, only: %i(show create) do
    member do
      post :leave
    end
  end

  namespace :api do
    post '/upload-requests', to: 'images#upload_request'
    post '/photos', to: 'images#photos'
    get '/status/:wall_id', to: 'status#index'
  end

  root to: 'static#homepage'
end

