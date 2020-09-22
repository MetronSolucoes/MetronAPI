class Api::V1::Backoffice::CustomersController < Api::V1::Backoffice::ApplicationController
  before_action :set_customer, only: [:show, :update, :destroy]

  def index
    lister = Api::V1::CustomerManager::Lister.new(params[:page], params[:per_page],
                                                  name: params[:name],
                                                  last_name: params[:last_name],
                                                  cpf: params[:cpf],
                                                  phone: params[:phone],
                                                  email: params[:email])
    customers = lister.build
    render json: customers, meta: pagination(customers), each_serializer: Api::V1::CustomerSerializer, status: :ok
  end

  def show
    shower = Api::V1::CustomerManager::Shower.new(params[:id])
    render json: shower.build, serializer: Api::V1::CustomerSerializer, status: :ok
  end

  def create
    creator = Api::V1::CustomerManager::Creator.new(params[:name], params[:last_name], params[:cpf], params[:phone], params[:email])
    render json: creator.create, serializer: Api::V1::CustomerSerializer, status: :created
  end

  def update
    updater = Api::V1::CustomerManager::Updater.new(params[:id], params.permit(:name, :last_name, :cpf, :phone, :email))
    render json: updater.update, serializer: Api::V1::CustomerSerializer, status: :ok
  end

  def destroy
    destroyer = Api::V1::CustomerManager::Destroyer.new(params[:id])
    render json: destroyer.destroy, serializer: Api::V1::CustomerSerializer
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.require(:customer).permit(:name, :last_name, :cpf, :phone, :email)
  end
end
