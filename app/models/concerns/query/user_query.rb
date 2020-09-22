module UserQuery
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
        email_cont: params.dig(:email),
        company_id_eq: params.dig(:company_id),
      }
    end

    def format_order(order = '')
      return order if order.present?

      ['id DESC NULLS LAST']
    end
  end
end
