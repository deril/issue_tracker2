Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  mount_devise_token_auth_for 'Manager', at: 'admin_auth'
  resources :tickets, only: %i[show create update destroy]
  get 'tickets(/pages/:page)', to: 'tickets#index', defaults: { page: 1 }
end
