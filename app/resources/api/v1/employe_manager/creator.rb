module Api::V1::EmployeManager
  class Creator < ApplicationManager::Creator
    attr_accessor :params

    def initialize(params)
      @params = params
    end

    private

    def execute_creation
      validate_company!
      employe = Employe.create(params)
      employe
    end

    def validate_company!
      Company.find_by!(id: params[:company_id])
    end
  end
end
