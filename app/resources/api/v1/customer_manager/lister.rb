module Api::V1::CustomerManager
  class Lister < Api::V1::ApplicationManager::Lister
    private

    def filter
      Customer.__search(@filters)
    end
  end
end