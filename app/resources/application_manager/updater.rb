module ApplicationManager
  class Updater
    attr_accessor :id

    def update
      ActiveRecord::Base.transaction { execute_update }
    end

    private

    def execute_update
      raise NotImplementedError
    end

    def initialize(id)
      @id = id
    end
  end
end