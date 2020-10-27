module Api::V1::EmployeManager
  class Shower < Api::V1::ApplicationManager::Shower
    private

    def instance
      return Employe.find_by!(id: id) unless @bot_request

      employe = Employe.find_by(id: id)

      if employe.blank?
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

      return {
        set_attributes: {
          employe_valid: true
        }
      }
    end
  end
end
