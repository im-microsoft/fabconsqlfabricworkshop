
import fabric.functions as fn

udf = fn.UserDataFunctions()

@udf.connection(argName="sqlDB",alias="Fabcondatabase") 
@udf.function() 


def write_emp_info_on_product_Review(sqlDB: fn.FabricSqlConnection, productid: int, ReviewID: int, EmployeeID: int, employeeComments: str) -> str:

    # Error handling to ensure product description doesn't go above 200 characters
    if(len(employeeComments) > 20000):
        raise fn.UserThrownError("Comments have a 20000 character limit. Please shorten your description.", {"Comments:": employeeComments})

    # Establish a connection to the SQL database  
    connection = sqlDB.connect() 
    cursor = connection.cursor() 

    # Insert data into the ProductDescription table
    insert_description_query = "UPDATE dbo.product_review_feedback set employee_comments =?, updated_date=getdate() where ProductID=? and ReviewID=? and employee_ID=?"   
    cursor.execute(insert_description_query, (employeeComments, productid, ReviewID, EmployeeID)) 


    # Commit the transaction 
    connection.commit() 
    cursor.close() 
    connection.close()  

    return "Employee has inserted comments"
