# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "Seeding countries..."

countries_data = [
  # Schengen Countries
  { code: 'AT', name: 'Austria', flag_emoji: '🇦🇹', visa_limit_days: 90, visa_period_days: 180 },
  { code: 'BE', name: 'Belgium', flag_emoji: '🇧🇪', visa_limit_days: 90, visa_period_days: 180 },
  { code: 'CH', name: 'Switzerland', flag_emoji: '🇨🇭', visa_limit_days: 90, visa_period_days: 180 },
  { code: 'CZ', name: 'Czech Republic', flag_emoji: '🇨🇿', visa_limit_days: 90, visa_period_days: 180 },
  { code: 'DE', name: 'Germany', flag_emoji: '🇩🇪', visa_limit_days: 90, visa_period_days: 180 },
  { code: 'DK', name: 'Denmark', flag_emoji: '🇩🇰', visa_limit_days: 90, visa_period_days: 180 },
  { code: 'ES', name: 'Spain', flag_emoji: '🇪🇸', visa_limit_days: 90, visa_period_days: 180 },
  { code: 'FI', name: 'Finland', flag_emoji: '🇫🇮', visa_limit_days: 90, visa_period_days: 180 },
  { code: 'FR', name: 'France', flag_emoji: '🇫🇷', visa_limit_days: 90, visa_period_days: 180 },
  { code: 'GR', name: 'Greece', flag_emoji: '🇬🇷', visa_limit_days: 90, visa_period_days: 180 },
  { code: 'HU', name: 'Hungary', flag_emoji: '🇭🇺', visa_limit_days: 90, visa_period_days: 180 },
  { code: 'IS', name: 'Iceland', flag_emoji: '🇮🇸', visa_limit_days: 90, visa_period_days: 180 },
  { code: 'IT', name: 'Italy', flag_emoji: '🇮🇹', visa_limit_days: 90, visa_period_days: 180 },
  { code: 'LI', name: 'Liechtenstein', flag_emoji: '🇱🇮', visa_limit_days: 90, visa_period_days: 180 },
  { code: 'LU', name: 'Luxembourg', flag_emoji: '🇱🇺', visa_limit_days: 90, visa_period_days: 180 },
  { code: 'MT', name: 'Malta', flag_emoji: '🇲🇹', visa_limit_days: 90, visa_period_days: 180 },
  { code: 'NL', name: 'Netherlands', flag_emoji: '🇳🇱', visa_limit_days: 90, visa_period_days: 180 },
  { code: 'NO', name: 'Norway', flag_emoji: '🇳🇴', visa_limit_days: 90, visa_period_days: 180 },
  { code: 'PL', name: 'Poland', flag_emoji: '🇵🇱', visa_limit_days: 90, visa_period_days: 180 },
  { code: 'PT', name: 'Portugal', flag_emoji: '🇵🇹', visa_limit_days: 90, visa_period_days: 180 },
  { code: 'SE', name: 'Sweden', flag_emoji: '🇸🇪', visa_limit_days: 90, visa_period_days: 180 },
  { code: 'SI', name: 'Slovenia', flag_emoji: '🇸🇮', visa_limit_days: 90, visa_period_days: 180 },
  { code: 'SK', name: 'Slovakia', flag_emoji: '🇸🇰', visa_limit_days: 90, visa_period_days: 180 },

  # Americas
  { code: 'US', name: 'United States', flag_emoji: '🇺🇸', visa_limit_days: 90, visa_period_days: 180 },
  { code: 'CA', name: 'Canada', flag_emoji: '🇨🇦', visa_limit_days: 180, visa_period_days: 365 },
  { code: 'MX', name: 'Mexico', flag_emoji: '🇲🇽', visa_limit_days: 180, visa_period_days: 365 },
  { code: 'BR', name: 'Brazil', flag_emoji: '🇧🇷', visa_limit_days: 90, visa_period_days: 180 },
  { code: 'AR', name: 'Argentina', flag_emoji: '🇦🇷', visa_limit_days: 90, visa_period_days: 180 },
  { code: 'CL', name: 'Chile', flag_emoji: '🇨🇱', visa_limit_days: 90, visa_period_days: 180 },
  { code: 'UY', name: 'Uruguay', flag_emoji: '🇺🇾', visa_limit_days: 90, visa_period_days: 180 },

  # Asia-Pacific
  { code: 'JP', name: 'Japan', flag_emoji: '🇯🇵', visa_limit_days: 90, visa_period_days: 180 },
  { code: 'KR', name: 'South Korea', flag_emoji: '🇰🇷', visa_limit_days: 90, visa_period_days: 180 },
  { code: 'CN', name: 'China', flag_emoji: '🇨🇳', visa_limit_days: 30, visa_period_days: 90 },
  { code: 'TH', name: 'Thailand', flag_emoji: '🇹🇭', visa_limit_days: 30, visa_period_days: 90 },
  { code: 'SG', name: 'Singapore', flag_emoji: '🇸🇬', visa_limit_days: 90, visa_period_days: 180 },
  { code: 'AU', name: 'Australia', flag_emoji: '🇦🇺', visa_limit_days: 90, visa_period_days: 180 },
  { code: 'NZ', name: 'New Zealand', flag_emoji: '🇳🇿', visa_limit_days: 90, visa_period_days: 180 },

  # Middle East & Africa
  { code: 'AE', name: 'United Arab Emirates', flag_emoji: '🇦🇪', visa_limit_days: 90, visa_period_days: 180 },
  { code: 'IL', name: 'Israel', flag_emoji: '🇮🇱', visa_limit_days: 90, visa_period_days: 180 },
  { code: 'ZA', name: 'South Africa', flag_emoji: '🇿🇦', visa_limit_days: 90, visa_period_days: 180 },
  { code: 'MA', name: 'Morocco', flag_emoji: '🇲🇦', visa_limit_days: 90, visa_period_days: 180 },

  # UK and Others
  { code: 'GB', name: 'United Kingdom', flag_emoji: '🇬🇧', visa_limit_days: 180, visa_period_days: 365 },
  { code: 'IE', name: 'Ireland', flag_emoji: '🇮🇪', visa_limit_days: 90, visa_period_days: 180 },
  { code: 'TR', name: 'Turkey', flag_emoji: '🇹🇷', visa_limit_days: 90, visa_period_days: 180 },
  { code: 'RU', name: 'Russia', flag_emoji: '🇷🇺', visa_limit_days: 90, visa_period_days: 180 },
  { code: 'IN', name: 'India', flag_emoji: '🇮🇳', visa_limit_days: 90, visa_period_days: 180 },
]

countries_data.each do |country_data|
  Country.find_or_create_by!(code: country_data[:code]) do |country|
    country.name = country_data[:name]
    country.flag_emoji = country_data[:flag_emoji]
    country.visa_limit_days = country_data[:visa_limit_days]
    country.visa_period_days = country_data[:visa_period_days]
    country.tax_residency_days = 183
  end
end

puts "Created #{Country.count} countries"
puts "Seeding completed!"
