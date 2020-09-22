class Api::V1::Backoffice::ServicesController < Api::V1::Backoffice::ApplicationController
  before_action :set_service, only: [:destroy]

  def index
    services = Api::V1::ServiceManager::Lister.new(0, 0, params).build
    render json: services, meta: pagination(services), each_serializer: Api::V1::ServiceSerializer, status: :ok
  end

  def show
    service = Api::V1::ServiceManager::Shower.new(params[:id]).build
    render json: service, serializer: Api::V1::ServiceSerializer, status: :ok
  end

  def create
    service = Api::V1::ServiceManager::Creator.new(service_params).create
    render json: service, serializer: Api::V1::ServiceSerializer, status: :created
  end

  def update
    service = Api::V1::ServiceManager::Updater.new(params[:id], service_params).update
    render json: service, serializer: Api::V1::ServiceSerializer, status: :ok
  end

  def destroy
    service = Api::V1::ServiceManager::Destroyer.new(params[:id])

    if service.destroy
      render json_destroy_success('Serviço excluído com sucesso')
    else
      render json_error('Falha ao excluir serviço')
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
