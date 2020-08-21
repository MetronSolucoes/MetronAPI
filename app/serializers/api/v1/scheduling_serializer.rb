class Api::V1::SchedulingSerializer < ActiveModel::Serializer
  attributes :id, :start, :finish, :created_at

  belongs_to :customer, serializer: Api::V1::CustomerSerializer
  belongs_to :service, serializer: Api::V1::ServiceSerializer
  belongs_to :scheduling_status
end
