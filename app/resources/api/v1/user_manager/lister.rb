module Api::V1::UserManager
  class Lister < Api::V1::ApplicationManager::Lister

    private

    def filter
      User.__search(@filters)
    end
  end
end
