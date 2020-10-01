module Api::V1::EmployeManager
  class Updater < Api::V1::ApplicationManager::Updater

    private

    def execute_update
      user = find_user
      user.update!(params.merge(company_id: Company.first.id))
      user
    end

    def find_user
      User.find_by!(id: id)
    end
  end
end
