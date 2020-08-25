module Api::V1::ServiceManager
  class Lister < Api::V1::ApplicationManager::Lister

    private

    def filter
      Service.__search(@filters)
    end
  end
end
