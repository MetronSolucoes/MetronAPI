module CustomerManager
  class Destroyer < ApplicationManager::Destroyer
    private

    def execute_destruction
      Customer.find_by!(id: id).delete
    end
end