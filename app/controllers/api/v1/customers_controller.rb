class Api::V1::CustomersController < Api::V1::ApplicationController

  def show
    shower = Api::V1::CustomerManager::Shower.new(params[:id])
    render json: shower.build, serializer: Api::V1::CustomerSerializer, status: :ok
  end

  #  def create
  #    creator = Api::V1::CustomerManager::Creator.new(params[:name], params[:last_name],
  #                                                    params[:cpf], params[:phone],
  #                                                    params[:email])
  #    render json: creator.create, serializer: Api::V1::CustomerSerializer, status: :created
  #  end

  def update
    updater = Api::V1::CustomerManager::Updater.new(params[:id], params.permit(:name, :last_name, :cpf, :phone, :email))
    render json: updater.update, serializer: Api::V1::CustomerSerializer, status: :ok
  end

  private

  def customer_params
    params.require(:customer).permit(:name, :last_name, :cpf, :phone, :email)
  end
end
