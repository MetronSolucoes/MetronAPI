class Api::V1::ServiceSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :duration, :created_at
end
