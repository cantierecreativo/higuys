Rails.application.routes.draw do
  resources :walls, only: %i(show create) do
    member do
      post :leave
    end
  end

  namespace :api do
    post '/walls/:wall_id/upload-requests', to: 'images#upload_request'
    post '/walls/:wall_id/photos', to: 'images#photos'
    get '/walls/:wall_id/status', to: 'status#index'
  end

  root to: 'static#homepage'
end

