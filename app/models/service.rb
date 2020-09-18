class Service < ApplicationRecord
  include ServiceQuery

  validates_uniqueness_of :name
  validate :validate_duration



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
