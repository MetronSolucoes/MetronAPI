module Api::V1::ApplicationManager
  class Updater
    attr_accessor :id, :params

    def update
      ActiveRecord::Base.transaction { execute_update }
    end

    private

    def execute_update
      raise NotImplementedError
    end

    def initialize(id, params = nil)
      @id = id
      @params = params
    end
  end
end
