class OpeningHour < ApplicationRecord
  # de domingo a sabado
  SUNDAY = 0
  MONDAY = 1
  TUESDAY = 2
  WEDNESDEY = 3
  THURSDAY = 4
  FRIDAY = 5
  SATURDAY = 6

  belongs_to :company
  validates_presence_of :opening_time, :closing_time, :weekday, :company
end