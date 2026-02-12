# Fabric SQL Workshop Repository

A comprehensive repository for SQL database projects designed for the Fab Con Vienna Workshop.

## Repository Structure

```
├── schemas/          # Database schema definitions
├── migrations/       # Database migration scripts
├── data/            # Seed data and sample datasets
├── procedures/      # Stored procedures and functions
├── views/           # Database views
├── scripts/         # Utility and deployment scripts
└── README.md        # This file
```

## Quick Start

### 1. Deploy the Database

Run the complete deployment script:

```bash
sqlcmd -S your_server -d master -i scripts/deploy_database.sql
```

Or execute scripts individually:

```bash
# Create database
sqlcmd -S your_server -d master -i schemas/01_create_database.sql

# Create tables  
sqlcmd -S your_server -d FabricWorkshopDB -i schemas/02_create_tables.sql

# Apply migrations
sqlcmd -S your_server -d FabricWorkshopDB -i migrations/V001_initial_schema.sql

# Create procedures and views
sqlcmd -S your_server -d FabricWorkshopDB -i procedures/sp_GetCustomerOrders.sql
sqlcmd -S your_server -d FabricWorkshopDB -i views/vw_CustomerOrderSummary.sql

# Insert sample data
sqlcmd -S your_server -d FabricWorkshopDB -i data/sample_data.sql
```

### 2. Verify Installation

```sql
USE FabricWorkshopDB;
SELECT * FROM dbo.vw_CustomerOrderSummary;
EXEC dbo.sp_GetCustomerOrders @CustomerID = 1;
```

## Database Schema

The workshop database includes:

- **Customers** - Customer information
- **Categories** - Product categories
- **Products** - Product catalog with pricing
- **Orders** - Customer orders
- **OrderItems** - Order line items with quantities and pricing

## Sample Queries

### Get Customer Order Summary
```sql
SELECT * FROM dbo.vw_CustomerOrderSummary 
WHERE CustomerSegment = 'VIP'
ORDER BY TotalSpent DESC;
```

### Get Customer Orders
```sql
EXEC dbo.sp_GetCustomerOrders @CustomerID = 1;
```

### Top Products by Revenue
```sql
SELECT 
    p.ProductName,
    SUM(oi.LineTotal) as TotalRevenue,
    SUM(oi.Quantity) as TotalQuantity
FROM dbo.Products p
INNER JOIN dbo.OrderItems oi ON p.ProductID = oi.ProductID
GROUP BY p.ProductName
ORDER BY TotalRevenue DESC;
```

## Best Practices

### Schema Management
- Use version-controlled migration scripts
- Always include rollback procedures
- Test schema changes in development first
- Document all changes with clear descriptions

### Code Organization
- Separate DDL (Data Definition Language) from DML (Data Manipulation Language)
- Use consistent naming conventions
- Include proper error handling
- Add comprehensive comments and documentation

### Performance
- Create appropriate indexes for query patterns
- Use stored procedures for complex business logic
- Implement proper data validation
- Monitor query performance regularly

## Development Workflow

1. **Schema Changes**: Create new migration script in `migrations/`
2. **New Objects**: Add procedures/views/functions to appropriate directories
3. **Sample Data**: Update `data/sample_data.sql` if needed
4. **Documentation**: Update README files in each directory
5. **Testing**: Validate changes in development environment

## Workshop Exercises

This repository supports various SQL workshop exercises:

- Database design and normalization
- Writing efficient queries
- Creating stored procedures and functions
- Building reporting views
- Performance optimization
- Migration management

## Cleanup

To reset the database for fresh exercises:

```bash
# Review what will be cleaned (safe mode)
sqlcmd -S your_server -d FabricWorkshopDB -i scripts/cleanup_database.sql

# Edit cleanup script to enable desired cleanup option
```

## Contributing

When adding new database objects:

1. Follow the established naming conventions
2. Include proper documentation headers
3. Add example usage in comments
4. Update relevant README files
5. Test thoroughly before committing

## Prerequisites

- SQL Server 2019 or later
- sqlcmd utility
- Appropriate database permissions

## Support

For workshop-related questions, refer to the individual README files in each directory or consult the workshop materials.
