class Api::V1::OpeningHoursController < Api::V1::ApplicationController
  def index
    lister = Api::V1::OpeningHourManager::Lister.new(params[:page], params[:per_page],
      weekday: params[:weekday])
    customers = lister.build
    render json: customers, meta: pagination(customers), each_serializer: Api::V1::OpeningHourSerializer, status: :ok
  end

  def show
    shower = Api::V1::OpeningHourManager::Shower.new(params[:id])
    render json: shower.build, serializer: Api::V1::OpeningHourSerializer, status: :ok
  end

  def create
    creator = Api::V1::OpeningHourManager::Creator.new(params[:opening_time], params[:closing_time], params[:weekday])
    render json: creator.create, serializer: Api::V1::OpeningHourSerializer, status: :created
  end

  def update
    updater = Api::V1::OpeningHourManager::Updater.new(params[:id], params.permit(:opening_time, :closing_time, :weekday))
    render json: updater.update, serializer: Api::V1::OpeningHourSerializer, status: :ok
  end

  def destroy
    destroyer = Api::V1::OpeningHourManager::Destroyer.new(params[:id])
    render json: destroyer.destroy, serializer: Api::V1::OpeningHourSerializer
  end
end
