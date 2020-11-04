class Api::V1::SchedulingsController < Api::V1::ApplicationController

  def index
    schedulings = Api::V1::SchedulingManager::Lister.new(0, 0, params).build
    render json: schedulings, meta: pagination(schedulings), each_serializer: Api::V1::SchedulingSerializer, status: :ok
  end

  #  def index_without_canceleds
  #   schedulings = Scheduling.not_canceled.__search(params)
  #  render json: schedulings, meta: pagination(schedulings), each_serializer: Api::V1::SchedulingSerializer, status: :ok
  #end

  def show
    scheduling = Api::V1::SchedulingManager::Shower.new(params[:id]).build
    render json: scheduling, serializer: Api::V1::SchedulingSerializer, status: :ok
  end

  def create
    scheduling = Api::V1::SchedulingManager::Creator.new(scheduling_params).create
    render json: scheduling, status: :created
  end

  def destroy
    scheduling = Api::V1::SchedulingManager::Destroyer.new(params[:id])
    render json: scheduling.destroy, status: :ok
  end

  def date_validate
    scheduling_date = params[:scheduling_date]
    return invalid_date_error if scheduling_date.blank?
    return invalid_date_error unless date_valid?(scheduling_date)

    render json: {
      set_attributes: {
        date_valid: true,
        weekday: @date.wday
      }
    }
  end

  def opening_hour
    render json: {
      messages: [
        {
          text: "Selecione o horário no qual deseja fazer o serviço, informe no formato HH:MM, este estabelicmento funciona nos seguintes horários: #{Company.first.opening_hour(params[:weekday])}"
        }
      ]
    }
  end

  private

  def invalid_date_error
    render json: {
      set_attributes: {
        date_valid: false
      },
      messages: [
        {
          text: "A data informada está mal formatada ou o estabelicmento não abre no dia em questão, por favor tente novamente!"
        }
      ]
    }
  end

  def date_valid?(scheduling_date)
    date_valid = true
    splited_date = scheduling_date.delete(' ').split('/')

    splited_date.map do |d|
      next if d.scan(/\D/).empty?

      date_valid = false
    end

    return date_valid unless date_valid

    day = splited_date[0].try(:to_i)
    month = splited_date[1].try(:to_i)
    year = splited_date[2].try(:to_i)

    return false unless (01..31).include?(day)
    return false unless (01..12).include?(month)
    return false unless (2020..2100).include?(year)

    @date = Date.new(year, month, day)

    return false if OpeningHour.find_by(company_id: Company.first.id,
                                        weekday: date.wday).blank?

    return false if date.end_of_day.past?

    true
  end

  def have

    def scheduling_params
      params.require(:scheduling).permit(:customer_id, :service_id, :employe_id,
                                         :scheduling_status_id, :date, :start_time)
    end
  end
end
