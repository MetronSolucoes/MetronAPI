module Api::V1::ServiceManager
  class Creator < Api::V1::ApplicationManager::Creator
    attr_accessor :params

    private

    def initialize(params)
      @params = params
    end

    def execute_creation
      Service.create!(params)
    end
  end
end
