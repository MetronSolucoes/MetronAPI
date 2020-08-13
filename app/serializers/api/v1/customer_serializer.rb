class Api::V1::CustomerSerializer < ActiveModel::Serializer
  attributes :id, :name, :last_name, :cpf, :phone, :email, :created_at
end
