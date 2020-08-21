module Api::V1::CustomerManager
  class Shower < ApplicationManager::Shower
    private

    def instance
      Customer.find_by!(id: id)
    end
end