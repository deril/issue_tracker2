Rails.application.routes.draw do
  resources :tickets, only: %i[show create update destroy]
  get 'tickets(/pages/:page)', to: 'tickets#index', defaults: { page: 1 }
end
