module Api::V1::CustomerManager
  class Updater < ApplicationManager::Updater
    private

    def execute_update
      customer = Customer.find_by!(id: id)
      customer.update!(@params)

      account
    end

    def initialize(id, params)
      super(id)
      @params = params.slice(:name) #aqui viria os parametros que podem ser editados, coloquei so um de exemplo
    end
end