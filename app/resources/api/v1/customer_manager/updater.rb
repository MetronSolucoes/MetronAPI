module Api::V1::CustomerManager
  class Updater < Api::V1::ApplicationManager::Updater
    private

    def execute_update
      customer = Customer.find_by!(id: id)
      customer.update!(@params)

      customer
    end

    def initialize(id, params)
      super(id)
      @params = params.slice(:name, :last_name, :cpf, :phone, :email)
    end
  end
end