class Api::V1::SchedulingsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound do |e|
    render_json_error :not_found, :scheduling_not_found
  end

  def index
    schedulings = Scheduling.ransack(params[:q]).result
    render json: schedulings, status: :ok #ajustar retorno do relacionamento
  end

  def show
    scheduling = set_scheduling #tirar os cancelados? e para o backoffice? ou so fazer logica de nao considerar cancelados na parte do retorno do horario
    render json: scheduling, status: :ok #ajustar retorno do relacionamento
  end

  def create
    scheduling = Scheduling.new(scheduling_params)
    
    if scheduling.save
      render json: scheduling, status: :created
    else
      render json: { message: 'Falha ao criar agendamento', errors: scheduling.errors }, status: :unprocessable_entity 
    end
  end

  # def update
  #   scheduling = set_scheduling
    
  #   if scheduling.update_attributes(scheduling_params)
  #     render json: scheduling, status: :ok
  #   else
  #     render json: { message: 'Falha ao atualizar agendamento' }, status: :unprocessable_entity
  #   end
  # end

  def destroy
    scheduling = set_scheduling
    scheduling.scheduling_status_id = SchedulingStatus::CANCELED
    render json: { message: 'Falha ao deletar agendamento' }, status: :unprocessable_entity unless scheduling.save
  end

  private
    def set_scheduling
      Scheduling.find(params[:id])
    end

    def scheduling_params
      params.require(:scheduling).permit(:customer_id, :service_id, :scheduling_status_id, :start, :finish)
    end
end