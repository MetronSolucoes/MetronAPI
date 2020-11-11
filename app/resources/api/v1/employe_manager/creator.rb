module Api::V1::EmployeManager
  class Creator < Api::V1::ApplicationManager::Creator
    attr_accessor :params

    private

    def initialize(params)
      @params = params
    end

    def execute_creation
      @params = @params.merge({ company_id: Company.first.id })
      validate_company!
      Employe.create!(params)
    end

    def validate_company!
      Company.find_by!(id: params[:company_id])
    end
  end
end
