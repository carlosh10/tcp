# Immigration Day Tracker - Application Plan

## Overview
A mobile/web application to track the number of days spent in different countries for immigration and tax residency purposes.

## Core Features (Based on Screenshot)

### 1. Country Days Summary
- Display list of countries with total days spent
- Show country flags alongside country names
- Calculate and display day counts for selected date range
- Sort countries by days spent (descending)

### 2. Date Range Selection
- Allow users to select custom date ranges
- Default to current year (e.g., 1 Jan 2025 - 1 Jan 2026)
- Update all calculations when range changes
- Quick presets: Current Year, Last 180 Days, Last 90 Days, Custom

### 3. Calendar Visualization
- Monthly calendar view
- Display country flags on dates when user was in that country
- Support for multiple countries on same day (overlapping visits)
- Navigate between months
- Color coding or visual indicators for different countries

### 4. Trip/Stop Counter
- Track number of separate trips/entries
- Display "X stops" indicator at the top
- Calculate based on country entry/exit dates

### 5. Entry Management
- Add new country visit with start and end dates
- Edit existing entries
- Delete entries
- Support for partial days
- Validation to prevent overlapping entries (optional)

### 6. Settings
- User preferences
- Default country (home country)
- Date format preferences
- Currency settings (for expense tracking - future)
- Notification preferences for visa limits

### 7. Immigration Rules & Alerts
- **Schengen Rule**: Warn when approaching 90 days in 180-day period
- **Tax Residency**: Alert at 183 days in a country
- **Custom Rules**: Allow users to set custom day limits per country
- Visual warnings on dashboard when approaching limits

## Technology Stack Options

### Option 1: Rails API + React Native
**Backend:**
- Ruby on Rails 7.x (API mode)
- PostgreSQL database
- RESTful API design

**Frontend:**
- React Native (iOS & Android)
- Expo for faster development
- React Navigation
- Date pickers and calendar libraries

**Pros:**
- Native mobile experience
- Offline support possible
- Single codebase for iOS/Android
- You already know Rails

**Cons:**
- More complex setup
- Requires mobile dev knowledge

### Option 2: Rails Full Stack + Responsive Web
**Backend:**
- Ruby on Rails 7.x (Full stack)
- PostgreSQL database
- Hotwire/Turbo for interactivity

**Frontend:**
- Rails Views with Tailwind CSS
- Stimulus JS for interactions
- Progressive Web App (PWA) capabilities
- Mobile-first responsive design

**Pros:**
- Faster initial development
- Single codebase
- Works on all devices via browser
- Can be installed as PWA
- Simpler deployment

**Cons:**
- Not truly native
- Limited offline capabilities

### Option 3: Rails + Flutter
**Backend:**
- Ruby on Rails 7.x (API mode)
- PostgreSQL database

**Frontend:**
- Flutter for mobile apps
- Single codebase for iOS/Android/Web

**Pros:**
- Beautiful native UI
- Best performance
- Single codebase for mobile and web

**Cons:**
- Need to learn Dart
- Larger learning curve

## Recommended Approach: Rails Full Stack + PWA

Given your Rails background and the need for rapid development, I recommend:
- **Rails 7.x** with Hotwire/Turbo
- **Tailwind CSS** for styling
- **Stimulus JS** for interactivity
- **PostgreSQL** for database
- **PWA** configuration for mobile-like experience

## Database Schema

### Tables

#### 1. Users
```ruby
create_table :users do |t|
  t.string :email, null: false
  t.string :password_digest
  t.string :first_name
  t.string :last_name
  t.string :home_country_code # ISO 3166-1 alpha-2
  t.string :timezone, default: 'UTC'
  t.timestamps
end
```

#### 2. Countries
```ruby
create_table :countries do |t|
  t.string :code, null: false # ISO 3166-1 alpha-2 (CH, BR, UY)
  t.string :name, null: false # Switzerland, Brazil, Uruguay
  t.string :flag_emoji # 🇨🇭, 🇧🇷, 🇺🇾
  t.integer :visa_limit_days # For alerts (e.g., 90 for Schengen)
  t.integer :visa_period_days # Period for visa calc (e.g., 180)
  t.integer :tax_residency_days, default: 183
  t.timestamps
end
```

#### 3. Visits
```ruby
create_table :visits do |t|
  t.references :user, null: false, foreign_key: true
  t.references :country, null: false, foreign_key: true
  t.date :start_date, null: false
  t.date :end_date, null: false
  t.text :notes
  t.string :purpose # tourism, work, transit, etc.
  t.timestamps

  # Validations:
  # - end_date >= start_date
  # - No overlapping visits for same user
end

add_index :visits, [:user_id, :start_date, :end_date]
```

