class Api::V1::CustomersController < Api::V1::ApplicationController
  before_action :set_customer, only: [:show, :update, :destroy]

  def show
    shower = Api::V1::CustomerManager::Shower.new(params[:id])
    render json: shower.build, serializer: Api::V1::CustomerSerializer, status: :ok
  end

  def update
    updater = Api::V1::CustomerManager::Updater.new(params[:id], params.permit(:name, :last_name, :cpf, :phone, :email))
    render json: updater.update, serializer: Api::V1::CustomerSerializer, status: :ok
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.require(:customer).permit(:name, :last_name, :cpf, :phone, :email)
  end
end
