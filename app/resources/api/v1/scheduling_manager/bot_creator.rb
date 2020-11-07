class Api::V1::SchedulingManager::BotCreator
  attr_accessor :params, :service, :employe, :customer, :execution_start, :execution_end

  def initialize(params)
    @params = params
    @service = Service.find(params[:service_id])
    @customer = Customer.find(params[:customer_id])
    @employe = Employe.find(params[:employe_id])
  end

  def execute
    define_service_execution_range
    return suggest_time if !available_time?

    scheduling = Scheduling.create(service: service,
                                   start: execution_start,
                                   finish: execution_end,
                                   scheduling_status_id: SchedulingStatus::SCHEDULED,
                                   customer: customer,
                                   employe: employe)

    if scheduling.save
      return {
        set_attributes: {
          scheduled: true,
          scheduling_id: scheduling.id
        },
        messages: [
          text: 'Seu agendamento foi criado com sucesso!'
        ]
      }
    end

    {
      set_attributes: {
        scheduled: false
      },
      messages: [
        text: 'Falha ao criar o agendamento, por favor tente novamente mais tarde.'
      ]
    }
  end

  private

  def define_service_execution_range
    splited_start_time = params[:start_time].split(':')
    start_hour = splited_start_time[0].to_i
    start_minute = splited_start_time[1].to_i

    execution_day = params[:date].to_datetime

    @execution_start = execution_day.change(hour: start_hour, min: start_minute)
    @execution_end = execution_start + (service.duration).minutes
  end

  def available_time?
    opening_hours = OpeningHour.find_by(weekday: execution_start.wday,
                                        company_id: company.id)

    return false if opening_hours.blank?

    schedulings = Scheduling.not_canceled.where("((start >= ? AND start <= ?) OR (finish >= ? AND finish <= ?)) AND employe_id = ? AND scheduling_status_id != ?",
                                                execution_start,
                                                execution_end,
                                                execution_start,
                                                execution_end,
                                                employe.id,
                                                SchedulingStatus::CANCELED)

    schedulings.blank?
  end

  def suggest_time
    suggestion = suggest_next_day
    suggestion ||= suggest_next_week
    suggestion
  end

  def suggest_next_day
    params[:date] = execution_start + 1.day
    define_service_execution_range

    unless available_time?
      params[:date] = execution_start - 1.day
      define_service_execution_range
      return
    end

    suggestion_time
  end

  def suggest_next_week
    params[:date] = execution_start + 7.days
    define_service_execution_range

    unless available_time?
      define_service_execution_range
      return no_time_available_error
    end

    suggestion_time
  end

  def no_time_available_error
    {
      set_attributes: {
        no_time_available: true,
        suggestion: false
      },
      messages: [
        text: 'Nenhuma sugestão foi encontrada para você, por favor tente escolher uma nova data manualmente'
      ]
    }
  end

  def suggestion_time
    {
      set_attributes: {
        scheduling_date: params[:date].strftime('%d/%m/%Y'),
        suggestion: true
      },
      messages: [
        {
          text: 'Infelizmente a data que você escolheu não está disponível :/'
        },
        {
          text: "Porém foi identificado que o dia #{params[:date].strftime('%d/%m/%Y')} está disponível para realização do serviço."
        }
      ]
    }
  end
end
