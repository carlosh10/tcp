class User < ApplicationRecord
  has_secure_password

  has_many :visits, dependent: :destroy
  has_many :country_rules, dependent: :destroy
  has_many :countries, through: :visits

  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :timezone, presence: true

  before_validation :normalize_email

  private

  def normalize_email
    self.email = email.downcase.strip if email.present?
  end
end
