class Api::V1::OpeningHourSerializer < ActiveModel::Serializer
  attributes :id, :opening_time, :closing_time, :weekday, :company
end
