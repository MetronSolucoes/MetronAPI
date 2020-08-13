class Service < ApplicationRecord
  include ServiceQuery

  validates_uniqueness_of :name
end
