class Company < ApplicationRecord
  include CompanyQuery

  has_many :opening_hours

  validates_format_of :email, with: URI::MailTo::EMAIL_REGEXP
  validates_length_of :phone, minimum: 8, maximum: 20, allow_blank: false

  def opening_hour(weekday)
    opening_hours.find_by(weekday: weekday)

    "das #{opening_hours.try(:opening_time).try(:stftime, '%H:%M')} até as #{opening_hours.try(:closing_time).try(:strftime, '%H:%M')}"
  end
end
