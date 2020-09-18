module Api::V1::EmployeManager
  class Destroyer < Api::V1::ApplicationManager::Destroyer

    private

    def execute_destruction
      employe = find_employe
      employe.destroy
    end

    def find_employe
      Employe.find_by!(id: id)
    end
  end
end
