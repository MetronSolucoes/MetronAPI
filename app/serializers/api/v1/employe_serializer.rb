class Api::V1::EmployeSerializer < ActiveModel::Serializer
  attributes :id, :name, :last_name, :phone, :email, :created_at

  belongs_to :company, serializer: Api::V1::CompanySerializer
  has_many :employe_services, serializer: Api::V1::EmployeServiceSerializer
end
