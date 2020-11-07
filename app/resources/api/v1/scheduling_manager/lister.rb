module Api::V1::SchedulingManager
  class Lister < Api::V1::ApplicationManager::Lister
    private

    def filter
      schedulings = Scheduling.__search(@filters)
      return schedulings unless @bot_request

      schedulings_message = "Aqui está seu histórico de agendamentos: \n\n"

      schedulings.map do |sched|
        schedulings_message << "#{sched.id} - #{sched.service.name}, #{sched.start.strftime('dia %d/%m/%Y as %H:%M')} \n"
      end

      {
        messages: [
          {
            text: schedulings_message
          }
        ]
      }
    end
  end
end
