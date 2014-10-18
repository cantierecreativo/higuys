Rails.application.routes.draw do
  resources :walls, only: %i(show create)
  root to: 'static#homepage'
end

