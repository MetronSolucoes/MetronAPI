module Api::V1::SchedulingManager
  class Shower < Api::V1::ApplicationManager::Shower
    private

    def instance
      return Scheduling.find_by!(id: id) unless @bot_request

      scheguling = Scheduling.find_by(id: id)

      if scheguling.blank?
        return {
          messages: [
            text: 'Desculpe, mas não conseguimos localizar seu agendamento.'
          ]
        }
      end

      {
        messages: [
          {
            text: 'Detalhes do agendamento'
          },
          {
            text: "Data e Hora: #{scheguling.start.strftime('%d/%m/%Y %H:%M')}"
          },
          {
            text: "Serviço: #{scheguling.service.name}"
          },
          {
            text: "Funcionário: #{scheguling.employe.name} #{scheguling.employe.last_name}"
          },
          {
            text: "Status: #{scheguling.status_label}"
          }
        ]
      }
    end
  end
end
