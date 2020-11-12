module Api::V1::EmployeManager
  class Updater < Api::V1::ApplicationManager::Updater

    private

    def execute_update
      employe = find_employe
      validate_company
      puts params
      employe.update!(params)
      employe
    end

    def find_employe
      Employe.find_by!(id: id)
    end

    def validate_company
      return if params[:company_id].blank?
      Company.find_by!(id: params[:company_id])
    end
  end
end
