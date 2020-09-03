module Api::V1::ServiceManager
  class Destroyer < Api::V1::ApplicationManager::Destroyer

    private

    def execute_destruction
      Service.find_by!(id: id).destroy
    end
  end
end
