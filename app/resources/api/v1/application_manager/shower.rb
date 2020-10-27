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

    def initialize(id, bot_request = false)
      @id = id
      @bot_request = bot_request
    end
  end
end
