class Employe < ApplicationRecord

  include EmployeQuery

  belongs_to :company
  has_many :employe_services
  has_many :schedulings

  validates_presence_of :name, :last_name
  validates_length_of :phone, minimum: 8, maximum: 20, allow_blank: false
  validates_format_of :email, with: URI::MailTo::EMAIL_REGEXP
  validates_uniqueness_of :email

  before_validation :phone_with_only_integers

  def phone_with_only_integers
    self.phone = self.phone.to_s.gsub(/\D/, '')
  end

end