#### 4. Country Rules (Custom per user)
```ruby
create_table :country_rules do |t|
  t.references :user, null: false, foreign_key: true
  t.references :country, null: false, foreign_key: true
  t.integer :max_days # Custom limit
  t.integer :period_days # In how many days (e.g., 90 in 180)
  t.boolean :alert_enabled, default: true
  t.integer :alert_threshold # Days before limit to alert
  t.timestamps
end
```

## Key Features Implementation

### 1. Day Calculation Algorithm
```ruby
# Calculate days in country within date range
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
end
```

### 2. Schengen 90/180 Calculator
```ruby
class SchengenCalculator
  SCHENGEN_COUNTRIES = ['AT', 'BE', 'CH', 'CZ', 'DE', 'DK', 'ES', 'FI', 'FR',
                        'GR', 'HU', 'IS', 'IT', 'LI', 'LU', 'MT', 'NL', 'NO',
                        'PL', 'PT', 'SE', 'SI', 'SK']

  def self.days_in_period(user, reference_date = Date.today)
    start_date = reference_date - 179.days
    end_date = reference_date

    visits = user.visits.joins(:country)
                  .where(countries: { code: SCHENGEN_COUNTRIES })
                  .where('start_date <= ? AND end_date >= ?', end_date, start_date)

    # Calculate total days
    days = visits.sum do |visit|
      range_start = [visit.start_date, start_date].max
      range_end = [visit.end_date, end_date].min
      (range_end - range_start).to_i + 1
    end

    {
      days: days,
      remaining: 90 - days,
      start_date: start_date,
      end_date: end_date,
      alert: days >= 80 # Alert at 80+ days
    }
  end
end
```

### 3. Calendar Data Generator
```ruby
class CalendarGenerator
  def self.generate(user, year, month)
    start_date = Date.new(year, month, 1)
    end_date = start_date.end_of_month

    visits = user.visits.where('start_date <= ? AND end_date >= ?', end_date, start_date)
                   .includes(:country)

    calendar_data = {}
    (start_date..end_date).each do |date|
      countries = visits.select do |visit|
        visit.start_date <= date && visit.end_date >= date
      end.map(&:country)

      calendar_data[date] = countries
    end

    calendar_data
  end
end
```

### 4. Trip Counter
```ruby
class TripCounter
  def self.count_trips(user, start_date, end_date)
    visits = user.visits.where('start_date <= ? AND end_date >= ?', end_date, start_date)
                   .order(:start_date)

    # Count separate trips (non-consecutive visits)
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
```

## User Interface Components

### 1. Dashboard View (Main Screen)
```
┌─────────────────────────────────────┐
│  ⚙️   Country Days Tracker      ➕  │
├─────────────────────────────────────┤
│  Range: 📅 1 Jan 2025-1 Jan 2026   │
├─────────────────────────────────────┤
│  🇨🇭 Switzerland              3     │
│  🇧🇷 Brazil                   80    │
│  🇺🇾 Uruguay                  76    │
├─────────────────────────────────────┤
│        January 2026        ◀  ▶     │
│  S  M  T  W  T  F  S               │
│           1🇨🇭 2🇨🇭 3🇨🇭            │
│  4🇨🇭 5🇨🇭 6🇨🇭 7🇨🇭 8🇨🇭 9🇨🇭 10🇨🇭  │
│  ...                               │
├─────────────────────────────────────┤
│  World Map (3): 📅 1 Jan-1 Jan     │
└─────────────────────────────────────┘
```

### 2. Add Visit Form
```
┌─────────────────────────────────────┐
│  Add New Visit                  ✕   │
├─────────────────────────────────────┤
│  Country: [Select Country ▼]        │
│           🔍 Search countries...    │
│                                     │
│  Start Date: [📅 1 Jan 2025]        │
│  End Date:   [📅 10 Jan 2025]       │
│                                     │
│  Days: 10                           │
│                                     │
│  Purpose: [Tourism ▼]               │
│                                     │
│  Notes: [Optional notes...]         │
│                                     │
│        [Cancel]  [Save Visit]       │
└─────────────────────────────────────┘
```

### 3. Settings Screen
```
┌─────────────────────────────────────┐
│  Settings                       ✕   │
├─────────────────────────────────────┤
│  Profile                            │
│  • Email: user@example.com          │
│  • Home Country: 🇺🇸 United States  │
│  • Timezone: UTC-5                  │
│                                     │
│  Alerts                             │
│  ☑ Schengen 90/180 rule             │
│  ☑ Tax residency (183 days)         │
│  ☑ Custom country limits            │
│  Alert me at: [80%] of limit        │
│                                     │
│  Display                            │
│  Date Format: [DD/MM/YYYY ▼]        │
│  First day of week: [Monday ▼]      │
│                                     │
│  Data                               │
│  • Export data (CSV/JSON)           │
│  • Import data                      │
│  • Clear all data                   │
└─────────────────────────────────────┘
```

