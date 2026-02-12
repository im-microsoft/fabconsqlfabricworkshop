# Views Directory

This directory contains database views for reporting and data abstraction.

## Files

- `vw_CustomerOrderSummary.sql` - Customer order summary for reporting

## Naming Conventions

- Views: `vw_{ViewName}`
- Use descriptive names that indicate the purpose
- Consider performance implications

## Best Practices

- Use views to simplify complex queries
- Abstract business logic from applications
- Include proper documentation
- Consider indexing underlying tables
- Use schema binding when appropriate (WITH SCHEMABINDING)