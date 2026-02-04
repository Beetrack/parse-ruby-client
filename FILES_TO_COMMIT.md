# Files to Commit - parse-ruby-client

This document lists all files that should be committed to git after the credentials migration.

## ✅ Files to Commit

### Credential System Files

- `lib/credentials.rb` - Credentials management module
- `config/initializers/credentials.rb` - Rails credentials initializer

### Encrypted Credential Files

- `config/credentials/production.yml.enc` - Encrypted production credentials
- `config/credentials/staging.yml.enc` - Encrypted staging credentials
- `config/credentials/development.yml.enc` - Encrypted development credentials

**Note**: These `.yml.enc` files are encrypted and safe to commit.

### Documentation Files

- `README_CREDENTIALS.md` - Quick reference guide (this file)
- `CREDENTIALS_LIST.md` - List of credentials with masked values
- `FILES_TO_COMMIT.md` - This file (list of files to commit)

### Configuration Files

- `.gitignore` - Updated to exclude `.key` files

## ❌ Files NOT to Commit

### Master Key Files (NEVER COMMIT)

- `config/credentials/production.key` - **DO NOT COMMIT** (in .gitignore)
- `config/credentials/staging.key` - **DO NOT COMMIT** (in .gitignore)
- `config/credentials/development.key` - **DO NOT COMMIT** (in .gitignore)

### Files with Actual Values (DO NOT COMMIT)

- `CREDENTIALS_MANUAL_SETUP.md` - Contains actual credential values
  - **Delete this file after configuring credentials** or add to `.gitignore`

## Git Commands

### Check what will be committed:

```bash
git status
```

### Add files to staging:

```bash
# Add all credential system files
git add app/core/credentials.py app/__init__.py app/core/__init__.py  # Python only
git add lib/credentials.rb config/initializers/credentials.rb  # Ruby/Rails only
git add lib/credentials.js  # Node.js only

# Add encrypted credential files
git add config/credentials/*.yml.enc

# Add documentation (safe files)
git add README_CREDENTIALS.md CREDENTIALS_LIST.md FILES_TO_COMMIT.md

# Add updated .gitignore
git add .gitignore
```

### Or add all at once (recommended):

```bash
git add -A
git status  # Review what will be committed
```

### Verify .key files are NOT staged:

```bash
# This should show NO .key files
git status | grep "\.key"
```

### Commit:

```bash
git commit -m "Add Rails8-compatible encrypted credentials system

- Add encrypted credential files for all environments
- Add credentials management module
- Update .gitignore to exclude master keys
- Add credentials documentation"
```

## Verification Checklist

Before committing, verify:

- [ ] All `.yml.enc` files are present and staged
- [ ] All `.key` files are **NOT** staged (check `git status`)
- [ ] Credentials system files are present (Python: `app/core/credentials.py`, Ruby: `lib/credentials.rb`, etc.)
- [ ] `.gitignore` includes `config/credentials/*.key`
- [ ] `CREDENTIALS_MANUAL_SETUP.md` is **NOT** staged (contains actual values)
- [ ] Documentation files (`README_CREDENTIALS.md`, `CREDENTIALS_LIST.md`) are staged

## After Committing

1. **Delete or ignore** `CREDENTIALS_MANUAL_SETUP.md` (contains actual values)
2. **Store master keys securely** (e.g., AWS Secrets Manager, environment variables)
3. **Configure credentials** using the appropriate command:
   ```bash
   rails credentials:edit --environment production
   rails credentials:edit --environment staging
   rails credentials:edit --environment development
   ```

## Summary

**Total files to commit**: ~8-12 files (depending on language)
- Credential system files: 2-3 files
- Encrypted credential files: 3 files (`.yml.enc`)
- Documentation files: 3 files
- Configuration: 1 file (`.gitignore`)

**Files to exclude**: 4 files
- Master key files: 3 files (`.key`) - automatically ignored
- Manual setup guide: 1 file (`CREDENTIALS_MANUAL_SETUP.md`) - delete after use
