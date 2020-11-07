require 'cpf_cnpj'

class Customer < ApplicationRecord

  include CustomerQuery

  validates_presence_of :name, :last_name
  # validates_length_of :phone, minimum: 8, maximum: 20, allow_blank: false
  # validate :check_cpf_validity
  # validates_format_of :email, with: URI::MailTo::EMAIL_REGEXP
  # validates_uniqueness_of :phone, :cpf, :email

  # before_validation :phone_with_only_integers, :cpf_with_only_integers

  def check_cpf_validity
    errors.add(:cpf, :invalid) unless CPF.valid?(self.cpf)
  end

  def phone_with_only_integers
    self.phone = self.phone.to_s.gsub(/\D/, '')
  end

  def cpf_with_only_integers
    self.cpf = self.cpf.to_s.gsub(/\D/, '')
  end
end
