Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :services
      resources :customers
      resources :schedulings
      get 'schedulings/index/not_canceleds', to: 'schedulings#index_without_canceleds'
      put 'schedulings/cancel/:id', to: 'schedulings#cancel_scheduling'
      post 'schedulings/available_times', to: 'schedulings#available_times'

      get 'companies', to: 'companies#show'
      put 'companies', to: 'companies#update'
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
