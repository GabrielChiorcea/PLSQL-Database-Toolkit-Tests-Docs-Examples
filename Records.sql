 /************************ PL/SQL Records ***************************/
 
 
/************************  1 *************************/
DECLARE
  r_emp employees%rowtype;
BEGIN
  SELECT * INTO r_emp 
  FROM   employees 
  WHERE  employee_id = '101';
  --r_emp.salary := 2000;
  dbms_output.put_line(r_emp.first_name || ' '                ||
                       r_emp.last_name  || ' earns '          ||
                       r_emp.salary     || ' and hired at : ' || 
                       r_emp.hire_date);
END;
 
/************************  2 *************************/
DECLARE
  --r_emp employees%rowtype;
  type t_emp IS RECORD (first_name VARCHAR2(50),
                        last_name  employees.last_name%TYPE,
                        salary     employees.salary%TYPE,
                        hire_date  DATE);
  r_emp t_emp;
BEGIN
  SELECT first_name,last_name,salary,hire_date 
  INTO   r_emp 
  FROM   employees 
  WHERE  employee_id = '101';
 
 /* r_emp.first_name := 'Alex';
    r_emp.salary     := 2000;
    r_emp.hire_date  := '01-JAN-20'; */
 
  dbms_output.put_line(r_emp.first_name || ' '                || 
                       r_emp.last_name  || ' earns '          || 
                       r_emp.salary     || ' and hired at : ' || 
                       r_emp.hire_date);
END;
 
/************************  3 *************************/
DECLARE
  TYPE t_edu is RECORD(primary_school    VARCHAR2(100),
                       high_school       VARCHAR2(100),
                       university        VARCHAR2(100),
                       uni_graduate_date DATE
                       );
  
  TYPE t_emp IS RECORD(first_name       VARCHAR2(50),
                       last_name        employees.last_name%type,
                       salary           employees.salary%type  NOT NULL DEFAULT 1000,
                       hire_date        DATE,
                       dept_id          employees.department_id%type,
                       department       departments%rowtype,
                       education        t_edu
                       );
  r_emp t_emp;
BEGIN
  SELECT first_name, last_name, salary, hire_date, department_id 
    INTO r_emp.first_name, r_emp.last_name, r_emp.salary, r_emp.hire_date, r_emp.dept_id 
    FROM employees where employee_id = '146';
  
  SELECT * 
  INTO   r_emp.department 
  FROM   departments 
  WHERE  department_id = r_emp.dept_id;
  
  r_emp.education.high_school       := 'Beverly Hills';
  r_emp.education.university        := 'Oxford';
  r_emp.education.uni_graduate_date := '01-JAN-13'; 
  
  dbms_output.put_line(r_emp.first_name || ' '                || 
                       r_emp.last_name  || ' earns '          || 
                       r_emp.salary     || ' and hired at : ' ||
                       r_emp.hire_date);
  dbms_output.put_line('She graduated from '       || 
                       r_emp.education.university  || 
                       ' at '                      ||  
                       r_emp.education.uni_graduate_date);
  dbms_output.put_line('Her Department Name is : '|| r_emp.department.department_name);
END;
/************************************************************/


create TABLE RET_EMPLOYEES AS SELECT * FROM EMPLOYEES WHERE 1 = 2;

SELECT * FROM RET_EMPLOYEES;


CREATE TABLE retired_employees 
AS SELECT * FROM employees WHERE 1=2;
 
SELECT * FROM retired_employees;

DECLARE
    r_emp employees%rowtype;
BEGIN
    SELECT * 
    INTO   r_emp 
    FROM   employees 
    WHERE  employee_id = 104;
    
    r_emp.salary         := 0;
    r_emp.commission_pct := 0;
    
    INSERT INTO retired_employees VALUES r_emp;
END;

DECLARE
 type e_list is VARRAY(5) of VARCHAR2(50);
 laba e_list;

BEGIN
    laba := e_list('coia', 'boia', 'troia', 'lola', 'troia');
    for i in 1..laba.count() LOOP
        DBMS_OUTPUT.put_line(laba(i));
    end loop;
end;




DECLARE
 type t_list is VARRAY(15) of VARCHAR(255);

 emp t_list := t_list();
 idx NUMBER := 1;

BEGIN
    for i in 100..110 LOOP
        emp.extend;
        SELECT TO_CHAR(EMPLOYEE_ID) into emp(idx) from EMPLOYEES where EMPLOYEE_ID = i;
        idx := idx+1;
    end loop;


    for x in 1..emp.count() loop
        DBMS_OUTPUT.PUT_LINE(emp(x));
    end loop;    
end;
