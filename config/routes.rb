Rails.application.routes.draw do
  root to: 'time_sheets#home'
  default_url_options(host: ENV['HOST'] || 'localhost:3000')
  resources :time_sheets, only: :create do
    collection do
      get 'download/:folder', action: :download, as: :download
    end
  end
end
