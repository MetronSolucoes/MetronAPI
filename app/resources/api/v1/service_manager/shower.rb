module Api::V1::ServiceManager
  class Shower < Api::V1::ApplicationManager::Shower
    private

    def instance
      return Service.find_by!(id: id) unless bot_request

      service = Service.find_by(id: id)

      if service.blank?
        return {
          valid: false,
          messages: [
            {
              text: 'O serviço escolhido não existe.'
            }
          ]
        }
      end

      return {
        valid: true
      }
    end
  end
end
