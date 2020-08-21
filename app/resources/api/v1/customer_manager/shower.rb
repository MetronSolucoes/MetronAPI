module Api::V1::CustomerManager
  class Shower < Api::V1::ApplicationManager::Shower
    private

    def instance
      Customer.find_by!(id: id)
    end
  end
end