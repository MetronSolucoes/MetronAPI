class Company < ApplicationRecord
  validates_format_of :email, with: URI::MailTo::EMAIL_REGEXP
  validates_length_of :phone, minimum: 8, maximum: 20, allow_blank: false
end
