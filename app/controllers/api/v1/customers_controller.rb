class Api::V1::CustomersController < Api::V1::ApplicationController

  def show
    shower = Api::V1::CustomerManager::Shower.new(params[:id])
    render json: shower.build, serializer: Api::V1::CustomerSerializer, status: :ok
  end

  def create
    customer = Customer.find_or_initialize_by(name: params['first name'],
                                              last_name: params['last_name'])

    customer.save(validate: false)

    render json: {
      set_attributes: {
        customer_id: customer.try(:id)
      }
    }
  end

  def update
    updater = Api::V1::CustomerManager::Updater.new(params[:id], params.permit(:name, :last_name, :cpf, :phone, :email))
    render json: updater.update, serializer: Api::V1::CustomerSerializer, status: :ok
  end

  private

  def customer_params
    params.require(:customer).permit(:name, :last_name, :cpf, :phone, :email)
  end
end
