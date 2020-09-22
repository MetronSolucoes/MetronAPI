module Api::V1::UserManager
  class Destroyer < Api::V1::ApplicationManager::Destroyer

    private

    def execute_destruction
      user = find_user
      user.destroy
    end

    def find_user
      User.find_by!(id: id)
    end
  end
end
