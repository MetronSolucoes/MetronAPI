class Api::V1::CompaniesController < ApplicationController

  def show
    company = Company.first
    render json: company, status: :ok
  end

  def update
    company = Company.first

    if company.update_attributes(company_params)
      render json:company, status: :ok
    else
      render json: { message: 'Falha ao atualizar dados da empresa', errors: company.errors }, status: :unprocessable_entity
    end
  end

  private

    def company_params
      params.require(:company).permit(:name, :logo, :phone, :email, :opening_hours)
    end
end