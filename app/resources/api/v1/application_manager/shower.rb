module Api::V1::ApplicationManager
  class Shower
    attr_accessor :id

    def build
      instance
    end

    private

    def instance
      raise NotImplementedError
    end

    def initialize(id, bot_request = false, service_id = nil)
      @id = id
      @bot_request = bot_request
      @service_id = service_id
    end
  end
end
