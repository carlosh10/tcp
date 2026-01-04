class Visit < ApplicationRecord
  belongs_to :user
  belongs_to :country

  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :end_date_after_start_date
  validate :no_overlapping_visits

  scope :in_date_range, ->(start_date, end_date) {
    where('start_date <= ? AND end_date >= ?', end_date, start_date)
  }

  scope :for_country, ->(country) { where(country: country) }
  scope :ordered, -> { order(start_date: :desc) }

  def duration_days
    return 0 if start_date.nil? || end_date.nil?
    (end_date - start_date).to_i + 1
  end

  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date < start_date
      errors.add(:end_date, "must be after start date")
    end
  end

  def no_overlapping_visits
    return if user.nil? || start_date.blank? || end_date.blank?

    overlapping = user.visits
                      .where.not(id: id)
                      .where('start_date <= ? AND end_date >= ?', end_date, start_date)

    if overlapping.exists?
      errors.add(:base, "Visit dates overlap with an existing visit")
    end
  end
end
