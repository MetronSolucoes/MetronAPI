module Api::V1::EmployeManager
  class Shower < Api::V1::ApplicationManager::Shower
    private

    def instance
      Employe.find_by!(id: id)
    end
  end
end
