module Api::V1::ServiceManager
  class Lister < Api::V1::ApplicationManager::Lister

    attr_accessor :services_message

    private

    def filter
      services = Service.__search(@filters)

      return services unless @bot_request

      @services_message = "Os serviços disponíveis são: \n\n"

      services.map do |service|
        services_message << "#{service.id} - #{service.name}, duração: #{service.duration} minutos \n"
      end

      mount_bot_response
    end

    def mount_bot_response
      {
        messages: [
          {
            text: services_message
          }
        ]
      }
    end
  end
end
