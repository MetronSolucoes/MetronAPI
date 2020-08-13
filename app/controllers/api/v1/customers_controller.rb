class Api::V1::CustomersController < Api::V1::ApplicationController
  before_action :set_customer, only: [:show, :update, :destroy]

  def index
    customers = Customer.ransack(params[:q]).result
    render json: customers, each_serializer: Api::V1::CustomerSerializer, status: :ok
  end

  def show
    render json: customer, serializer: Api::V1::CustomerSerializer, status: :ok
  end

  def create
    customer = Customer.new(customer_params)

    if customer.save
      render json: customer, serializer: Api::V1::CustomerSerializer, status: :created
    else
      render json_validation_error(customer, 'Falha ao criar cliente')
    end
  end

  def update
    if @customer.update_attributes(customer_params)
      render json: @customer, serializer: Api::V1::CustomerSerializer, status: :ok
    else
      render json_validation_error(@customer, 'Falha ao atualizar cliente')
    end
  end

  def destroy
    if @customer.destroy
      render json_destroy_success('Cliente excluído com sucesso')
    else
      render json_destroy_error('Falha ao excluir cliente')
    end
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.require(:customer).permit(:name, :last_name, :cpf, :phone, :email)
  end
end
