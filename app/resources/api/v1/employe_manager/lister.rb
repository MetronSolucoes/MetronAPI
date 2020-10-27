module Api::V1::EmployeManager
  class Lister < Api::V1::ApplicationManager::Lister
    attr_accessor :employes_message

    private

    def filter
      employes = Employe.__search(@filters)

      return employes unless @bot_request

      @employes_message = "Os funcionarios disponíveis para este serviço são: \n\n"

      employes.map do |employe|
        employes_message << "#{employe.id} - #{employe.full_name} \n"
      end

      mount_bot_response
    end

    def mount_bot_response
      {
        messages: [
          {
            text: employes_message
          }
        ]
      }
    end
  end
end
