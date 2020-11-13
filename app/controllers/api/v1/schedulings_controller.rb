class Api::V1::SchedulingsController < Api::V1::ApplicationController

  def index
    schedulings = Api::V1::SchedulingManager::Lister.new(0, 0, params, true).build
    render json: schedulings, status: :ok
  end

  #  def index_without_canceleds
  #   schedulings = Scheduling.not_canceled.__search(params)
  #  render json: schedulings, meta: pagination(schedulings), each_serializer: Api::V1::SchedulingSerializer, status: :ok
  #end

  def show
    scheduling = Api::V1::SchedulingManager::Shower.new(params[:id], true, params).build
    render json: scheduling, status: :ok
  end

  def create
    scheduling = Api::V1::SchedulingManager::BotCreator.new(scheduling_params).execute
    render json: scheduling, status: :created
  end

  def destroy
    scheduling = Api::V1::SchedulingManager::Destroyer.new(params[:id])
    render json: scheduling.destroy, status: :ok
  end

  def date_validate
    render json: Api::V1::ValidatorManager::Date.new(params[:scheduling_date]).execute, status: :ok
  end

  def time_validate
    render json: Api::V1::ValidatorManager::Time.new(params[:scheduling_time],
                                                     params[:scheduling_date],
                                                     params[:service_id]).execute, status: :ok
  end

  def opening_hour
    render json: {
      messages: [
        {
          text: "Selecione o horário no qual deseja fazer o serviço, este estabelecimento funciona nos seguintes horários: #{Company.first.opening_hour(params[:weekday])}"
        }
      ]
    }
  end

  private

  def scheduling_params
    params.require(:scheduling).permit(:customer_id, :service_id, :employe_id,
                                       :scheduling_status_id, :date, :start_time)
  end
end
