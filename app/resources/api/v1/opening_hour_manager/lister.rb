module Api::V1::OpeningHourManager
  class Lister < Api::V1::ApplicationManager::Lister
    private

    def filter
      OpeningHour.__search(@filters)
    end
  end
end