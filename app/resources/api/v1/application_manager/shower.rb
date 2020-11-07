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

    def initialize(id, bot_request = false, params = nil)
      @id = id
      @bot_request = bot_request
      @params = params
    end
  end
end
