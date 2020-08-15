module CustomerManager
  class Shower < ApplicationManager::Shower
    private

    def instance
      Customer.find_by!(id: id)
    end
end