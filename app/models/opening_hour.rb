class OpeningHour < ApplicationRecord
  include OpeningHourQuery

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

  def oppening_range
    oppening_hour = opening_time.hour
    oppening_minutes opening_time.min

    close_hour = closing_time.hour
    close_minutes = closing_time.min

    oppening_float = "#{oppening_hour}.#{oppening_minutes}".to_f
    close_float = "#{close_hour}.#{close_minutes}".to_f

    oppening_float..close_float
  end
end
