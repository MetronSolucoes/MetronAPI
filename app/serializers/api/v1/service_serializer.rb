class Api::V1::ServiceSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :duration, :price, :created_at
end
