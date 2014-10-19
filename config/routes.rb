Rails.application.routes.draw do
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth',                    to: 'sessions#prepare', as: 'prepare_auth'
  get '/auth/failure',            to: 'sessions#oauth_failure'

  if Rails.env.test? || Rails.env.development?
    get '/auth/force/:user_id',     to: 'sessions#force_signin_in_test'
  end

  resources :walls, only: %i(show create) do
    member do
      post :leave
    end
  end

  resources :accounts, only: %i(new create show) do
    resources :invitations, only: %i(index create destroy)
    resources :users, only: %i(index create destroy)
  end

  namespace :api do

    post  '/walls/:wall_id/upload-requests', to: 'walls#create_upload_policy'
    post  '/walls/:wall_id/photos',          to: 'walls#create_photo'
    get   '/walls/:wall_id',                 to: 'walls#show'
    put   '/walls/:wall_id/status',          to: 'walls#status',                as: 'update_status'
  end

  root to: 'static#homepage'
end
