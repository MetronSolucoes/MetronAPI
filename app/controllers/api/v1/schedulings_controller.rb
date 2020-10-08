class Api::V1::SchedulingsController < Api::V1::ApplicationController
  before_action :set_scheduling, only: [:show, :update, :destroy, :cancel_scheduling]

  def index
    schedulings = Scheduling.__search(params)
    render json: schedulings, meta: pagination(schedulings), each_serializer: Api::V1::SchedulingSerializer, status: :ok
  end

  def index_without_canceleds
    schedulings = Scheduling.not_canceled.__search(params)
    render json: schedulings, meta: pagination(schedulings), each_serializer: Api::V1::SchedulingSerializer, status: :ok
  end

  def show
    #tirar os cancelados? e para o backoffice? ou so fazer logica de nao considerar cancelados na parte do retorno do horario
    render json: @scheduling, serializer: Api::V1::SchedulingSerializer, status: :ok #ajustar retorno do relacionamento
  end

  def create
    scheduling = Api::V1::SchedulingManager::Creator.new(scheduling_params).create
    render json: scheduling, status: :created
  end

  def update
    if @scheduling.update_attributes(scheduling_params)
      render json: @scheduling, serializer: Api::V1::SchedulingSerializer, status: :ok
    else
      render json_validation_error(@scheduling.errors, 'Falha ao atualizar agendamento')
    end
  end

  def cancel_scheduling
    if @scheduling.update_attributes(scheduling_status_id: SchedulingStatus::CANCELED)
      render json: @scheduling, serializer: Api::V1::SchedulingSerializer, status: :ok
    else
      render json_validation_error(@scheduling, 'Falha ao cancelar agendamento')
    end
  end

  private

  def set_scheduling
    @scheduling = Scheduling.find(params[:id])
  end

  def scheduling_params
    params.require(:scheduling).permit(:customer_id, :service_id, :scheduling_status_id, :date, :start_time)
  end
end
