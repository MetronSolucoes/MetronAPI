module Api::V1::ServiceManager
  class Creator < ApplicationManager::Creator
    attr_accessor :params

    def initialize(params)
      @params = params
    end

    private

    def execute_creation
      validate_duration
      Service.create(params)
    end

    def validate_duration
      duration = params[:duration].to_i
      if duration < 30
        raise CustomException.new('A duração miníma do serviço deverá ser de 30 minutos')
      end

      return if divisible_per_fifteen?(duration)

      raise CustomException, 'Duração inválida'
    end

    def divisible_per_fifteen?(duration)
      (duration % 15).zero?
    end
  end
end
