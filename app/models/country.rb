class Country < ApplicationRecord
  has_many :visits, dependent: :destroy
  has_many :country_rules, dependent: :destroy

  validates :code, presence: true, uniqueness: true, length: { is: 2 }
  validates :name, presence: true

  def self.schengen_countries
    %w[AT BE CH CZ DE DK ES FI FR GR HU IS IT LI LU MT NL NO PL PT SE SI SK]
  end

  def schengen?
    self.class.schengen_countries.include?(code)
  end
end
