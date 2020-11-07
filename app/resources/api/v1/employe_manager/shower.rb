module Api::V1::EmployeManager
  class Shower < Api::V1::ApplicationManager::Shower
    private

    def instance
      return Employe.find_by!(id: id) unless @bot_request

      employe = Employe.find_by(id: id)

      employe_service = EmployeService.find_by(employe_id: employe.id, service_id: @service_id)

      if employe.blank? || employe_service.blank?
        return {
          set_attributes: {
            employe_valid: false
          },
          messages: [
            {
              text: 'O funcionário escolhido não existe.',
            }
          ]
        }
      end

      {
        set_attributes: {
          employe_valid: true
        }
      }
    end
  end
end
