class Api::V1::EmployeServiceSerializer < ActiveModel::Serializer

  belongs_to :service, serializer: Api::V1::ServiceSerializer
end
