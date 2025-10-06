# Scripts Directory

This directory contains utility and deployment scripts.

## Files

- `deploy_database.sql` - Complete database deployment script
- `cleanup_database.sql` - Database cleanup and reset script

## Usage

### Deploy Database
```bash
sqlcmd -S server -d master -i scripts/deploy_database.sql
```

### Cleanup Database (Use with caution!)
```bash
sqlcmd -S server -d master -i scripts/cleanup_database.sql
```

## Best Practices

- Test scripts in development environment first
- Include proper error handling
- Add confirmation prompts for destructive operations
- Document script parameters and usage
- Use transaction blocks for multi-step operations