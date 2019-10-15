require 'cpf_cnpj'

class Customer < ApplicationRecord
  validates_length_of :phone, maximum: 20
  validates :cpf_valid?, acceptance: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates_uniqueness_of :phone

  def cpf_valid?
    CPF.valid?(self.cpf)
  end
end
