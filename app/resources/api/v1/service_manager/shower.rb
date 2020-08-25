module Api::V1::ServiceManager
  class Shower < Api::V1::ApplicationManager::Shower
    private

    def instance
      Service.find_by!(id: id)
    end
  end
end
