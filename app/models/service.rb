class Service < ApplicationRecord
  include ServiceQuery
  include ActionView::Helpers::NumberHelper

  validates_uniqueness_of :name
  validate :validate_duration

  def price_currency
    return 'R$ 0,00' if price.blank?

    number_to_currency(price, :unit => "R$ ", :separator => ",", :delimiter => ".")
  end

  private

  def validate_duration
    if duration < 30
      raise CustomException.new('A duração miníma do serviço deverá ser de 30 minutos')
    end

    return if duration_isdivisible_per_fifteen?

    raise CustomException, 'Duração inválida'
  end

  def duration_isdivisible_per_fifteen?
    (duration % 15).zero?
  end
end
