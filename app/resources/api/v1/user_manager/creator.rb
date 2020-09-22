module Api::V1::UserManager
  class Creator < Api::V1::ApplicationManager::Creator
    attr_accessor :params

    private

    def initialize(params)
      @params = params
    end

    def execute_creation
      User.create!(params.merge(company_id: Company.first.id))
    end
  end
end
