class Api::V1::EmployesController < Api::V1::ApplicationController
  def index
    employes = Api::V1::EmployeManager::Lister.new(0, 0, true, params).build
    render json: employes, status: :ok
  end

  def show
    employe = Api::V1::EmployeManager::Shower.new(params[:id], true, params).build
    render json: employe, status: :ok
  end
end
