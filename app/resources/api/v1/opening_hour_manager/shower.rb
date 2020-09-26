module Api::V1::OpeningHourManager
  class Shower < Api::V1::ApplicationManager::Shower
    private

    def instance
      OpeningHour.find_by!(id: id)
    end
  end
end