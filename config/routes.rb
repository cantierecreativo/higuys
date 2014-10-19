Rails.application.routes.draw do
  get '/auth/github/callback', to: 'sessions#create'
  get '/auth',                 to: 'sessions#prepare', as: 'sign_in'
  get '/auth/failure',         to: 'sessions#oauth_failure'
  delete '/auth',              to: 'sessions#destroy', as: 'sign_out'

  if Rails.env.test? || Rails.env.development?
    get '/auth/force/:user_id',     to: 'sessions#force_signin_in_test'
  end

  resources :walls, only: %i(show create) do
    member do
      post :leave
    end
  end

  resources :accounts, only: %i(new create show) do
    resources :invitations, only: %i(index create destroy) do
      collection do
        get :accept
      end
    end
    member do
      post :leave
    end
    resources :users, only: %i(index create destroy)
  end

  namespace :api do
    post  '/wall/upload-requests',       to: 'walls#create_upload_policy'
    post  '/wall/photos',                to: 'walls#create_photo'
    get   '/wall',                       to: 'walls#show'
    put   '/wall/status',                to: 'walls#status',                as: 'wall_update_status'
  end

  root to: 'static#homepage'
end

