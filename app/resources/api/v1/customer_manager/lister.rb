module Api::V1::CustomerManager
  class Lister < Api::V1::ApplicationManager::Lister
    private

    def filter
      query = {
        name_eq: @filters[:name],
        last_name_eq: @filters[:last_name],
        cpf_eq: @filters[:cpf],
        phone_eq: @filters[:phone],
        email_eq: @filters[:email],
      }

      search = Customer.ransack(query)
      search.sorts = ['id desc']
      search.result 
    end
  end
end