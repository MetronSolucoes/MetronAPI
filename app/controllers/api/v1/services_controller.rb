class Api::V1::ServicesController < Api::V1::ApplicationController

  def index
    services = Api::V1::ServiceManager::Lister.new(0, 0, true, params).build
    render json: services
  end

  def show
    service = Api::V1::ServiceManager::Shower.new(params[:id], true).build
    render json: service, status: :ok
  end

  private

  def service_params
    params.require(:service).permit(:name, :description, :duration)
  end
end
