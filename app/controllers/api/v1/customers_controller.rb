class Api::V1::CustomersController < ApplicationController  
  rescue_from ActiveRecord::RecordNotFound do |e|
    render_json_error :not_found, :customer_not_found
  end

  def index
    customers = Customer.all
    render json: customers, status: :created
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
      render json: customer.errors, status: :unprocessable_entity
    end
  end

  def update
    customer = set_customer

    if customer.update(customer_params)
      render json:customer, status: :ok
    else
      render json: customer.errors, status: :unprocessable_entity
    end
  end

  def destroy
    customer = set_customer
    customer.destroy
    render json: '', status: :no_content
  end

  private
    def set_customer
      Customer.find(params[:id])
    end

    def customer_params
      params.require(:customer).permit(:name, :last_name, :cpf, :phone, :email)
    end
end
