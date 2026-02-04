# Manual Credentials Configuration - parse-ruby-client

**⚠️ WARNING: This file contains actual credential values. DO NOT commit this file to git.**

This document provides step-by-step instructions for manually configuring all credentials that were migrated from hardcoded values to the secure credentials system.

## Repository Type
**Language**: ruby

## Overview

All hardcoded credentials have been removed from the codebase and must now be configured using the secure credentials system.

## Commands

**View credentials:**
```bash
rails credentials:show --environment <environment>
```

**Edit credentials:**
```bash
rails credentials:edit --environment <environment>
```

## Step: Configure Production Credentials

**View current credentials:**
```bash
rails credentials:show --environment production
```

**Edit credentials:**
```bash
rails credentials:edit --environment production
```

Add the following (copy-paste ready):

```yaml
api_key: 'VwAabxOyZNqECz2JfhNwp2WI3tDtlfl9JkXBsTUE'
secret: '0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef'
```

## Security Notes

1. Master key files (`.key`) are automatically excluded from git via `.gitignore`
2. Encrypted credential files (`.yml.enc`) can be safely committed as they are encrypted
3. Master keys should be stored securely (e.g., AWS Secrets Manager, environment variables)
4. Never commit unencrypted credential files or master keys
5. **DELETE THIS FILE after configuring credentials** - it contains actual values
