class Api::V1::EmployesController < Api::V1::ApplicationController

  def index
    employes = Api::V1::EmployeManager::Lister.new(0, 0, params).build
    render json: employes, meta: pagination(employes),
      each_serializer: Api::V1::EmployeSerializer, status: :ok
  end

  def show
    employe = Api::V1::EmployeManager::Shower.new(params[:id]).build
    render json: employe, include: include_relations, serializer: Api::V1::EmployeSerializer, status: :ok
  end

  def create
    employe = Api::V1::EmployeManager::Creator.new(employe_params).create

    if employe.errors.blank?
      render json: employe, serializer: Api::V1::EmployeSerializer, status: :created
    else
      render json_validation_error(employe, 'Falha ao criar o funcionário')
    end
  end

  def update
    employe = Api::V1::EmployeManager::Updater.new(params[:id], employe_params).update

    if employe.errors.blank?
      render json: employe, serializer: Api::V1::EmployeSerializer, status: :ok
    else
      render json_validation_error(employe, 'Falha ao atualizar funcionário')
    end
  end

  def destroy
    employe = Api::V1::EmployeManager::Destroyer.new(params[:id])

    if employe.destroy
      render json_success('Funcionário excluído com sucesso')
    else
      render json_error('Falha ao excluir funcionário')
    end
  end

  def link_service
    response = Api::V1::EmployeManager::LinkService.new(params[:employe_id], params[:service_id]).execute

    if response
      render json_success('Serviço vinculado com sucesso ao funcionário')
    else
      render json_error('Falha ao vincular serviço ao funcionário')
    end
  end

  def unlink_service
    response = Api::V1::EmployeManager::UnlinkService.new(params[:employe_id], params[:service_id]).execute

    if response
      render json_success('Serviço desvinculado do usuário com sucesso')
    else
      render json_error('Falha ao desvincular serviço do usuário')
    end
  end

  private

  def include_relations
    [employe_services: [:service]]
  end

  def employe_params
    params.require(:employe).permit(:name, :last_name, :phone, :email, :company_id)
  end
end