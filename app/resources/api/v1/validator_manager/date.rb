class Api::V1::ValidatorManager::Date
  attr_accessor :scheduling_date, :company, :day, :month, :year, :date

  def initialize(scheduling_date, company = Company.first)
    @scheduling_date = scheduling_date
    @company = company
  end

  def execute
    return unpresent_date_error if scheduling_date.blank?
    return malformatted_date_error if malformatted_date?

    set_day_month_and_year
    return not_range_date_error unless day_month_and_year_in_range?

    @date = Date.new(year, month, day)
    return company_close_error unless company_open_in_date?
    return past_date_error if date.end_of_day.past?

    success_response
  end

  private

  def unpresent_date_error
    {
      set_attributes: {
        date_valid: false
      },
      messages: [
        {
          text: 'Por favor informe uma data válida!'
        }
      ]
    }
  end

  def malformatted_date_error
    {
      set_attributes: {
        date_valid: false
      },
      messages: [
        {
          text: 'A data informada está mal formatada, por favor tente novamente utilizando o formato do exemplo: 10/11/2021'
        }
      ]
    }
  end

  def not_range_date_error
    {
      set_attributes: {
        date_valid: false
      },
      messages: [
        {
          text: 'A data informada não existe, por favor tente novamente!'
        }
      ]
    }
  end

  def company_close_error
    {
      set_attributes: {
        date_valid: false
      },
      messages: [
        {
          text: 'O estabelecimento não funciona no dia desejado, por favor tente novamente com um dia válido.'
        }
      ]
    }
  end

  def past_date_error
    {
      set_attributes: {
        date_valid: false
      },
      messages: [
        {
          text: 'A data informada esta no passado, por favor tente novamente com uma data no presente ou futuro.'
        }
      ]
    }
  end

  def success_response
    {
      set_attributes: {
        date_valid: true,
        weekday: date.wday
      }
    }
  end

  def malformatted_date?
    splited_date = split_date

    verification_results = splited_date.map do |d|
      d.scan(/\D/).empty?
    end

    verification_results.include?(false)
  end

  def company_open_in_date?
    OpeningHour.find_by(company_id: company.id, weekday: date.wday).present?
  end

  def split_date
    scheduling_date.delete(' ').split('/')
  end

  def set_day_month_and_year
    splited_date = split_date

    @day = splited_date[0].try(:to_i)
    @month = splited_date[1].try(:to_i)
    @year = splited_date[2].try(:to_i)
  end

  def day_month_and_year_in_range?
    return false unless (01..31).include?(day)
    return false unless (01..12).include?(month)
    return false unless (2020..2100).include?(year)

    true
  end
end
