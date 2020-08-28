module Api::V1::EmployeManager
  class Lister < Api::V1::ApplicationManager::Lister

    private

    def filter
      Employe.__search(@filters)
    end
  end
end