## Additional Features (Future Enhancements)

### Phase 2
1. **Export/Import**
   - Export visits to CSV/Excel
   - Import from CSV
   - Backup to cloud (Google Drive, iCloud)

2. **Expense Tracking**
   - Track expenses per visit
   - Currency conversion
   - Reports for tax purposes

3. **Document Management**
   - Store visa documents
   - Passport scans
   - Entry/exit stamps photos
   - Expiry date reminders

### Phase 3
1. **Collaboration**
   - Share trips with family members
   - Joint travel planning
   - Family immigration tracking

2. **Advanced Analytics**
   - Visualizations and charts
   - Year-over-year comparisons
   - Most visited countries
   - Longest trips

3. **Integration**
   - Google Calendar integration
   - Flight booking integration (Gmail parsing)
   - Automatic trip detection from location data

## Development Phases

### Phase 1: MVP (Minimum Viable Product)
1. User authentication (sign up, login, logout)
2. CRUD operations for visits
3. Country selection (with flags)
4. Day counter for selected date range
5. Basic calendar view
6. Trip counter
7. Simple dashboard

### Phase 2: Core Features
1. Schengen 90/180 calculator
2. Tax residency alerts
3. Custom country rules
4. Enhanced calendar with better UX
5. Date range presets
6. Data export (CSV)

### Phase 3: Advanced Features
1. PWA installation
2. Offline support
3. Push notifications for alerts
4. Data import
5. Advanced analytics
6. Document storage

## Technical Requirements

### Dependencies (Gemfile)
```ruby
source 'https://rubygems.org'
ruby '3.2.2'

gem 'rails', '~> 7.1'
gem 'pg', '~> 1.5'
gem 'puma', '~> 6.0'
gem 'bcrypt', '~> 3.1' # For password encryption
gem 'redis', '~> 5.0' # For caching
gem 'countries' # Country data
gem 'flag-icons-rails' # Country flags
gem 'jbuilder' # JSON API responses
gem 'hotwire-rails' # Turbo and Stimulus
gem 'tailwindcss-rails' # CSS framework

group :development, :test do
  gem 'debug'
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'faker'
end

group :development do
  gem 'web-console'
end
```

### Environment Setup
- Ruby 3.2+
- Rails 7.1+
- PostgreSQL 14+
- Node.js 18+ (for asset pipeline)

## Deployment Options

1. **Heroku** (Easiest)
   - Free tier available
   - Easy Rails deployment
   - PostgreSQL add-on

2. **Fly.io** (Modern)
   - Free tier
   - Global edge network
   - Docker-based

3. **Railway** (Simple)
   - GitHub integration
   - Easy database setup
   - Generous free tier

4. **DigitalOcean App Platform**
   - Affordable
   - Managed databases
   - Easy scaling

## Testing Strategy

1. **Model Tests**
   - Visit validations
   - Day calculation logic
   - Schengen rule calculations
   - Trip counting

2. **Controller Tests**
   - CRUD operations
   - Authentication
   - Authorization

3. **Integration Tests**
   - User flows
   - Dashboard rendering
   - Calendar generation

4. **System Tests**
   - End-to-end scenarios
   - Browser testing with Capybara

## Security Considerations

1. **Authentication**
   - Secure password hashing (bcrypt)
   - Session management
   - CSRF protection (Rails default)

2. **Authorization**
   - Users can only see their own visits
   - Prevent unauthorized access

3. **Data Privacy**
   - GDPR compliance considerations
   - Data export capability
   - Account deletion

4. **Input Validation**
   - Prevent XSS attacks
   - SQL injection protection (Rails default)
   - Date validation

## Success Metrics

1. **Functionality**
   - Accurate day counting
   - Correct Schengen calculations
   - No overlapping visits
   - Reliable alerts

2. **Performance**
   - Page load < 2 seconds
   - Calendar generation < 500ms
   - Support 1000+ visits per user

3. **User Experience**
   - Intuitive interface
   - Mobile-friendly
   - Offline capability (PWA)
   - Works on iOS and Android browsers

## Next Steps

1. ✅ Clean up repository
2. ✅ Create this plan document
3. Initialize new Rails 7 application
4. Set up database with schema
5. Create models with validations
6. Build basic CRUD for visits
7. Implement day calculator
8. Create dashboard view
9. Add calendar visualization
10. Implement Schengen calculator
11. Add alerts and notifications
12. Style with Tailwind CSS
13. Deploy MVP

---

**Questions to Consider:**
1. Do you want to support multiple users or single-user app?
2. Should we include expense tracking from the start?
3. Which deployment platform do you prefer?
4. Do you need multi-language support?
5. Should we implement social features (sharing trips)?
