module Api::V1::CustomerManager
  class Creator < Api::V1::ApplicationManager::Creator
    private

    def execute_creation
      Customer.create!(name: @name, last_name: @last_name, cpf: @cpf, phone: @phone, email: @email)
    end

    def initialize(name, last_name, cpf, phone, email)
      @name = name
      @last_name = last_name
      @cpf = cpf
      @phone = phone
      @email = email
    end
  end
end
