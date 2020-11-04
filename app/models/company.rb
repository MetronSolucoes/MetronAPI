class Company < ApplicationRecord
  include CompanyQuery

  has_many :opening_hours

  validates_format_of :email, with: URI::MailTo::EMAIL_REGEXP
  validates_length_of :phone, minimum: 8, maximum: 20, allow_blank: false

  def opening_hour(weekday)
    oh = opening_hours.find_by(weekday: weekday.to_i)

    "das #{oh.try(:opening_time).try(:strftime, '%H:%M')} até as #{oh.try(:closing_time).try(:strftime, '%H:%M')}"
  end
end
