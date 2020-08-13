class Api::V1::ServicesController < Api::V1::ApplicationController
  before_action :set_service, only: [:show, :update, :destroy]

  def index
    services = Service.ransack(params[:q]).result
    render json: services, each_serializer: Api::V1::ServiceSerializer, status: :ok
  end

  def show
    render json: @service, serializer: Api::V1::ServiceSerializer, status: :ok
  end

  def create
    service = Service.new(service_params)

    if service.save
      render json: service, serializer: Api::V1::ServiceSerializer, status: :created
    else
      render json_validation_error(service, 'Falha ao criar serviço')
    end
  end

  def update
    if @service.update_attributes(service_params)
      render json: service, serializer: Api::V1::ServiceSerializer, status: :ok
    else
      render json_validation_error(@service, 'Falha ao atualizar serviço')
    end
  end

  def destroy
    if @service.destroy
      render json_destroy_success('Serviço excluído com sucesso')
    else
      render json_destroy_error('Falha ao excluir serviço')
    end
  end

  private

  def set_service
    @service = Service.find(params[:id])
  end

  def service_params
    params.require(:service).permit(:name, :description, :duration)
  end
end
