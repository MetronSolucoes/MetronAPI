module Api::V1::ServiceManager
  class Creator < ApplicationManager::Creator
    attr_accessor :params

    private

    def initialize(params)
      @params = params
    end

    def execute_creation
      Service.create(params)
    end
  end
end
