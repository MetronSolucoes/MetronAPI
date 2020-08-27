module Api::V1::ServiceManager
  class Destroyer < Api::V1::ApplicationManager::Destroyer

    private

    def execute_destruction
      service = find_service
      service.destroy
    end

    def find_service
      Service.find_by!(id: id)
    end
  end
end
