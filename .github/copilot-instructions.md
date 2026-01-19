# Copilot Instructions for Beauty Business Management System

## Project Overview
A Rails 8.1 multi-tenant business management platform designed for the beauty industry (cosmetology, esthetics, spas, salons). Uses PostgreSQL, Hotwire (Turbo + Stimulus), TailwindCSS, and modern asset pipeline (Propshaft). Currently in active development with core models established and scheduling system as next priority.

## Architecture & Data Model

### Core Entities
- **Business**: Multi-tenant root entity - each business has independent configuration
- **Employee**: Staff members with profiles, roles, and service capabilities
- **Client**: Customer profiles with appointment history and preferences
- **Service**: Configurable services (haircuts, coloring, facials, waxing, etc.) that businesses can customize
- **Location**: Physical business locations (supports multi-location businesses)
- **Product**: Inventory items and supplies
- **Supplier**: Vendor management for product sourcing
- **Phone**: Contact information (polymorphic association)

### Multi-Tenant Architecture
- Each Business operates independently with its own data and configuration
- Business admins can configure which services they offer
- Role-based access control for staff permissions
- Customizable service catalog per business

### Database
- PostgreSQL backend (see [config/database.yml](config/database.yml))
- Migrations auto-generated in `db/migrate/`, schema in [db/schema.rb](db/schema.rb)
- SQLite3 fallback for development if needed

### Key Models Pattern
- Models live in [app/models/](app/models/) extending `ApplicationRecord`
- Using FactoryBot for test data (spec/factories/)
- Associations being built out as features are implemented
- Focus on proper validation and business logic in models

## Frontend Stack
- **Hotwire**: Turbo Rails for SPA-like behavior, Stimulus for lightweight JS
- **Asset Pipeline**: Propshaft (Rails 8 default), not Sprockets
- **Import Maps**: ES modules with [config/importmap.rb](config/importmap.rb)
- **Stimulus Controllers**: [app/javascript/controllers/](app/javascript/controllers/) - one controller per feature
- **JavaScript**: Bundled at [app/javascript/application.js](app/javascript/application.js)

## Essential Development Commands
```bash
bin/dev          # Runs Procfile.dev - starts dev server, CSS/JS watchers, job queue
bin/rails s      # Start Rails server (port 3000)
bin/rake db:migrate    # Run pending migrations
bundle exec rspec       # Run full RSpec test suite
bundle exec rspec spec/models       # Run model specs only
bundle exec rspec spec/system       # Run system tests (Capybara + Selenium)
bin/rubocop -A   # Fix style issues (Rails Omakase ruleset)
bin/brakeman     # Security scanning
bin/bundler-audit # Check gem vulnerabilities
```

## Testing Approach
- **Test Framework**: RSpec with Capybara for system tests
- **Fixtures**: Factory pattern (FactoryBot) for test data generation
- **Test File Locations**: 
  - Unit: `spec/models/` (e.g., `spec/models/employee_spec.rb`)
  - System: `spec/system/` (Capybara + Selenium)
  - Controllers: `spec/controllers/`
- **Spec Files**: Use `describe`/`context`/`it` blocks; one spec file per model/controller

## Code Conventions

### Rails 8.1 Specifics
- **Zeitwerk Autoloading**: No explicit requires needed; files in `app/` auto-loaded
- **Modern Browsers Only**: ApplicationController enforces webp, web push, CSS nesting support
- **Solid Gems**: Using solid_cache, solid_queue, solid_cable for self-hosted alternatives

### Naming & File Organization
- Controllers in [app/controllers/](app/controllers/), inherit from ApplicationController
- Models in [app/models/](app/models/), inherit from ApplicationRecord
- Concerns in `app/models/concerns/` and `app/controllers/concerns/` for shared logic
- Views in [app/views/](app/views/) organized by controller name

### Routes
- [config/routes.rb](config/routes.rb) has basic resources for employees, clients, services, businesses
- RESTful conventions followed for all resources
- Session management for authentication
- Future: API namespace for mobile app integration

## Development Priorities

### Phase 1: Foundation (In Progress)
- ✅ Core models established (Business, Employee, Client, Service, Product, Supplier)
- ✅ Basic controllers and views scaffolded
- 🔄 Authentication and session management
- 🔄 Role-based access control system
- 🔄 Model associations and validations

### Phase 2: Scheduling System (Next Priority)
- 📋 **Calendar Integration**: Evaluate and integrate calendar gem (Simple Calendar, FullCalendar, or ice_cube)
- 📋 **Appointment Model**: Create appointment booking system
- 📋 **Staff Availability**: Manage when staff can take appointments
- 📋 **Role-Based Booking**: Staff can book appointments based on permissions set by business admin
- 📋 **Conflict Detection**: Prevent double-booking and scheduling conflicts

### Phase 3: Business Configuration
- 📋 Service catalog customization per business
- 📋 Role and permission configuration interface
- 📋 Business settings and preferences
- 📋 Multi-location support

### Phase 4: Advanced Features
- 📋 Client self-service portal
- 📋 Online booking system
- 📋 Reporting and analytics
- 📋 Payment processing

## Deployment & Environment
- **Docker Support**: Dockerfile included; Kamal gem configured for deployment
- **Environment Config**: [config/environments/](config/environments/) - check development.rb vs production.rb
- **Credentials**: Use `RAILS_MASTER_KEY` for decrypting [config/credentials.yml.enc](config/credentials.yml.enc)
- **Puma**: Production web server configured in [config/puma.rb](config/puma.rb)

## When Adding Features
1. Always add migrations for schema changes (rails generate migration)
2. Use FactoryBot for test data (not fixtures)
3. Write RSpec tests before or alongside implementation
4. Use Stimulus for JS interactions, not inline scripts
5. Keep views DRY with partials and Hotwire Turbo Frames
6. Consider multi-tenant data isolation (scope queries by Business)
7. Implement role-based authorization checks in controllers
8. Run `bin/rails db:schema:load` after migrations to verify schema integrity

## Key Business Logic Patterns

### Multi-Tenancy
- Always scope data by Business unless explicitly working with cross-business features
- Use `current_business` helper in controllers to access active business context
- Ensure associations properly link to Business for data isolation

### Role-Based Access Control
- Business admins can configure roles and permissions
- Staff permissions determine what actions they can perform
- Consider permissions when building scheduling features (who can book what)

### Scheduling Considerations
- Staff availability should be configurable (working hours, days off)
- Services have durations that affect scheduling
- Need conflict detection for double-booking prevention
- Consider buffer time between appointments
