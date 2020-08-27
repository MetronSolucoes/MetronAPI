module Api::V1::ServiceManager
  class Updater < Api::V1::ApplicationManager::Updater

    private

    def execute_update
      service = find_service
      validate_duration if params[:duration].present?
      service.update(params)
      service
    end

    def find_service
      Service.find_by!(id: id)
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
