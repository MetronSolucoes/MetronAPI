class Api::V1::CompanySerializer < ActiveModel::Serializer
  attributes :id, :name, :phone, :email, :created_at
end
