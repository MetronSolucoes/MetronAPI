class Api::V1::ServicesController < Api::V1::ApplicationController
  before_action :set_service, only: [:destroy]

  def index
    services = Api::V1::ServiceManager::Lister.new(0, 0, params).build
    render json: services, meta: pagination(services), each_serializer: Api::V1::ServiceSerializer, status: :ok
  end

  def show
    service = Api::V1::ServiceManager::Shower.new(params[:id]).build
    render json: service, serializer: Api::V1::ServiceSerializer, status: :ok
  end

  private

  def set_service
    @service = Service.find(params[:id])
  end

  def service_params
    params.require(:service).permit(:name, :description, :duration)
  end
end
