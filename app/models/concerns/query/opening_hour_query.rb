module OpeningHourQuery
  extend ActiveSupport::Concern
  include BaseQuery

  included do
    extend ClassMethods
  end

  module ClassMethods
    def format_params(params)
      return {} unless params

      {
        weekday_eq: params.dig(:weekday),
      }
    end

    def format_order(order = '')
      return order if order.present?

      ['id DESC NULLS LAST']
    end
  end
end
