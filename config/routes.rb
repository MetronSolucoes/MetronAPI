Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :services
      resources :customers
      resources :schedulings

      get 'companies', to: 'companies#show'
      put 'companies', to: 'companies#update'
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
