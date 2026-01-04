class CountryRule < ApplicationRecord
  belongs_to :user
  belongs_to :country

  validates :user_id, uniqueness: { scope: :country_id }
  validates :max_days, numericality: { greater_than: 0, allow_nil: true }
  validates :period_days, numericality: { greater_than: 0, allow_nil: true }
  validates :alert_threshold, numericality: { greater_than: 0, allow_nil: true }
end
