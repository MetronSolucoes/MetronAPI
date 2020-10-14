module Api::V1::SchedulingManager
  class Creator < Api::V1::ApplicationManager::Creator
    attr_accessor :params, :service, :execution_start, :execution_end

    private

    def initialize(params)
      @params = params
      @service = Service.find_by!(id: params[:service_id])
      @customer = Customer.find_by!(id: params[:customer_id])
      @employe = Employe.find_by!(id: params[:employe_id])
    end

    def execute_creation
      return suggest_time if !available_time?
      Scheduling.create!(service: @service,
                         start: execution_start,
                         finish: execution_end,
                         scheduling_status_id: SchedulingStatus::SCHEDULED,
                         customer: @customer,
                         employe: @employe)
    end

    def available_time?
      define_service_execution_range

      opening_hours = OpeningHour.find_by(weekday: execution_start.wday,
                                          company_id: Company.first)

      raise CustomException.new('O estabelecimento não funciona no dia em questão') if opening_hours.blank?

      unless in_opening_range?(opening_hours)
        raise CustomException.new('O estabelecimento não funciona no horário em questão')
      end

      schedulings = Scheduling.not_canceled.where("((start >= ? AND start <= ?) OR (finish >= ? AND finish <= ?)) AND employe_id = ? AND scheduling_status_id != ?",
                                                  execution_start,
                                                  execution_end,
                                                  execution_start,
                                                  execution_end,
                                                  @employe.id,
                                                  SchedulingStatus::CANCELED)

      schedulings.blank?
    end

    def define_service_execution_range
      splited_start_time = params[:start_time].split(':')
      start_hour = splited_start_time[0].to_i
      start_minute = splited_start_time[1].to_i

      execution_day = params[:date].to_datetime

      @execution_start = execution_day.change( hour: start_hour, min: start_minute )
      @execution_end = execution_start + (service.duration).minutes
    end

    def in_opening_range?(opening_hours)
      start_hour = "#{execution_start.hour}.#{execution_start.min}".to_f
      end_hour = "#{execution_end.hour}.#{execution_end.min}".to_f

      opening_hours.opening_range === start_hour && opening_hours.opening_range === end_hour
    end


    def suggest_time
      suggest_next_day
      suggest_next_week
    end

    def suggest_next_day
      params[:date] = execution_start + 1.day

      unless available_time?
        params[:date] = execution_start - 1.day
        return
      end

      suggestion_time
    end

    def suggestion_time
      {
        tag: :suggestion,
        suggestion_day: params[:date].strftime('%d/%m/%Y'),
        original_params: {
          customer_id: params[:customer_id],
          employe_id: params[:employe_id],
          service_id: params[:service_id],
          start_time: params[:start_time]
        }
      }
    end

    def suggest_next_week
      params[:date] = execution_start + 7.days
      raise CustomException.new("O sistema não achou nenhum horário disponível") unless available_time?
      suggestion_time
    end
  end
end
