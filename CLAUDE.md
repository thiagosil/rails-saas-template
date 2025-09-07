# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Rails SaaS Template

This is a Rails 8.0.2+ SaaS application template using modern Rails architecture with Hotwire (Turbo + Stimulus) and Tailwind CSS for the frontend.

## Development Commands

### Local Development
- `bin/dev` - Start development server with hot-reloading (uses foreman to run both Rails server and CSS watch)
- `bin/rails server` - Start Rails server only
- `bin/rails console` - Rails console
- `bin/rails dbconsole` - Database console

### Testing and Code Quality
- `bin/rails test` - Run test suite (uses Capybara + Selenium for system tests)
- `bin/brakeman` - Security vulnerability scanning
- `bin/rubocop` - Code style linting (uses rubocop-rails-omakase)

### Database
- `bin/rails db:migrate` - Run database migrations
- `bin/rails db:seed` - Seed database
- `bin/rails db:reset` - Reset database (drop, create, migrate, seed)

### Asset Pipeline
- `bin/rails assets:precompile` - Precompile assets for production
- `bin/rails tailwindcss:watch` - Watch Tailwind CSS changes
- `bin/rails importmap:install` - Install importmap dependencies

### Background Jobs
- `bin/jobs` - Run Solid Queue job processor
- `bin/rails solid_queue:start` - Start Solid Queue supervisor

## Architecture Overview

### Modern Rails Stack
- **Rails 8.0.2+** with all defaults enabled
- **Hotwire**: Turbo Rails + Stimulus for SPA-like experience without complex JavaScript
- **Tailwind CSS**: Utility-first CSS framework
- **Importmap**: ESM import maps for JavaScript (no bundling)
- **Propshaft**: Modern asset pipeline

### Backend Services (The Solid Trilogy)
- **Solid Cache**: Database-backed Rails cache
- **Solid Queue**: Database-backed Active Job adapter
- **Solid Cable**: Database-backed Action Cable adapter

### Database & Storage
- **SQLite3**: Default database (production-ready with proper setup)
- **Active Storage**: File uploads with local disk storage

### Deployment
- **Kamal**: Docker-based deployment tool (successor to Capistrano)
- **Thruster**: HTTP/2 proxy with asset caching and compression
- **Docker**: Multi-stage builds for production

## Key Configuration Files

- `config/application.rb`: Main application configuration (RailsSaasTemplate module)
- `config/deploy.yml`: Kamal deployment configuration
- `Procfile.dev`: Development process definitions (web + CSS watching)
- `Dockerfile`: Multi-stage production build
- `.rubocop.yml`: Inherits from rubocop-rails-omakase

## Ruby Version

Ruby 3.4.5 (specified in `.ruby-version`)

## Deployment

### Kamal Commands
- `bin/kamal setup` - Initial server setup
- `bin/kamal deploy` - Deploy application
- `bin/kamal app logs` - View application logs
- `bin/kamal console` - Remote Rails console
- `bin/kamal shell` - Remote shell access

The template is configured for single-server deployment with SSL via Let's Encrypt.

## Development Notes

- Uses Ruby debug gem with remote debugging enabled in development
- Foreman manages multiple processes in development (Rails server + CSS watcher)
- Job processing runs inside Puma process via SOLID_QUEUE_IN_PUMA=true
- All modern Rails conventions are followed (autoloading, credentials, etc.)