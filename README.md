 🚀 Rails SaaS Template

  A modern, production-ready Rails template for building SaaS applications. Get from zero to production in minutes, not weeks.

  https://rubyonrails.org
  https://ruby-lang.org
  LICENSE
  #testing

  ✨ Features

  🔐 Authentication & Authorization

  - Production-grade authentication system (inspired by Basecamp's approach)
  - Multi-session management with device tracking
  - OAuth social logins (Google, GitHub, Twitter)
  - API authentication with JWT tokens
  - Role-based permissions and team management

  💳 Payments & Subscriptions

  - Stripe integration with webhook handling
  - Multiple subscription plans support
  - Usage-based billing ready
  - Invoice generation and management
  - Payment method management
  - Subscription lifecycle (trials, upgrades, cancellations)

  🏢 Multi-tenancy

  - Account-based architecture (perfect for B2B SaaS)
  - Team management with role-based access
  - Subdomain routing support
  - Data isolation between accounts
  - Resource scoping and security

  🎨 Modern UI/UX

  - TailwindCSS for rapid styling
  - Hotwire (Turbo + Stimulus) for reactive interactions
  - Responsive design out of the box
  - Dark mode support
  - Component-based architecture

  🚀 Developer Experience

  - Background jobs with Sidekiq
  - Email templates for transactional emails
  - Admin dashboard for management
  - API-first approach with documentation
  - Comprehensive testing suite
  - Docker support for deployment

  🌍 Production Ready

  - Internationalization (i18n) support
  - Error tracking with Sentry
  - Performance monitoring
  - Security best practices
  - GDPR compliance helpers
  - Health checks and monitoring

  🏁 Quick Start

⏺ Option 1: Use the Rails Template (Recommended)

  rails new my_saas_app -m https://raw.githubusercontent.com/yourusername/rails-saas-template/main/template.rb
  cd my_saas_app
  bin/setup
  bin/rails server

  Option 2: Clone and Customize

  git clone https://github.com/yourusername/rails-saas-template.git my_saas_app
  cd my_saas_app
  ./bin/setup
  bin/rails server

  Option 3: Use as GitHub Template

  1. Click "Use this template" on GitHub
  2. Clone your new repository
  3. Run ./bin/setup
  4. Start building! 🚀

  ⚙️ Configuration

  Environment Variables

  Create a .env file with the following variables:

  # Database
  DATABASE_URL=postgresql://localhost/my_saas_app_development

  # Redis (for background jobs and caching)
  REDIS_URL=redis://localhost:6379/0

  # Stripe (payments)
  STRIPE_PUBLISHABLE_KEY=pk_test_...
  STRIPE_SECRET_KEY=sk_test_...
  STRIPE_WEBHOOK_SECRET=whsec_...

  # OAuth Providers
  GOOGLE_CLIENT_ID=your_google_client_id
  GOOGLE_CLIENT_SECRET=your_google_client_secret
  GITHUB_CLIENT_ID=your_github_client_id
  GITHUB_CLIENT_SECRET=your_github_client_secret

  # Email (choose one)
  MAILGUN_API_KEY=your_mailgun_key
  SENDGRID_API_KEY=your_sendgrid_key

  # Error Tracking
  SENTRY_DSN=your_sentry_dsn

  # Application
  APP_DOMAIN=localhost:3000
  SECRET_KEY_BASE=your_secret_key_base

  Initial Setup

  # Install dependencies
  bundle install
  yarn install

  # Setup database
  bin/rails db:setup

  # Create admin user
  bin/rails admin:create

  # Setup Stripe webhooks (development)
  stripe listen --forward-to localhost:3000/webhooks/stripe

  # Start background jobs
  bundle exec sidekiq -C config/sidekiq.yml

  🛠️ Development

  Available Commands

  # Start the application
  bin/dev                    # Starts Rails, Sidekiq, and TailwindCSS

  # Database operations
  bin/rails db:reset         # Reset with sample data
  bin/rails db:migrate       # Run migrations
  bin/rails db:seed          # Load sample data

  # Testing
  bin/rails test             # Run test suite
  bin/rails test:system      # Run system tests

  # Code quality
  bin/rubocop               # Ruby linting
  bin/brakeman              # Security analysis

  # Deployment
  bin/deploy staging        # Deploy to staging
  bin/deploy production     # Deploy to production

  Project Structure

  app/
  ├── controllers/
  │   ├── concerns/          # Shared controller logic
  │   ├── api/v1/           # API controllers
  │   ├── billing/          # Payment & subscription logic
  │   └── admin/            # Admin interface
  ├── models/
  │   ├── concerns/         # Shared model logic
  │   ├── billing/          # Payment models
  │   └── users/            # User-related models
  ├── views/
  │   ├── layouts/          # Application layouts
  │   ├── shared/           # Shared partials
  │   └── components/       # View components
  ├── javascript/
  │   ├── controllers/      # Stimulus controllers
  │   └── components/       # JS components
  └── assets/
      └── stylesheets/      # TailwindCSS styles

  🏗️ Architecture

  Authentication Flow

  graph TD
      A[User] --> B[Sign Up/Login]
      B --> C{OAuth or Email?}
      C -->|OAuth| D[Provider Auth]
      C -->|Email| E[Email/Password]
      D --> F[Create/Link Account]
      E --> F
      F --> G[Create Session]
      G --> H[Set Current User]
      H --> I[Dashboard]

  Multi-tenancy Model

  # Every user belongs to an account
  User belongs_to :account
  Account has_many :users

  # Resources are scoped to accounts
  class ApplicationController
    before_action :set_current_account

    private

    def set_current_account
      Current.account = current_user.account
    end
  end

  Payment Integration

  # Subscription lifecycle
  Account has_one :subscription
  Subscription belongs_to :plan
  Plan has_many :subscriptions

  # Usage tracking
  Account has_many :usage_records
  UsageRecord belongs_to :account

  🎨 Customization

⏺ Branding & Styling

  # Update app name and branding
  bin/rails generate saas:rebrand "My SaaS App"

  # Customize colors (TailwindCSS)
  # Edit app/assets/stylesheets/application.tailwind.css

  Adding Features

  # Add blog functionality
  bin/rails generate saas:blog

  # Add chat/messaging
  bin/rails generate saas:messaging

  # Add file uploads
  bin/rails generate saas:uploads

  # Add analytics dashboard
  bin/rails generate saas:analytics

  Payment Plans

  # Create custom plans in db/seeds.rb
  Plan.create!(
    name: "Starter",
    price_cents: 2900,  # $29.00
    interval: "month",
    features: {
      users: 5,
      projects: 10,
      storage_gb: 50,
      api_calls: 1000
    }
  )

  Email Templates

  # Generate email templates
  bin/rails generate mailer UserMailer welcome payment_failed
  bin/rails generate mailer AdminMailer new_signup payment_issue

  🧪 Testing

  Running Tests

  # Run all tests
  bin/rails test

  # Run specific test files
  bin/rails test test/models/user_test.rb
  bin/rails test test/controllers/billing_controller_test.rb

  # Run system tests
  bin/rails test:system

  # Run with coverage
  COVERAGE=true bin/rails test

  Test Structure

  test/
  ├── fixtures/           # Test data
  ├── models/            # Model tests
  ├── controllers/       # Controller tests
  ├── system/           # End-to-end tests
  ├── integration/      # Integration tests
  └── support/          # Test helpers

  Key Test Scenarios Covered

  - ✅ User registration and authentication
  - ✅ Subscription creation and management
  - ✅ Payment processing and webhooks
  - ✅ Multi-tenancy and data isolation
  - ✅ API endpoints and authentication
  - ✅ Email delivery and templates
  - ✅ Background job processing

  🚀 Deployment

  Platforms Supported

⏺ - Heroku (one-click deploy)
  - Railway (recommended for simplicity)
  - Render (great for startups)
  - DigitalOcean App Platform
  - AWS (with Docker)
  - Google Cloud Run

  One-Click Deploys

  https://heroku.com/deploy?template=https://github.com/yourusername/rails-saas-template

  https://railway.app/new/template/rails-saas-template

  https://render.com/deploy?repo=https://github.com/yourusername/rails-saas-template

  Manual Deployment

  # Build Docker image
  docker build -t my-saas-app .

  # Run locally with Docker
  docker-compose up

  # Deploy to production
  bin/deploy production

  Environment Setup

  # Production environment variables
  RAILS_ENV=production
  SECRET_KEY_BASE=your_production_secret
  DATABASE_URL=your_production_db_url
  REDIS_URL=your_production_redis_url

  # Enable SSL and security headers
  FORCE_SSL=true
  RAILS_SERVE_STATIC_FILES=true

  📚 Documentation

  API Documentation

  Access the interactive API documentation at /api/docs when running in development mode.

  Feature Guides

  - docs/authentication.md
  - docs/payments.md
  - docs/multi-tenancy.md
  - docs/emails.md
  - docs/jobs.md
  - docs/testing.md
  - docs/deployment.md

  Video Tutorials

  - 🎥 https://youtu.be/example
  - 🎥 https://youtu.be/example
  - 🎥 https://youtu.be/example

  🤝 Contributing

  We love contributions! See our CONTRIBUTING.md for details.

  Development Setup

  git clone https://github.com/yourusername/rails-saas-template.git
  cd rails-saas-template
  bin/setup
  bin/rails test

  Reporting Issues

  Please use our https://github.com/yourusername/rails-saas-template/issues to report bugs or request features.

  📄 License

  This project is licensed under the MIT License - see the LICENSE file for details.

  ⭐ Support

  If this template helped you build something awesome, please:

  - ⭐ Star this repository
  - 🐦 https://twitter.com/intent/tweet?text=Just%20built%20my%20SaaS%20with%20this%20amazing%20Rails%20template!&url=https://github.com/yourusername/rails-saas-template
  - 💝 https://github.com/sponsors/yourusername

  ---
  🏆 Why Choose This Template?

  vs. Building from Scratch

  - ⚡ Save 40-60 hours of initial setup
  - 🔒 Production-tested authentication
  - 💳 Battle-tested payment integration
  - 🧪 Comprehensive test coverage

  vs. Other Templates

  - 🆓 100% Open Source (not $99-$318)
  - 🛠️ Full code ownership (customize anything)
  - 📚 Educational (learn while you build)
  - 🤝 Community-driven (contribute and improve)

  vs. SaaS Builders

  - 💰 No monthly fees or revenue sharing
  - 🎨 Complete design control
  - 📊 Own your data and analytics
  - 🚀 Deploy anywhere you want

  ---
  Ready to build your next SaaS? Let's get started! 🚀

  rails new my_amazing_saas -m https://raw.githubusercontent.com/yourusername/rails-saas-template/main/template.rb