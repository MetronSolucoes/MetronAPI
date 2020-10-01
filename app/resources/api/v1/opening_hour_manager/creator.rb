module Api::V1::OpeningHourManager
  class Creator < Api::V1::ApplicationManager::Creator
    private

    def execute_creation
      OpeningHour.create!(opening_time: @opening_time, closing_time: @closing_time, weekday: @weekday, company_id: @company_id)
    end

    def initialize(opening_time, closing_time, weekday)
      @opening_time = opening_time
      @closing_time = closing_time
      @weekday = weekday
      @company_id = Company.first.id
    end
  end
end
