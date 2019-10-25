class Service < ApplicationRecord
  validates_uniqueness_of :name
end
