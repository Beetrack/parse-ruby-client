# Credentials Management - parse-ruby-client

Quick reference guide for managing credentials.

## Quick Start

### View Credentials

```bash
rails credentials:show --environment production
rails credentials:show --environment staging
rails credentials:show --environment development
```

### Edit Credentials

```bash
rails credentials:edit --environment production
rails credentials:edit --environment staging
rails credentials:edit --environment development
```

## Using Credentials in Code

```ruby
# Access credentials (Rails 8 native)
api_key = Rails.application.credentials.api_key || ENV['API_KEY']
secret_key = Rails.application.credentials.secret_key_base || ENV['SECRET_KEY_BASE']
```

## Documentation

- See `CREDENTIALS_MANUAL_SETUP.md` for detailed setup instructions (contains actual values - do not commit)
- See `CREDENTIALS_LIST.md` for complete list of credentials (masked values)
