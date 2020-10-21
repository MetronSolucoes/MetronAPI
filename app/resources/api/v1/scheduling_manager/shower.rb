module Api::V1::SchedulingManager
  class Shower < Api::V1::ApplicationManager::Shower
    private

    def instance
      Scheduling.find_by!(id: id)
    end
  end
end
