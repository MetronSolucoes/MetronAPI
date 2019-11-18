class Api::V1::SchedulingsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound do |e|
    render_json_error :not_found, :scheduling_not_found
  end

  def index
    schedulings = Scheduling.ransack(params[:q]).result
    render json: response_schedulings(schedulings), status: :ok #ajustar retorno do relacionamento
  end

  def index_without_canceleds
    schedulings = Scheduling.not_canceled.ransack(params[:q]).result
    render json: response_schedulings(schedulings), status: :ok
  end

  def show
    scheduling = set_scheduling #tirar os cancelados? e para o backoffice? ou so fazer logica de nao considerar cancelados na parte do retorno do horario
    render json: response_scheduling(scheduling), status: :ok #ajustar retorno do relacionamento
  end

  def create
    scheduling = Scheduling.new(scheduling_params)
    
    if scheduling.save
      render json: scheduling, status: :created
    else
      render json: { message: 'Falha ao criar agendamento', errors: scheduling.errors }, status: :unprocessable_entity 
    end
  end

  def update
    scheduling = set_scheduling
    
    if scheduling.update_attributes(scheduling_params)
      render json: scheduling, status: :ok
    else
      render json: { message: 'Falha ao atualizar agendamento' }, status: :unprocessable_entity
    end
  end

  def cancel_scheduling
    scheduling = set_scheduling

    scheduling.scheduling_status_id = SchedulingStatus::CANCELED

    if scheduling.save
      render json: scheduling, status: :ok 
    else
      render json: { message: 'Falha ao cancelar agendamento' }, status: :unprocessable_entity
    end
  end

  def destroy
    scheduling = set_scheduling
    scheduling.scheduling_status_id = SchedulingStatus::CANCELED
    render json: { message: 'Falha ao deletar agendamento' }, status: :unprocessable_entity unless scheduling.save
  end

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
      Scheduling.find(params[:id])
    end

    def scheduling_params
      params.require(:scheduling).permit(:customer_id, :service_id, :scheduling_status_id, :start, :finish)
    end

    def response_schedulings(schedulings)
      response = []

      schedulings.each do |scheduling|
        response.push(response_scheduling(scheduling))
      end

      response
    end

    def response_scheduling(scheduling)
      {
        id: scheduling.id,
        customer_id: scheduling.customer_id,
        customer_name: scheduling.customer.name,
        customer_last_name: scheduling.customer.last_name,
        service_id: scheduling.service_id,
        service_name: scheduling.service.name,
        scheduling_scheduling_status_id: scheduling.scheduling_status_id,
        scheduling_scheduling_status_name: scheduling.scheduling_status.name,
        scheduling_start: scheduling.start,
        scheduling_finish: scheduling.finish
      }
    end
end