Rails.application.routes.draw do
  root to: 'pages#home'
  resources :time_sheets, only: :create
end
