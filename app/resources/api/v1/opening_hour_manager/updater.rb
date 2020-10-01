module Api::V1::OpeningHourManager
  class Updater < Api::V1::ApplicationManager::Updater
    private

    def execute_update
      opening_hour = OpeningHour.find_by!(id: id)
      opening_hour.update!(@params)

      opening_hour
    end

    def initialize(id, params)
      super(id)
      @params = params.slice(:opening_time, :closing_time, :weekday)
    end
  end
end