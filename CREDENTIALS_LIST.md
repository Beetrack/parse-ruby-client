# Complete Credentials List - parse-ruby-client

This document provides a complete list of all credentials that must be added to the encrypted credential files.

**Note**: Values shown are masked for security. See `CREDENTIALS_MANUAL_SETUP.md` for actual values (do not commit that file).

## Viewing Credentials

**View all credentials:**
```bash
rails credentials:show --environment <environment>
```

Examples:
```bash
rails credentials:show --environment production
rails credentials:show --environment staging
rails credentials:show --environment development
```

## Production Environment (`production.yml.enc`)

**View credentials:**
```bash
rails credentials:show --environment production
```

**Credentials (masked):**
```yaml
api_key: 'VwAa...s'  # Masked: VwAa...s
secret: '0123...c'  # Masked: 0123...c
```

