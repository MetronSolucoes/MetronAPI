class Api::V1::EmployesController < Api::V1::ApplicationController
  def index
    employes = Api::V1::EmployeManager::Lister.new(0, 0, true, params).build
    render json: employes, status: :ok
  end
end
