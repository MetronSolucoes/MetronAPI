class Api::V1::ServicesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound do |e|
    render_json_error :not_found, :service_not_found
  end

  def index
    services = Service.all
    render json: services, status: :ok
  end

  def show
    service = set_service
    render json: service, status: :ok
  end

  def create
    service = Service.new(service_params)
    
    if service.save
      render json: service, status: :created
    else
      render json: { message: 'Falha ao criar serviço', errors: service.errors }, status: :unprocessable_entity 
    end
  end

  def update
    service = set_service
    
    if service.update_attributes(service_params)
      render json: service, status: :ok
    else
      render json: { message: 'Falha ao atualizar serviço' }, status: :unprocessable_entity
    end
  end

  def destroy
    service = set_service
    service.destroy
  end

  private
    def set_service
      Service.find(params[:id])
    end

    def service_params
      params.require(:service).permit(:name, :description, :duration)
    end
  end