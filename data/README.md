# Data Directory

This directory contains data files including seed data, sample data, and test data.

## Files

- `sample_data.sql` - Sample data for development and testing

## Usage

Run data scripts after creating the schema:

```sql
-- Run after schema creation
:r data/sample_data.sql
```

## Best Practices

- Separate seed data (required) from sample data (optional)
- Use meaningful, realistic sample data
- Include data validation and cleanup
- Document data relationships and dependencies