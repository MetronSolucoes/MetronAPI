module Api::V1::SchedulingManager
  class Creatir < Api::V1::ApplicationManager::Creator
    attr_accessor :params, :service, :execution_start, :execution_end

    private

    def initialize(params)
      @params = params
      @service = Service.find_by!(id: params[:service_id])
    end

    def execute_creation
      available_time?
    end

    def available_time?
      define_service_execution_range

      oppening_hours = OpeningHour.find_by!(weekday: execution_start.wday,
                                            company_id: Company.first)

      raise CustomException.new('O estabelecimento não funciona no dia em questão') if oppening_hours.blank?

      unless in_oppening_range?(oppening_hours)
        raise CustomException.new('O estabelecimento não funciona no horário em questão')
      end

      schedulings = Scheduling.not_canceled.where("(start >= ? AND start <= ?) OR (finish >= ? AND finish <= ?)",
                                                  execution_start,
                                                  execution_end,
                                                  execution_start,
                                                  execution_end)

      schedulings.blank?
    end

    def define_service_execution_range
      splited_start_time = params[:start_time].split(':')
      start_hour = splited_start_time[0]
      start_minute = splited_start_time[1]

      execution_day = params[:date].to_date

      @execution_start = execution_day.change( hour: start_hour, min: start_minute )
      @execution_end = execution_start + (service.duration).minutes
    end

    def in_oppening_range?(oppening_hours)
      start_hour = "#{execution_start.hour}.#{execution_start.min}"
      end_hour = "#{execution_end.hour}.#{execution_end.min}"

      oppening_hours.oppening_range === start_hour && oppening_hours.oppening_range === end_hour
    end


  end
end
