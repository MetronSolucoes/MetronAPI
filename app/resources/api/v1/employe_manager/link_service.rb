module Api::V1::EmployeManager
  class LinkService

    attr_accessor :employe, :service

    def initialize(employe_id, service_id)
      @employe = find_employe(employe_id)
      @service = find_service(service_id)
    end

    def execute
      employe.employe_services.find_or_create_by(service_id: service.id)
    end

    private

    def find_employe(employe_id)
      Employe.find_by!(id: employe_id)
    end

    def find_service(service_id)
      Service.find_by!(id: service_id)
    end
  end
end
