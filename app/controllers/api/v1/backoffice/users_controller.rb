class Api::V1::Backoffice::UsersController < Api::V1::Backoffice::ApplicationController

  def index
    users = Api::V1::UserManager::Lister.new(0,0, params).build
    render json: users, meta: pagination(users), each_serializer: Api::V1::UserSerializer, status: :ok
  end

  def show
    user = Api::V1::UserManager::Shower.new(params[:id]).build
    render json: user, serializer: Api::V1::UserSerializer, status: :ok
  end

  def create
    user = Api::V1::UserManager::Creator.new(permitted_params).create
    render json: user, serializer: Api::V1::UserSerializer, status: :created
  end

  def update
    user = Api::V1::UserManager::Updater.new(params[:id], permitted_params).update
    render json: user, serializer: Api::V1::UserSerializer, status: :ok
  end

  def destroy
    user = Api::V1::UserManager::Destroyer.new(params[:id])

    if user.destroy
      render json_success('Usuário excluído com sucesso')
    else
      render json_error('Falha ao excluir usuário')
    end
  end

  private

  def permitted_params
    params.fetch(:user).permit(:name, :email, :password)
  end
end
