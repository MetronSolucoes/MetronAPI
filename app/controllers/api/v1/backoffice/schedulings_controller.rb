class Api::V1::Backoffice::SchedulingsController < Api::V1::Backoffice::ApplicationController
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

  # Criar um serviço especifico para isto
  def create
    scheduling = Scheduling.new(scheduling_params)

    if scheduling.save
      render json: scheduling, serializer: Api::V1::SchedulingSerializer, status: :created
    else
      render json_validation_error(scheduling.errors, 'Falha ao criar agendamento')
    end
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

  # Rever este metodo, esta fazendo a mesam coisa que o de cima
  def destroy
    @scheduling.scheduling_status_id = SchedulingStatus::CANCELED
    render json: { message: 'Falha ao deletar agendamento' }, status: :unprocessable_entity unless @scheduling.save
  end

  # Tratar esta lógica em um serviço próprio
  def available_times
    initial_check = params[:initial_check].to_datetime
    final_check = params[:final_check].to_datetime
    schedulings = Scheduling.not_canceled.where("(start > ? AND start < ?) OR (finish > ? AND finish < ?)", initial_check, final_check, initial_check, final_check)

    available_times = []
    schedulings.each do |scheduling|
      if initial_check > scheduling.start
        available_times.push({ initial: scheduling.finish, final: final_check })
      elsif final_check <  scheduling.finish
        available_times.push({ initial: initial_check, final: scheduling.start })
      else
        available_times.push({ initial: initial_check, final: scheduling.start })
        available_times.push({ initial: scheduling.finish, final: final_check })
      end
    end

    render json: available_times, status: :ok
  end

  private

  def set_scheduling
    @scheduling = Scheduling.find(params[:id])
  end

  def scheduling_params
    params.require(:scheduling).permit(:customer_id, :service_id, :scheduling_status_id, :start, :finish)
  end
end
