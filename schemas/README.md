# Schemas Directory

This directory contains database schema definition files.

## Files

- `01_create_database.sql` - Creates the main FabricWorkshopDB database
- `02_create_tables.sql` - Creates all core tables with relationships and indexes

## Usage

Execute these files in order:

1. First run `01_create_database.sql` to create the database
2. Then run `02_create_tables.sql` to create all tables and relationships

## Best Practices

- Always include proper error handling
- Use consistent naming conventions
- Add appropriate indexes for performance
- Include foreign key constraints for data integrity
- Use proper data types and constraints