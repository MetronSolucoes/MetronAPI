module Api::V1::SchedulingManager
  class Lister < Api::V1::ApplicationManager::Lister
    private

    def filter
      Scheduling.__search(@filters)
    end
  end
end
