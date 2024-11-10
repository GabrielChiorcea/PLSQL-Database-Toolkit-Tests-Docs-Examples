 /******************** Operating with Selected Queries    *************************/
 
DECLARE
  v_name   VARCHAR2(50);
  v_salary employees.salary%type;
BEGIN
  SELECT first_name ||' '|| last_name, salary 
  INTO   v_name, v_salary  
  FROM   employees 
  WHERE  employee_id = 130;
  dbms_output.put_line('The salary of '|| v_name || ' is : '|| v_salary);
END;
 
/************************  2 *************************/
DECLARE
  v_name   VARCHAR2(50);
  sysdates employees.hire_date%type;
BEGIN
  SELECT first_name ||' '|| last_name, sysdates 
  INTO   v_name, sysdates 
  FROM   employees 
  WHERE employee_id = 130;
  dbms_output.put_line('The salary of '|| v_name || ' is : '|| sysdates);
END;
 
/************************  3 *************************/
DECLARE
  v_name      VARCHAR2(50);
  v_sysdate   employees.hire_date%type;
  employee_id employees.employee_id%type := 130;
BEGIN 
  SELECT first_name ||' '|| last_name, sysdate 
  INTO   v_name, v_sysdate 
  FROM   employees 
  WHERE  employee_id = employee_id;
  dbms_output.put_line('The salary of '|| v_name || ' is : '|| v_sysdate );
END;
 
/************************  4 *************************/
DECLARE
  v_name        VARCHAR2(50);
  v_salary      employees.salary%type;
  v_employee_id employees.employee_id%type := 130;
BEGIN 
  SELECT first_name ||' '|| last_name, salary 
  INTO   v_name, v_salary 
  FROM   employees 
  WHERE  employee_id = v_employee_id;
  dbms_output.put_line('The salary of '|| v_name || ' is : '|| v_salary );
END;



                       
 /******************* DML Operations in PL/SQL **********************/
 
CREATE TABLE employees_copy 
AS SELECT * FROM employees;
 
DECLARE
  v_employee_id     PLS_INTEGER := 0;
  v_salary_increase NUMBER      := 400;
BEGIN
  FOR i IN 217..226 LOOP
    -- INSERT INTO employees_copy 
    -- (employee_id, first_name, last_name, email, hire_date, job_id, salary)
    -- VALUES
    -- (i, 'employee#'||i,'temp_emp','abc@xmail.com',sysdate,'IT_PROG',1000);
    -- UPDATE employees_copy 
    -- SET    salary = salary + v_salary_increase
    -- WHERE  employee_id = i;
    DELETE FROM employees_copy
    WHERE employee_id = i;
  END LOOP;
END; 
