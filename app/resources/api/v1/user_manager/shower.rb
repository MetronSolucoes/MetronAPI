module Api::V1::UserManager
  class Shower < Api::V1::ApplicationManager::Shower
    private

    def instance
      User.find_by!(id: id)
    end
  end
end
