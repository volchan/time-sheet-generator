Rails.application.routes.draw do
  root to: 'time_sheets#home'
  resources :time_sheets, only: :create
end
