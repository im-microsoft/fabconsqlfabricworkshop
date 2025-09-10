# Procedures Directory

This directory contains stored procedures and user-defined functions.

## Files

- `sp_GetCustomerOrders.sql` - Get orders for a specific customer

## Naming Conventions

- Stored Procedures: `sp_{ProcedureName}`
- Functions: `fn_{FunctionName}` 
- Use descriptive names that indicate the purpose

## Best Practices

- Include parameter validation
- Use proper error handling with RAISERROR
- Add comprehensive documentation headers
- Use SET NOCOUNT ON for performance
- Include usage examples in comments