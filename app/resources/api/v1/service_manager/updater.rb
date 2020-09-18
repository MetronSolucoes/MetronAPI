module Api::V1::ServiceManager
  class Updater < Api::V1::ApplicationManager::Updater

    private

    def execute_update
      service = find_service
      service.update(params)
      service
    end

    def find_service
      Service.find_by!(id: id)
    end
  end
end
