module SchedulingQuery
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
        customer_id_eq: params.dig(:customer_id),
        customer_name_cont: params.dig(:customer_name),
        service_id_eq: params.dig(:service_id),
        service_name_cont: params.dig(:service_name),
        scheduling_status_id_eq: params.dig(:status_id),
        created_at_gt: start_date(params.dig(:created_at)),
        created_at_lt: end_date(params.dig(:created_at))
      }
    end

    def format_order(order = '')
      return order if order.present?

      ['id DESC NULLS LAST']
    end
  end
end
