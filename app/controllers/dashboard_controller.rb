class DashboardController < ApplicationController
  before_action :require_login

  def index
    # Date range - default to current year
    @start_date = params[:start_date]&.to_date || Date.new(Date.today.year, 1, 1)
    @end_date = params[:end_date]&.to_date || Date.new(Date.today.year, 12, 31)

    # Country summary
    @country_summary = DayCalculator.country_summary(current_user, @start_date, @end_date)

    # Trip counter
    @total_trips = DayCalculator.total_trips(current_user, @start_date, @end_date)

    # Calendar data
    @calendar_month = params[:month]&.to_i || Date.today.month
    @calendar_year = params[:year]&.to_i || Date.today.year
    @calendar_date = Date.new(@calendar_year, @calendar_month, 1)

    # Schengen status
    @schengen_status = SchengenCalculator.schengen_status(current_user)

    # Generate calendar
    @calendar_data = generate_calendar_data(@calendar_date)
  end

  private

  def generate_calendar_data(month_date)
    start_date = month_date.beginning_of_month
    end_date = month_date.end_of_month

    visits = current_user.visits
                         .where('start_date <= ? AND end_date >= ?', end_date, start_date)
                         .includes(:country)

    calendar_data = {}
    (start_date..end_date).each do |date|
      countries = visits.select do |visit|
        visit.start_date <= date && visit.end_date >= date
      end.map(&:country)

      calendar_data[date.day] = countries
    end

    calendar_data
  end
end
