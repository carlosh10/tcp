class SchengenCalculator
  SCHENGEN_COUNTRIES = %w[AT BE CH CZ DE DK ES FI FR GR HU IS IT LI LU MT NL NO PL PT SE SI SK].freeze
  MAX_DAYS = 90
  PERIOD_DAYS = 180

  def self.days_in_period(user, reference_date = Date.today)
    start_date = reference_date - (PERIOD_DAYS - 1).days
    end_date = reference_date

    visits = user.visits.joins(:country)
                 .where(countries: { code: SCHENGEN_COUNTRIES })
                 .where('start_date <= ? AND end_date >= ?', end_date, start_date)

    days = visits.sum do |visit|
      range_start = [visit.start_date, start_date].max
      range_end = [visit.end_date, end_date].min
      (range_end - range_start).to_i + 1
    end

    {
      days: days,
      remaining: MAX_DAYS - days,
      start_date: start_date,
      end_date: end_date,
      alert: days >= 80,
      overstay: days > MAX_DAYS
    }
  end

  def self.schengen_status(user)
    result = days_in_period(user)

    status = if result[:overstay]
               :overstay
             elsif result[:alert]
               :warning
             else
               :ok
             end

    result.merge(status: status)
  end

  def self.days_until_reset(user, reference_date = Date.today)
    # Find the earliest visit in the rolling 180-day window
    start_date = reference_date - (PERIOD_DAYS - 1).days

    earliest_visit = user.visits.joins(:country)
                         .where(countries: { code: SCHENGEN_COUNTRIES })
                         .where('end_date >= ?', start_date)
                         .order(:start_date)
                         .first

    return nil unless earliest_visit

    # Days until the earliest visit exits the rolling window
    (earliest_visit.start_date + PERIOD_DAYS.days - reference_date).to_i
  end
end
