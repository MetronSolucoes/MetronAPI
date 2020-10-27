Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do

      namespace :backoffice do
        post 'authentication', to: 'authentication#authenticate_user'

        resources :services
        resources :customers
        resources :opening_hours
        resources :users
        resources :schedulings


        get 'schedulings/index/not_canceleds', to: 'schedulings#index_without_canceleds'
        put 'schedulings/cancel/:id', to: 'schedulings#cancel_scheduling'
        post 'schedulings/available_times', to: 'schedulings#available_times'

        resources :employes do
          post '/link_service/:service_id', to: 'employes#link_service'
          delete '/unlink_service/:service_id', to: 'employes#unlink_service'
        end

        get 'companies', to: 'companies#show'
        put 'companies', to: 'companies#update'
      end

      resources :services, only: [:index, :show]
      resources :customers, only: [:show, :update]
      resources :schedulings, only: [:show, :create, :destroy, :index]

      get 'employes', to: 'employes#index'

      get 'schedulings/index/not_canceleds', to: 'schedulings#index_without_canceleds'
      put 'schedulings/cancel/:id', to: 'schedulings#cancel_scheduling'
      post 'schedulings/available_times', to: 'schedulings#available_times'
    end
  end
end
