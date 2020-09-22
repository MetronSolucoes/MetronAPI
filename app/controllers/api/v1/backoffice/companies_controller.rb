class Api::V1::Backoffice::CompaniesController < Api::V1::Backoffice::ApplicationController

  def show
    company = Company.first
    render json: company, serializer: Api::V1::CompanySerializer, status: :ok
  end

  def update
    company = Company.first

    if company.update_attributes(company_params)
      render json: company, serializer: Api::V1::CompanySerializer, status: :ok
    else
      render json_validation_error(company.errors, 'Falha ao atualizar os dados da empresa')
    end
  end

  private

  def company_params
    params.require(:company).permit(:name, :logo, :phone, :email, :opening_hours)
  end
end
