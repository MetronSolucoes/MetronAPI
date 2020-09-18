module Api::V1::EmployeManager
  class Updater < Api::V1::ApplicationManager::Updater

    private

    def execute_update
      employe = find_employe
      validate_company if params[:company_id].present?
      employe.update(params)
      employe
    end

    def find_employe
      Employe.find_by!(id: id)
    end

    def validate_company
      Company.find_by!(id: params[:company_id])
    end
  end
end
