use [sample_one]

/*

     Created BY : Srinivas Mentula
	 Created_On: 09/17/2025
     Purpose :   Filter the valid PAN nu,mbers only 
*/

IF EXISTS (
select * from sys.tables
where name = 'Employees_pan_numbers'
and schema_id = schema_id('dbo')
)
BEGIN 

DROP  TABLE   dbo.Employees_pan_numbers


CREATE TABLE dbo.Employees_pan_numbers (
    EmployeeID INT PRIMARY KEY,
    PAN_Number VARCHAR(20)
);


INSERT INTO Employees_pan_numbers (EmployeeID, PAN_Number) VALUES
(13, 'ADFPZ1234K'),  --  Valid: 5 letters + 4 digits + 1 letter
(2, 'XYZPC6789K'),  --  Valid: 4th char = P (Individual)
(3, 'PQRSX1234Z'),  --  Valid: 4th char = S (Invalid Category but format okay)
(4, 'ABCD12345Z'),  --  Invalid: Only 4 letters at start instead of 5
(5, 'ABCDE12345'),  --  Invalid: Last char should be a letter
(6, 'AAAAA1111A'),  --  Invalid: First 5 letters identical
(7, 'ABCDE12F45'),  -- 
(8, 'ABcDE1234F'),  -- 
(9, 'LMNOP6789P'),  --  Valid: Category = P
(10,'QRSTU0000A'),  --
(11,'GBAPM3847J');


END

GO ;

CREATE OR ALTER procedure pAN_validation 
AS

BEGIN

drop table if exists #temp_table 
create table #temp_table (
   EmployeeID INT PRIMARY KEY,
    PAN_Number VARCHAR(20)
)

Insert INTO  #temp_table 
SELECT EmployeeID ,
			PAN_Number	
		from  dbo.Employees_pan_numbers

 WHERE (len(PAN_Number) = 10) AND  (PAN_Number  LIKE '[A-Z][A-Z][A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9][A-Z]')

and SUBSTRING(PAN_Number,4,1) in ('P','C','H','A','B','G','J','L','F','T');


WITH CTE_one (Employee_id , Pan_number,validation_result) as 
(

SELECT EmployeeID ,
		PAN_Number,
		dbo.FUNCTION_ONE(PAN_Number) as validation_result
FROM  #temp_table

)
Merge  into Employees_pan_numbers_final  destination USING 
CTE_one as source 
on destination.EmployeeId = source.Employee_id 
when matched then 
update set Pan_Number = source.Pan_number,
			Validation_result = source.validation_result 
when not matched   then
insert
values(Employee_id,Pan_Number,validation_result);
			
END 

go;


CREATE OR ALTER FUNCTION FUNCTION_ONE (@pan_number varchar(10) )
returns varchar(5)
as
begin 

		Declare @length_of_pan  int  = 5,
		@first_five_characters  varchar(max) = left(@pan_number,5),
		@temp_first int = 1 , @temp_second int = 1,
		 @validation_variable  varchar(5)   = 'True' ,
						 @first_character varchar,
						 @second_character varchar
		while @length_of_pan > 1
		begin 
		  SET  @first_character= substring(@first_five_characters,@temp_first,@temp_second)
		  SET @second_character   = substring(@first_five_characters,@temp_first+1,@temp_second)
		  if ((ASCII(@first_character) = ASCII(@second_character)) OR (ASCII(@first_character) =  ASCII(@second_character)-1))
		  begin 
			SET @validation_variable = 'False'
		  break;
		 end 
			set @length_of_pan = @length_of_pan - 1
			 set @temp_first = @temp_first + 1 
		end 
		 return  @validation_variable;
end


