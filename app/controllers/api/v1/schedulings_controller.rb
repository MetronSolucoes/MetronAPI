class Api::V1::SchedulingsController < Api::V1::ApplicationController

  def index
    schedulings = Api::V1::SchedulingManager::Lister.new(0, 0, params).build
    render json: schedulings, meta: pagination(schedulings), each_serializer: Api::V1::SchedulingSerializer, status: :ok
  end

  #  def index_without_canceleds
  #   schedulings = Scheduling.not_canceled.__search(params)
  #  render json: schedulings, meta: pagination(schedulings), each_serializer: Api::V1::SchedulingSerializer, status: :ok
  #end

  def show
    scheduling = Api::V1::SchedulingManager::Shower.new(params[:id]).build
    render json: scheduling, serializer: Api::V1::SchedulingSerializer, status: :ok
  end

  def create
    scheduling = Api::V1::SchedulingManager::Creator.new(scheduling_params).create
    render json: scheduling, status: :created
  end

  def destroy
    scheduling = Api::V1::SchedulingManager::Destroyer.new(params[:id])
    render json: scheduling.destroy, status: :ok
  end

  private

  def scheduling_params
    params.require(:scheduling).permit(:customer_id, :service_id, :employe_id,
                                       :scheduling_status_id, :date, :start_time)
  end
end
