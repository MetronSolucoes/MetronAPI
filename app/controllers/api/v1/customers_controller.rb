class Api::V1::CustomersController < ApplicationController  
  rescue_from ActiveRecord::RecordNotFound do |e|
    render_json_error :not_found, :customer_not_found
  end

  def index
    customers = Customer.all
    render json: customers, status: :ok
  end

  def show
    customer = set_customer
    render json: customer, status: :ok
  end

  def create
    customer = Customer.new(customer_params)

    if customer.save
      render json: customer, status: :created
    else
      render json: { message: 'Falha ao criar cliente', errors: customer.errors }, status: :unprocessable_entity
    end
  end

  def update
    customer = set_customer

    if customer.update_attributes(customer_params)
      render json:customer, status: :ok
    else
      render json: { message: 'Falha ao atualizar cliente', errors: customer.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    customer = set_customer
    render json: { message: 'Falha ao deletar cliente' }, status: :unprocessable_entity unless customer.destroy
  end

  private
    def set_customer
      Customer.find(params[:id])
    end

    def customer_params
      params.require(:customer).permit(:name, :last_name, :cpf, :phone, :email)
    end
end
