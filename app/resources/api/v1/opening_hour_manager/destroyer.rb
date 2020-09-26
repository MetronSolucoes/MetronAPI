module Api::V1::OpeningHourManager
  class Destroyer < Api::V1::ApplicationManager::Destroyer
    private

    def execute_destruction
      OpeningHour.find_by!(id: id).delete
    end
  end
end