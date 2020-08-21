module Api::V1::CustomerManager
  class Lister < ApplicationManager::Lister
    private

    def filter
      query = {
        name_eq: @filters[:name]
      } #aqui viria todos os filtros que desejarmos

      search = Customer.ransack(query)
      search.sorts = ['id desc']
      search.result 
    end
end