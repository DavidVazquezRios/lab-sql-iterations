USE SAKILA;

-- 1 Write a query to find what is the total business done by each store.

SELECT 
    S.store_id, SUM(P.amount) AS total_business
FROM
    store AS S
        JOIN
    staff USING (store_id)
        JOIN
    payment AS P USING (staff_id)
GROUP BY S.store_id
;

--Convert the previous query into a stored procedure.

DELIMITER //
create procedure total_business()
begin
SELECT 
    S.store_id, SUM(P.amount) AS total_business
FROM
    store AS S
        JOIN
    staff USING (store_id)
        JOIN
    payment AS P USING (staff_id)
GROUP BY S.store_id
;
end //
DELIMITER ;

call total_business;

-- Convert the previous query into a stored procedure that takes the input for store_id and displays the total sales for that store.

DELIMITER //
create procedure total_business_store(in idstore int)
begin
SELECT 
    SUM(P.amount) AS total_business
FROM
    store AS S
        JOIN
    staff USING (store_id)
        JOIN
    payment AS P USING (staff_id)
GROUP BY S.store_id
HAVING S.store_id = idstore
;
end //
DELIMITER ;

call total_business_store(2);

-- Update the previous query. Declare a variable total_sales_value of float type, that will store the returned result (of the total sales amount for the store). Call the stored procedure and print the results.

DELIMITER //
create procedure total_business_store_output(in idstore int, out total_sales_value float)
begin
SELECT 
    SUM(P.amount) AS total_business into total_sales_value
FROM
    store AS S
        JOIN
    staff USING (store_id)
        JOIN
    payment AS P USING (staff_id)
GROUP BY S.store_id
HAVING S.store_id = idstore
;
end //
DELIMITER ;

call total_business_store_output(2,@total_sales_value);
select @total_sales_value;

-- In the previous query, add another variable flag. If the total sales value for the store is over 30.000, then label it as green_flag, otherwise label is as red_flag. Update the stored procedure that takes an input as the store_id and returns total sales value for that store and flag value

DELIMITER //
create procedure total_business_store_flag(in idstore int, out total_sales_value float, out flag varchar(20))
begin
SELECT 
    SUM(P.amount) AS total_business into total_sales_value 
FROM
    store AS S
        JOIN
    staff USING (store_id)
        JOIN
    payment AS P USING (staff_id)
GROUP BY S.store_id
HAVING S.store_id = idstore
;
 CASE
     WHEN total_sales_value > 30000 THEN set flag = 'green_flag';
     ELSE set flag = 'red_flag';
	end	case;
end //
DELIMITER ;

call total_business_store_flag(2,@total_sales_value,@flag);
select @total_sales_value,@flag;
