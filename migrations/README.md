# Migrations Directory

This directory contains database migration scripts for version control and deployment.

## Naming Convention

Use the format: `V{number}_{description}.sql`

Examples:
- `V001_initial_schema.sql`
- `V002_add_user_tables.sql`
- `V003_update_indexes.sql`

## Migration Tracking

Each migration script should:
1. Check if it has already been applied
2. Apply the changes if not already applied
3. Record the migration in the `SchemaVersions` table

## Best Practices

- Never modify existing migration files
- Always create new migrations for schema changes
- Include rollback instructions in comments
- Test migrations on a copy of production data first