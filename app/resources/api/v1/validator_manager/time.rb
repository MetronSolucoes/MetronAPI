class Api::V1::ValidatorManager::Time
  attr_accessor :scheduling_time, :scheduling_date, :company, :service,
    :execution_start, :execution_end

  def initialize(scheduling_time, scheduling_date, service_id, company = Company.first)
    @scheduling_time = scheduling_time
    @scheduling_date = scheduling_date
    @service = find_service(service_id)
    @company = company
  end

  def execute
    return malformatted_time_error if malformatted_time?

    define_execution_range
    return not_oppening_range_error unless in_open_range?

    success_response
  end

  private

  def malformatted_time?
    splited_time = split_time

    verifications_results = splited_time.map do |t|
      t.scan(/\D/).empty?
    end

    verifications_results.include?(false)
  end

  def in_open_range?
    opening_hours = OpeningHour.find_by(weekday: execution_start.wday,
                                        company_id: company.id)

    return false if opening_hours.blank?

    start_hour = "#{execution_start.hour}.#{execution_start.min}".to_f
    end_hour = "#{execution_end.hour}.#{execution_end.min}".to_f

    opening_hours.opening_range === start_hour && opening_hours.opening_range === end_hour
  end

  def define_execution_range
    splited_start_time = split_time
    start_hour = splited_start_time[0].to_i
    start_minute = splited_start_time[1].to_i

    execution_day = scheduling_date.to_datetime

    @execution_start = execution_day.change(hour: start_hour, min: start_minute)
    @execution_end = execution_start + (service.duration).minutes
  end

  def split_time
    scheduling_time.delete(' ').split(':')
  end

  def find_service(service_id)
    Service.find(service_id)
  end

  def success_response
    {
      set_attributes: {
        time_valid: true
      }
    }
  end

  ## Respostas de erro

  def malformatted_time_error
    {
      set_attributes: {
        time_valid: false
      },
      messages: [
        {
          text: 'O horário informado está mal formatado, por favor tente novamente utilizando o formato do exemplo: 15:30'
        }
      ]
    }
  end

  def not_oppening_range_error
    {
      set_attributes: {
        time_valid: false
      },
      messages: [
        {
          text: 'O estabelecimento não funciona no horário em questão'
        }
      ]
    }
  end
end
