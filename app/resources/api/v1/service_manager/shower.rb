module Api::V1::ServiceManager
  class Shower < Api::V1::ApplicationManager::Shower
    private

    def instance
      return Service.find_by!(id: id) unless @bot_request

      employes_ids = Company.first.employes.map(&:id)

      service = Service.find_by(id: id)

      employes = EmployeService.where(service_id: id,
                                      employe_id: employes_ids)

      if service.blank?
        return {
          set_attributes: {
            service_valid: false
          },
          messages: [
            {
              text: 'O serviço escolhido não existe.',
            }
          ]
        }
      end

      if employes.blank?
        return {
          set_attributes: {
            service_valid: false
          },
          messages: [
            {
              text: 'No momento não há nenhum funcionario especilizado no serviço em questão, por favor tente mais tarde ou selecione outro serviço!'
            }
          ]
        }
      end

      return {
        set_attributes: {
          service_valid: true
        }
      }
    end
  end
end
