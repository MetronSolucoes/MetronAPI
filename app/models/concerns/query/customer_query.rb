module CustomerQuery
  extend ActiveSupport::Concern
  include BaseQuery

  included do
    extend ClassMethods
  end

  module ClassMethods
    def format_params(params)
      return {} unless params

      {
        id_eq: params.dig(:id),
        name_cont: params.dig(:name),
        last_name_cont: params.dig(:last_name),
        cpf_eq: params.dig(:duration),
        phone_eq: params.dig(:phone),
        email_eq: params.dig(:email)
      }
    end

    def format_order(order = '')
      return order if order.present?

      ['id DESC NULLS LAST']
    end
  end
end
