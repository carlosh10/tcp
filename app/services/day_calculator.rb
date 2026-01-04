class DayCalculator
  def self.days_in_country(user, country, start_date, end_date)
    visits = user.visits.where(country: country)
                 .where('start_date <= ? AND end_date >= ?', end_date, start_date)

    total_days = 0
    visits.each do |visit|
      range_start = [visit.start_date, start_date].max
      range_end = [visit.end_date, end_date].min
      total_days += (range_end - range_start).to_i + 1
    end
    total_days
  end

  def self.country_summary(user, start_date, end_date)
    summary = {}

    user.visits.in_date_range(start_date, end_date).includes(:country).each do |visit|
      country = visit.country
      summary[country] ||= 0

      range_start = [visit.start_date, start_date].max
      range_end = [visit.end_date, end_date].min
      days = (range_end - range_start).to_i + 1

      summary[country] += days
    end

    summary.sort_by { |_, days| -days }.to_h
  end

  def self.total_trips(user, start_date, end_date)
    visits = user.visits.in_date_range(start_date, end_date).order(:start_date)

    trips = 0
    last_end_date = nil

    visits.each do |visit|
      if last_end_date.nil? || visit.start_date > last_end_date + 1.day
        trips += 1
      end
      last_end_date = [last_end_date || visit.end_date, visit.end_date].max
    end

    trips
  end
end
