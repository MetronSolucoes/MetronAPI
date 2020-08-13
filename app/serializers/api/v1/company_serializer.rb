class Api::V1::CompanySerializer < ActiveModel::Serializer
  attributes :id, :name, :phone, :opening_hours, :email, :created_at
end
