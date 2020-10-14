module Api::V1::SchedulingManager
  class Destroyer < Api::V1::ApplicationManager::Destroyer

    private

    def execute_destruction
      scheduling = find_scheduling
      scheduling.update!(scheduling_status_id: SchedulingStatus::CANCELED)
      { success: true, message: 'Agendamento cancelado com sucesso!' }
    end

    def find_scheduling
      Scheduling.find_by!(id: id)
    end
  end
end
