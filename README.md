# Immigration Day Tracker

A Ruby on Rails application for tracking the number of days spent in different countries for immigration and tax residency purposes.

## Features

### Core Features
- **Country Days Summary**: Track and display total days spent in each country within a selected date range
- **Calendar Visualization**: Monthly calendar showing country flags on dates when visits occurred
- **Date Range Selection**: Flexible date range filtering (defaults to current year)
- **Trip Counter**: Automatically counts separate trips based on visit dates
- **Visit Management**: Full CRUD operations for adding, editing, and deleting visits

### Immigration Rules
- **Schengen 90/180 Calculator**: Automatic calculation and alerts for the Schengen area 90-day rule in any 180-day period
- **Tax Residency Tracking**: Monitor 183-day threshold for tax residency purposes
- **Custom Alerts**: Warnings when approaching visa limits

### User Experience
- **Dark Theme UI**: Modern dark interface matching mobile app aesthetics
- **Country Flags**: Visual country identification with emoji flags
- **Responsive Design**: Works on desktop and mobile browsers
- **Authentication**: Secure user accounts with encrypted passwords

## Technology Stack

- **Backend**: Ruby on Rails 7.2
- **Database**: SQLite3 (development), easily switchable to PostgreSQL
- **Frontend**: Hotwire (Turbo + Stimulus)
- **Styling**: Tailwind CSS
- **Authentication**: bcrypt for secure passwords

## Database Schema

### Users
- Email, password (encrypted)
- Name, home country, timezone

### Countries
- Country code (ISO 3166-1 alpha-2)
- Name, flag emoji
- Visa limits and periods
- Tax residency days (default: 183)

### Visits
- User and country associations
- Start date and end date
- Purpose (Tourism, Work, Study, Family, Transit)
- Notes

### Country Rules (Future Enhancement)
- Custom day limits per country per user
- Alert thresholds

## Setup Instructions

### Prerequisites
- Ruby 3.3.6
- Rails 7.2+
- SQLite3 (or PostgreSQL)

### Installation

1. Install dependencies:
```bash
bundle install
```

2. Set up the database:
```bash
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed
```

3. Start the server:
```bash
bin/rails server
```

4. Visit `http://localhost:3000`

## Usage

### First Time Setup

1. **Sign Up**: Create an account at `/signup`
2. **Add Visits**: Click "+ Add Visit" to record your country visits
3. **View Dashboard**: See your country summary, calendar, and Schengen status

### Adding a Visit

1. Select the country from the dropdown (46 countries pre-loaded)
2. Enter start and end dates
3. Optionally add purpose and notes
4. Click "Add Visit"

### Dashboard Features

- **Country Summary**: Shows days spent in each country, sorted by most days
- **Calendar**: Navigate months with arrow buttons, see flags on visit dates
- **Schengen Status**: Real-time calculation of 90/180 rule compliance
- **Recent Visits**: Quick access to edit or delete recent trips

## Pre-Loaded Countries

The application includes 46 pre-seeded countries:
- All 23 Schengen countries (with 90/180 visa limits)
- Major destinations in Americas, Asia-Pacific, Middle East, Africa
- Each with country code, name, flag emoji, and visa limit days

## Key Calculations

### Day Counter
Calculates total days in a country within a date range, handling:
- Overlapping periods
- Partial date ranges
- Multiple visits to same country

### Schengen 90/180 Rule
Implements rolling 180-day window calculation:
- Counts days in all Schengen countries
- Alerts at 80+ days
- Shows days remaining
- Warns of overstay

### Trip Counter
Counts separate trips by identifying:
- Non-consecutive visits (gap > 1 day)
- Separate country entries

## Project Structure

```
app/
├── controllers/
│   ├── application_controller.rb   # Auth helpers
│   ├── dashboard_controller.rb     # Main dashboard
│   ├── sessions_controller.rb      # Login/logout
│   ├── users_controller.rb         # Sign up
│   └── visits_controller.rb        # Visit CRUD
├── models/
│   ├── user.rb                     # User with auth
│   ├── country.rb                  # Country data
│   ├── visit.rb                    # Visit records
│   └── country_rule.rb             # Custom rules
├── services/
│   ├── day_calculator.rb           # Day counting logic
│   └── schengen_calculator.rb      # 90/180 rule
└── views/
    ├── dashboard/
    │   └── index.html.erb          # Main dashboard
    ├── sessions/
    │   └── new.html.erb            # Login form
    ├── users/
    │   └── new.html.erb            # Sign up form
    └── visits/
        ├── index.html.erb          # All visits list
        ├── new.html.erb            # Add visit form
        └── edit.html.erb           # Edit visit form
```

## Development Roadmap

See `PLAN.md` for the complete feature roadmap including:
- Phase 2: Export/Import, Expense Tracking, Document Management
- Phase 3: Collaboration, Advanced Analytics, Integrations

## Contributing

This is a personal project for immigration tracking. Feel free to fork and adapt for your own use.

## License

Open source - use freely for personal or commercial purposes.

## Security Notes

- Passwords are encrypted using bcrypt
- CSRF protection enabled by default
- SQL injection protection via ActiveRecord
- User data is isolated (users can only see their own visits)

## Deployment

The application is ready to deploy to:
- Heroku (easiest - includes Dockerfile)
- Fly.io (modern, edge network)
- Railway (simple GitHub integration)
- DigitalOcean App Platform

See `PLAN.md` for detailed deployment instructions.

## Credits

Inspired by the need to track immigration day limits for digital nomads and international travelers.

Built with Ruby on Rails 7, Tailwind CSS, and modern web technologies.
