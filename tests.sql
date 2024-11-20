set SERVEROUTPUT on;


DECLARE
    S_NAMES   VARCHAR(20);
    S_SALARY EMPLOYEES.SALARY%TYPE;
BEGIN
    SELECT
        LAST_NAME,
        SALARY INTO S_NAMES,
        S_SALARY
    FROM
        EMPLOYEES
    WHERE
        EMPLOYEE_ID = 100;
    DBMS_OUTPUT.PUT_LINE(S_NAMES);
    DBMS_OUTPUT.PUT_LINE(S_SALARY);
END;


            
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

                     
 /******************** Using Sequences in PL/SQL *********************/
 
/******************** Creating a Sequence *******************/
CREATE SEQUENCE employee_id_seq 
START WITH 207
INCREMENT BY 1;
 
/************************ 1 *************************/
BEGIN
  FOR i IN 1..10 LOOP
    INSERT INTO employees_copy 
      (employee_id,first_name,last_name,email,hire_date,job_id,salary)
    VALUES 
      (employee_id_seq.nextval,'employee#'||employee_id_seq.nextval,'temp_emp','abc@xmail.com',sysdate,'IT_PROG',1000);
  END LOOP;
END; 
 
/************************ 2 *************************/
DECLARE
  v_seq_num NUMBER;
BEGIN
  SELECT employee_id_seq.nextval 
  INTO   v_seq_num 
  FROM   dual;
  dbms_output.put_line(v_seq_num);
END;
 
/************************ 3 *************************/
DECLARE
  v_seq_num NUMBER;
BEGIN
  SELECT employee_id_seq.nextval 
  INTO   v_seq_num 
  FROM   employees_copy 
  WHERE  rownum = 1;
  dbms_output.put_line(v_seq_num);
END;
 
/************************ 4 *************************/
DECLARE
  v_seq_num NUMBER;
BEGIN
  v_seq_num := employee_id_seq.nextval; 
  dbms_output.put_line(v_seq_num);
END;
 
/************************ 5 *************************/
BEGIN
  dbms_output.put_line(employee_id_seq.nextval);
END;
 
/************************ 6 *************************/
BEGIN
  dbms_output.put_line(employee_id_seq.currval);
END;
                             
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
    laba := e_list('coia', 'boia', 'troia', 'gay', 'troia');
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


                                        
 /********************* Varrays *************************/
 
 
/**************** A Simple Working Example ******************/
DECLARE
  TYPE e_list IS VARRAY(5) OF VARCHAR2(50);
  employees e_list;
BEGIN
  employees := e_list('Alex','Bruce','John','Bob','Richard');
  FOR i IN 1..5 LOOP
    dbms_output.put_line(employees(i));
  END LOOP;
END;
 
/************** Limit Exceeding Error Example ***************/
DECLARE
  TYPE e_list IS VARRAY(4) OF VARCHAR2(50);
  employees e_list;
BEGIN
  employees := e_list('Alex','Bruce','John','Bob','Richard');
  FOR i IN 1..5 LOOP
    dbms_output.put_line(employees(i));
  END LOOP;
END;
 
/*********** Subscript Beyond Count Error Example ***********/
DECLARE
  TYPE e_list IS VARRAY(5) OF VARCHAR2(50);
  employees e_list;
BEGIN
  employees := e_list('Alex','Bruce','John','Bob');
  FOR i IN 1..5 LOOP
    dbms_output.put_line(employees(i));
  end loop;
END;
 
/**************** A Working count() Example *****************/
DECLARE
  TYPE e_list IS VARRAY(5) OF VARCHAR2(50);
  employees e_list;
BEGIN
  employees := e_list('Alex','Bruce','John','Bob');
  for i IN 1..employees.count() LOOP
    dbms_output.put_line(employees(i));
  END LOOP;
END;
 
/************ A Working first() last() Example **************/
DECLARE
  TYPE e_list IS VARRAY(5) OF VARCHAR2(50);
  employees e_list;
BEGIN
  employees := e_list('Alex','Bruce','John','Bob');
  FOR i IN employees.first()..employees.last() LOOP
    dbms_output.put_line(employees(i));
  END LOOP;
END;
 
/*************** A Working exists() Example *****************/
DECLARE
  TYPE e_list IS VARRAY(5) OF VARCHAR2(50);
  employees e_list;
BEGIN
  employees := e_list('Alex','Bruce','John','Bob');
  FOR i IN 1..5 LOOP
    IF employees.exists(i) THEN
      dbms_output.put_line(employees(i));
    END IF;
  END LOOP;
END;
 
/**************** A Working limit() Example *****************/
DECLARE
  TYPE e_list IS VARRAY(5) OF VARCHAR2(50);
  employees e_list;
BEGIN
  employees := e_list('Alex','Bruce','John','Bob');
  dbms_output.put_line(employees.limit());
END;
 
/****** A Create-Declare at the Same Time Error Example *****/
DECLARE
  TYPE e_list IS VARRAY(5) OF VARCHAR2(50);
  employees e_list('Alex','Bruce','John','Bob');
BEGIN
  --employees := e_list('Alex','Bruce','John','Bob');
  FOR i IN 1..5 LOOP
    IF employees.exists(i) THEN
       dbms_output.put_line(employees(i));
    END IF;
  END LOOP;
END;
 
/************** A Post Insert Varray Example ****************/
DECLARE
  TYPE e_list IS VARRAY(15) OF VARCHAR2(50);
  employees e_list := e_list();
  idx NUMBER := 1;
BEGIN
  FOR i IN 100..110 LOOP
    employees.extend;
    SELECT first_name 
    INTO   employees(idx) 
    FROM   employees 
    WHERE  employee_id = i;
    idx := idx + 1;
  END LOOP;
  FOR x IN 1..employees.count() LOOP
    dbms_output.put_line(employees(x));
  END LOOP;
END;
 
/******* An Example for the Schema-Level Varray Types *******/
CREATE TYPE e_list IS VARRAY(15) OF VARCHAR2(50);
/
CREATE OR REPLACE TYPE e_list AS VARRAY(20) OF VARCHAR2(100);
/
DECLARE
  employees e_list := e_list();
  idx       NUMBER := 1;
BEGIN
 
  FOR i IN 100..110 LOOP
    employees.extend;
    SELECT first_name 
    INTO employees(idx) 
    FROM employees 
    WHERE employee_id = i;
    idx := idx + 1;
  END LOOP;
  
  FOR x IN 1..employees.count() LOOP
    dbms_output.put_line(employees(x));
  END LOOP;
 
END;
/
DROP TYPE E_LIST;


/************************ Nested Tables *************************/
 
/*********** The Simple Usage of Nested Tables **************/
DECLARE
  TYPE e_list IS TABLE OF VARCHAR2(50);
  emps e_list;
BEGIN
  emps := e_list('Alex','Bruce','John');
  FOR i IN 1..emps.count() LOOP
    dbms_output.put_line(emps(i));
  END LOOP;
END;
 
/************************************************************
Adding a New Value to a Nested Table After the Initialization
*************************************************************/
DECLARE
  TYPE e_list IS TABLE OF VARCHAR2(50);
  emps e_list;
BEGIN
  emps := e_list('Alex','Bruce','John');
  emps.extend;
  emps(4) := 'Bob';
  FOR i IN 1..emps.count() LOOP
    dbms_output.put_line(emps(i));
  END LOOP;
END;
 
/*************** Adding Values From a Table *****************/
DECLARE
  TYPE e_list IS TABLE OF employees.first_name%type;
  emps e_list := e_list();
  idx  PLS_INTEGER:= 1;
BEGIN
  FOR x IN 100 .. 110 LOOP
    emps.extend;
    SELECT first_name INTO emps(idx) 
    FROM   employees 
    WHERE  employee_id = x;
    idx := idx + 1;
  END LOOP;
  FOR i IN 1..emps.count() LOOP
    dbms_output.put_line(emps(i));
  END LOOP;
END;
 
/********************* Delete Example ***********************/
DECLARE
  TYPE e_list IS TABLE OF employees.first_name%type;
  emps e_list := e_list();
  idx  PLS_INTEGER := 1;
BEGIN
  FOR x IN 100 .. 110 LOOP
    emps.extend;
    SELECT first_name INTO emps(idx) 
    FROM   employees 
    WHERE  employee_id = x;
    idx := idx + 1;
  END LOOP;
  emps.delete(3);
  FOR i IN 1..emps.count() LOOP
    IF emps.exists(i) THEN 
       dbms_output.put_line(emps(i));
    END IF;
  END LOOP;
END;






                            
 /********************* Associative Arrays  ***********************/
 
/********************* The First Example ********************/
DECLARE
  TYPE e_list IS TABLE OF employees.first_name%TYPE INDEX BY PLS_INTEGER;
  emps e_list;
BEGIN
  FOR x IN 100 .. 110 LOOP
    SELECT first_name 
    INTO   emps(x) 
    FROM   employees 
    WHERE  employee_id = x ;
  END LOOP;
  FOR i IN emps.first()..emps.last() LOOP
    dbms_output.put_line(emps(i));
  END LOOP; 
END;
 
/********* Error Example for the SELECT INTO Clause *********/
DECLARE
  TYPE e_list IS TABLE OF employees.first_name%TYPE INDEX BY PLS_INTEGER;
  emps e_list;
BEGIN
  FOR x IN 100 .. 110 LOOP
    SELECT first_name 
    INTO   emps(x) 
    FROM   employees 
    WHERE  employee_id   = x 
    AND    department_id = 60;
  END LOOP;
  FOR i IN emps.first()..emps.last() LOOP
    dbms_output.put_line(i);
  END LOOP; 
END;
 
/******* Error Example about Reaching an Empty Index ********/
DECLARE
  TYPE e_list IS TABLE OF employees.first_name%TYPE INDEX BY PLS_INTEGER;
  emps e_list;
BEGIN
  emps(100) := 'Bob';
  emps(120) := 'Sue';
  FOR i IN emps.first()..emps.last() LOOP
    dbms_output.put_line(emps(i));
  END LOOP; 
END;
 
/*************************************************************
An Example of Iterating in Associative Arrays with WHILE LOOPs
*************************************************************/
DECLARE
  TYPE e_list IS TABLE OF employees.first_name%TYPE INDEX BY PLS_INTEGER;
  emps e_list;
  idx  PLS_INTEGER;
BEGIN
  emps(100) := 'Bob';
  emps(120) := 'Sue';
  idx       := emps.first;
 
  WHILE idx IS NOT NULL LOOP 
    dbms_output.put_line(emps(idx));
    idx := emps.next(idx);
  END LOOP; 
END;
 
/*************************************************************
An Example of Using String-based Indexes with Associative Arrays
*************************************************************/
DECLARE
  TYPE e_list IS TABLE OF employees.first_name%TYPE INDEX BY employees.email%type;
  emps         e_list;
  idx          employees.email%TYPE;
  v_email      employees.email%TYPE;
  v_first_name employees.first_name%TYPE;
BEGIN
  FOR x IN 100 .. 110 LOOP
    SELECT first_name, email 
    INTO   v_first_name, v_email 
    FROM   employees
    WHERE  employee_id = x;
    emps(v_email) := v_first_name;
  END LOOP;
 
  idx := emps.first;
  WHILE idx IS NOT NULL LOOP 
    dbms_output.put_line('The email of '|| emps(idx) ||' is : '|| idx);
    idx := emps.next(idx);
  END LOOP; 
END;
 
/*** An Example of Using Associative Arrays with Records ****/
DECLARE
  TYPE e_list IS TABLE OF employees%rowtype INDEX BY employees.email%TYPE;
  emps e_list;
  idx  employees.email%type;
BEGIN
  FOR x IN 100 .. 110 LOOP
    SELECT * 
    INTO   emps(x) 
    FROM   employees
    WHERE  employee_id = x;
  END LOOP;
 
  idx := emps.first;
  
  WHILE idx IS NOT NULL LOOP 
    dbms_output.put_line('The email of '      || 
                         emps(idx).first_name || ' '     ||
                         emps(idx).last_name  || ' is : '|| emps(idx).email);
    idx := emps.next(idx);
  END LOOP; 
END;
 
/* An Example of Using Associative Arrays with Record Types */
DECLARE
  TYPE e_type IS RECORD (first_name employees.first_name%TYPE,
                         last_name  employees.last_name%TYPE,
                         email      employees.email%TYPE);
  TYPE e_list IS TABLE OF e_type INDEX BY employees.email%TYPE;
  emps e_list;
  idx  employees.email%type;
BEGIN
  FOR x IN 100 .. 110 LOOP
    SELECT first_name,last_name,email 
    INTO   emps(x) 
    FROM   employees
    WHERE  employee_id = x;
  END LOOP;
 
  idx := emps.first;
 
  WHILE idx IS NOT NULL LOOP
    dbms_output.put_line('The email of '       || 
                          emps(idx).first_name || ' ' ||
                          emps(idx).last_name  || ' is : ' || 
                          emps(idx).email);
    idx := emps.next(idx);
  END LOOP; 
END;
 
/**** An Example of Printing From the Last to the First *****/
DECLARE
  TYPE e_type IS RECORD (first_name employees.first_name%TYPE,
                         last_name  employees.last_name%TYPE,
                         email      employees.email%TYPE);
  TYPE e_list IS TABLE OF e_type INDEX BY employees.email%TYPE;
  emps e_list;
  idx  employees.email%type;
BEGIN
  FOR x IN 100 .. 110 LOOP
    SELECT first_name,last_name, email 
    INTO   emps(x) 
    FROM   employees
    WHERE  employee_id = x;
  END LOOP;
  
  --emps.delete(100,104);
  idx := emps.last;
  
  WHILE idx IS NOT NULL LOOP 
    dbms_output.put_line('The email of '       || 
                          emps(idx).first_name || ' '     ||
                          emps(idx).last_name  ||' is : ' || 
                          emps(idx).email);
    idx := emps.prior(idx);
  END LOOP; 
END;
 
/***** An Example of Inserting with Associative Arrays ******/
CREATE TABLE employees_salary_history 
AS SELECT * FROM employees WHERE 1=2;
 
ALTER TABLE employees_salary_history ADD insert_date DATE;
 
SELECT * FROM employees_salary_history;
/
DECLARE
  TYPE e_list IS TABLE OF employees_salary_history%rowtype INDEX BY PLS_INTEGER;
  emps e_list;
  idx  PLS_INTEGER;
BEGIN
  FOR x IN 100 .. 110 LOOP
    SELECT e.*,'01-JUN-20' 
    INTO   emps(x) 
    FROM   employees e
    WHERE  employee_id = x;
  END LOOP;
  
  idx := emps.first;
  
  WHILE idx IS NOT NULL LOOP 
    emps(idx).salary := emps(idx).salary + emps(idx).salary*0.2;
    INSERT INTO employees_salary_history VALUES emps(idx);
    dbms_output.put_line('The employee '       || emps(idx).first_name ||
                         ' is inserted to the history table');
    idx := emps.next(idx);
  END LOOP; 
END;
/
DROP TABLE employees_salary_history;


DECLARE
    TYPE e_list is table of EMPLOYEES%rowTYPE INDEX by EMPLOYEES.EMAIL%type;
    emps e_list;
    idx EMPLOYEES.EMAIL%type;
    v_email EMPLOYEES.EMAIL%type;
    v_fisrt_name EMPLOYEES.first_name%type;

BEGIN
    for i in 100..110 LOOP
    select * into emps(i) from EMPLOYEES where EMPLOYEE_ID = i;
    END LOOP;

    idx := emps.first;
    while idx is not null loop
     DBMS_OUTPUT.PUT_LINE(emps(idx).email);
     idx := emps.next(idx);
    end loop;
end;


create table EMPLOYEES_HIS as select * from EMPLOYEES where 1 =2;
alter table EMPLOYEES_HIS add insert_date date;
select insert_date from EMPLOYEES_HIS;


DECLARE
    type e_list is table of EMPLOYEES_HIS%rowtype index by PLS_INTEGER;
    emps e_list;
    idx PLS_INTEGER;
BEGIN
    for i in 100..110 LOOP
        select e.*,'01-JUN-20' into emps(i) from EMPLOYEES e where EMPLOYEE_ID = i;
    END loop;

    idx := emps.first;

    WHILE idx is not null LOOP
        emps(idx).salary :=  emps(idx).salary +  emps(idx).salary*0.3;
        insert into EMPLOYEES_HIS VALUES emps(idx);
        idx := emps.next(idx);
    END loop;
end;


CREATE OR REPLACE TYPE T_PF_NR AS
  OBJECT (
    P_TYPE VARCHAR2(20),
    P_NUMBER VARCHAR2(50)
  );

  CREATE OR REPLACE TYPE V_PHONE_NUMBER AS VARRAY(
    3
  ) OF T_PF_NR;

  CREATE TABLE EMPS_WITH_PHONES (
    EMPLO_ID NUMBER,
    FIRST_NAME VARCHAR2(50),
    PHONE_NUMBER V_PHONE_NUMBER
  );

  INSERT INTO EMPS_WITH_PHONES VALUES(
    10,
    'Coia',
    V_PHONE_NUMBER(T_PF_NR('Home', '111.111.11.11'), T_PF_NR('tel', '08335563838'), T_PF_NR('fax', '232323232323'))
  );

  SELECT
    *
  FROM
    EMPS_WITH_PHONES;
    drop table EMPS_WITH_PHONES;



 /******************** Storing Collections in Tables *******************/
 
/***************** Storing Varray Example *******************/
CREATE OR REPLACE TYPE t_phone_number AS OBJECT(p_type   VARCHAR2(10), 
                                                p_number VARCHAR2(50)
                                               );
/
CREATE OR REPLACE TYPE v_phone_numbers AS VARRAY(3) OF t_phone_number;
/
CREATE TABLE emps_with_phones(employee_id  NUMBER,
                              first_name   VARCHAR2(50),
                              last_name    VARCHAR2(50),
                              phone_number v_phone_numbers);
/
SELECT * FROM emps_with_phones;
/
INSERT INTO emps_with_phones
VALUES(10,'Alex','Brown',v_phone_numbers(t_phone_number('HOME','111.111.1111'),
                                         t_phone_number('WORK','222.222.2222'),
                                         t_phone_number('MOBILE','333.333.3333'))
                                         );
INSERT INTO emps_with_phones
VALUES(11,'Bob','Green',v_phone_numbers(t_phone_number('HOME','000.000.000'),
                                         t_phone_number('WORK','444.444.4444'))
                                         );                                                                
/
 
/*************** Querying the Varray Example ****************/
SELECT e.first_name,
       last_name,
       p.p_type,
       p.p_number 
FROM emps_with_phones e, table(e.phone_number) p;
 
 
/****** The Code For the Storing Nested Table Example *******/
CREATE OR REPLACE TYPE n_phone_numbers AS TABLE OF t_phone_number;
/
CREATE TABLE emps_with_phones2(employee_id  NUMBER,
                               first_name   VARCHAR2(50),
                               last_name    VARCHAR2(50),
                               phone_number n_phone_numbers)
                               NESTED TABLE phone_number STORE AS phone_numbers_table;
/
SELECT * FROM emps_with_phones2;
/
INSERT INTO emps_with_phones2 
VALUES(10,'Alex','Brown',n_phone_numbers(t_phone_number('HOME','111.111.1111'),
                                         t_phone_number('WORK','222.222.2222'),
                                         t_phone_number('MOBILE','333.333.3333'))
                                         );
INSERT INTO emps_with_phones2
VALUES(11,'Bob','Green',n_phone_numbers(t_phone_number('HOME','000.000.000'),
                                        t_phone_number('WORK','444.444.4444'))
                                        );      
/
SELECT e.first_name, last_name, p.p_type, p.p_number 
FROM emps_with_phones2 e, table(e.phone_number) p;
 
/***************** New Insert and Update ********************/
INSERT INTO emps_with_phones2 
VALUES(11,'Bob','Green',n_phone_numbers(t_phone_number('HOME','000.000.000'),
                                        t_phone_number('WORK','444.444.4444'),
                                        t_phone_number('WORK2','444.444.4444'),
                                        t_phone_number('WORK3','444.444.4444'),
                                        t_phone_number('WORK4','444.444.4444'),
                                        t_phone_number('WORK5','444.444.4444'))
                                        );    
SELECT * FROM emps_with_phones2;
 
UPDATE emps_with_phones2 
SET phone_number = n_phone_numbers(t_phone_number('HOME','000.000.000'),
                                   t_phone_number('WORK','444.444.4444'),
                                   t_phone_number('WORK2','444.444.4444'),
                                   t_phone_number('WORK3','444.444.4444'),
                                   t_phone_number('WORK4','444.444.4444'),
                                   t_phone_number('WORK5','444.444.4444'))
WHERE employee_id = 11;

SELECT e.first_name, last_name, p.p_type, p.p_number 
FROM emps_with_phones2 e, table(e.phone_number) p WHERE employee_id = 11;

/**** Adding a New Value into a Nested Inside of a Table ****/
DECLARE
  p_num n_phone_numbers;
BEGIN
  SELECT phone_number 
  INTO   p_num 
  FROM   emps_with_phones2 
  WHERE  employee_id = 10;
  
  p_num.extend;
  p_num(6) := t_phone_number('FAX','999.99.9999');
  
  UPDATE emps_with_phones2 
  SET    phone_number = p_num
  WHERE  employee_id  = 10;
END;
/************************************************************/



/********************* Cursor **************************/

declare
  cursor c_emps is select first_name,last_name from employees;
  v_first_name employees.first_name%type;
  v_last_name employees.last_name%type;
begin
  open c_emps;
  fetch c_emps into v_first_name,v_last_name;
  fetch c_emps into v_first_name,v_last_name;
  fetch c_emps into v_first_name,v_last_name;
  dbms_output.put_line(v_first_name|| ' ' || v_last_name);
  fetch c_emps into v_first_name,v_last_name;
  dbms_output.put_line(v_first_name|| ' ' || v_last_name);
  close c_emps;
end;
--------------- cursor with join example
declare
  cursor c_emps is select first_name,last_name, department_name from employees
                      join departments using (department_id)
                      where department_id between 30 and 60;
  v_first_name employees.first_name%type;
  v_last_name employees.last_name%type;
  v_department_name departments.department_name%type;
begin
  open c_emps;
  fetch c_emps into v_first_name, v_last_name,v_department_name;
  dbms_output.put_line(v_first_name|| ' ' || v_last_name|| ' in the department of '|| v_department_name);
  close c_emps;
end;


/******************** Cursors with Records **********************/


declare
  type r_emp is record (  v_first_name employees.first_name%type,
                           v_last_name employees.last_name%type);
  v_emp r_emp;
  cursor c_emps is select first_name,last_name from employees;
begin
  open c_emps;
  fetch c_emps into v_emp;
  dbms_output.put_line(v_emp.v_first_name|| ' ' || v_emp.v_last_name);
  close c_emps;
end;
--------------- An example for using cursors table rowtype
declare
  v_emp employees%rowtype;
  cursor c_emps is select first_name,last_name from employees;
begin
  open c_emps;
  fetch c_emps into v_emp.first_name,v_emp.last_name;
  dbms_output.put_line(v_emp.first_name|| ' ' || v_emp.last_name);
  close c_emps;
end;
--------------- An example for using cursors with cursor%rowtype.
declare
  cursor c_emps is select first_name,last_name from employees;
  v_emp c_emps%rowtype;
begin
  open c_emps;
  fetch c_emps into v_emp.first_name,v_emp.last_name;
  dbms_output.put_line(v_emp.first_name|| ' ' || v_emp.last_name);
  close c_emps;
end;


/******************** Looping with Cursors **********************/
declare
  cursor c_emps is select * from employees where department_id = 30;
  v_emps c_emps%rowtype;
begin
  open c_emps;
  loop
    fetch c_emps into v_emps;
    dbms_output.put_line(v_emps.employee_id|| ' ' ||v_emps.first_name|| ' ' ||v_emps.last_name);
  end loop;
  close c_emps;
end; 
---------------%notfound example
declare
  cursor c_emps is select * from employees where department_id = 30;
  v_emps c_emps%rowtype;
begin
  open c_emps;
  loop
    fetch c_emps into v_emps;
    exit when c_emps%notfound;
    dbms_output.put_line(v_emps.employee_id|| ' ' ||v_emps.first_name|| ' ' ||v_emps.last_name);
  end loop;
  close c_emps;
end;
---------------while loop example
declare
  cursor c_emps is select * from employees where department_id = 30;
  v_emps c_emps%rowtype;
begin
  open c_emps;
  fetch c_emps into v_emps;
  while c_emps%found loop
    dbms_output.put_line(v_emps.employee_id|| ' ' ||v_emps.first_name|| ' ' ||v_emps.last_name);
    fetch c_emps into v_emps;
    --exit when c_emps%notfound;
  end loop;
  close c_emps;
end;
---------------for loop with cursor example
declare
  cursor c_emps is select * from employees where department_id = 30;
  v_emps c_emps%rowtype;
begin
  open c_emps;
  for i in 1..6 loop
    fetch c_emps into v_emps;
    dbms_output.put_line(v_emps.employee_id|| ' ' ||v_emps.first_name|| ' ' ||v_emps.last_name);
  end loop;
  close c_emps;
end;
---------------FOR..IN clause example
declare
  cursor c_emps is select * from employees where department_id = 30;
begin
  for i in c_emps loop
    dbms_output.put_line(i.employee_id|| ' ' ||i.first_name|| ' ' ||i.last_name);
  end loop;
end;
---------------FOR..IN with select example
begin
  for i in (select * from employees where department_id = 30) loop
    dbms_output.put_line(i.employee_id|| ' ' ||i.first_name|| ' ' ||i.last_name);
  end loop;
end;


/********************* PL SQL Cursors with Parameters **************************/


declare
  cursor c_emps (p_dept_id number) is select first_name,last_name,department_name 
                    from employees join departments using (department_id)
                    where department_id = p_dept_id;
  v_emps c_emps%rowtype;
begin
  open c_emps(20);
  fetch c_emps into v_emps;
    dbms_output.put_line('The employees in department of '|| v_emps.department_name|| ' are :');
    close c_emps;
  open c_emps(20);
    loop
      fetch c_emps into v_emps;
      exit when c_emps%notfound;
      dbms_output.put_line(v_emps.first_name|| ' ' ||v_emps.last_name);
    end loop;
  close c_emps;
end;
--------------- bind variables as parameters
declare
  cursor c_emps (p_dept_id number) is select first_name,last_name,department_name 
                    from employees join departments using (department_id)
                    where department_id = p_dept_id;
  v_emps c_emps%rowtype;
begin
  open c_emps(:b_emp);
  fetch c_emps into v_emps;
    dbms_output.put_line('The employees in department of '|| v_emps.department_name|| ' are :');
    close c_emps;
  open c_emps(:b_emp);
    loop
      fetch c_emps into v_emps;
      exit when c_emps%notfound;
      dbms_output.put_line(v_emps.first_name|| ' ' ||v_emps.last_name);
    end loop;
  close c_emps;
end;
---------------cursors with two different parameters
declare
  cursor c_emps (p_dept_id number) is select first_name,last_name,department_name 
                    from employees join departments using (department_id)
                    where department_id = p_dept_id;
  v_emps c_emps%rowtype;
begin
  open c_emps(:b_dept_id);
  fetch c_emps into v_emps;
    dbms_output.put_line('The employees in department of '|| v_emps.department_name|| ' are :');
    close c_emps;
  open c_emps(:b_dept_id);
    loop
      fetch c_emps into v_emps;
      exit when c_emps%notfound;
      dbms_output.put_line(v_emps.first_name|| ' ' ||v_emps.last_name);
    end loop;
  close c_emps;
  
  open c_emps(:b_dept_id2);
  fetch c_emps into v_emps;
    dbms_output.put_line('The employees in department of '|| v_emps.department_name|| ' are :');
    close c_emps;
  open c_emps(:b_dept_id2);
    loop
      fetch c_emps into v_emps;
      exit when c_emps%notfound;
      dbms_output.put_line(v_emps.first_name|| ' ' ||v_emps.last_name);
    end loop;
  close c_emps;
end;
--------------- cursor with parameters - for in loops
declare
  cursor c_emps (p_dept_id number) is select first_name,last_name,department_name 
                    from employees join departments using (department_id)
                    where department_id = p_dept_id;
  v_emps c_emps%rowtype;
begin
  open c_emps(:b_dept_id);
  fetch c_emps into v_emps;
    dbms_output.put_line('The employees in department of '|| v_emps.department_name|| ' are :');
    close c_emps;
  open c_emps(:b_dept_id);
    loop
      fetch c_emps into v_emps;
      exit when c_emps%notfound;
      dbms_output.put_line(v_emps.first_name|| ' ' ||v_emps.last_name);
    end loop;
  close c_emps;
  
  open c_emps(:b_dept_id2);
  fetch c_emps into v_emps;
    dbms_output.put_line('The employees in department of '|| v_emps.department_name|| ' are :');
    close c_emps;
    
    for i in c_emps(:b_dept_id2) loop
      dbms_output.put_line(i.first_name|| ' ' ||i.last_name);
    end loop;
end;
---------------cursors with multiple parameters
declare
  cursor c_emps (p_dept_id number , p_job_id varchar2) is select first_name,last_name,job_id,department_name 
                    from employees join departments using (department_id)
                    where department_id = p_dept_id
                    and job_id = p_job_id;
  v_emps c_emps%rowtype;
begin
    for i in c_emps(50,'ST_MAN') loop
      dbms_output.put_line(i.first_name|| ' ' ||i.last_name|| ' - ' || i.job_id);
    end loop;
    dbms_output.put_line(' - ');
    for i in c_emps(80,'SA_MAN') loop
      dbms_output.put_line(i.first_name|| ' ' ||i.last_name|| ' - ' || i.job_id);
    end loop;
end;
--------------- An error example of using parameter name with the column name
declare
  cursor c_emps (p_dept_id number , job_id varchar2) is select first_name,last_name,job_id,department_name 
                    from employees join departments using (department_id)
                    where department_id = p_dept_id
                    and job_id = job_id;
  v_emps c_emps%rowtype;
begin
    for i in c_emps(50,'ST_MAN') loop
      dbms_output.put_line(i.first_name|| ' ' ||i.last_name|| ' - ' || i.job_id);
    end loop;
    dbms_output.put_line(' - ');
    for i in c_emps(80,'SA_MAN') loop
      dbms_output.put_line(i.first_name|| ' ' ||i.last_name|| ' - ' || i.job_id);
    end loop;
end;


------------------------------PL SQL Cursor Attributes

declare
  cursor c_emps is select * from employees where department_id = 50;
  v_emps c_emps%rowtype;
begin
  if not c_emps%isopen then
    open c_emps;
    dbms_output.put_line('hello');
  end if;
  dbms_output.put_line(c_emps%rowcount);
  fetch c_emps into v_emps;
  dbms_output.put_line(c_emps%rowcount);
  dbms_output.put_line(c_emps%rowcount);
  fetch c_emps into v_emps;
  dbms_output.put_line(c_emps%rowcount);
  close c_emps;
  
  open c_emps;
    loop
      fetch c_emps into v_emps;
      exit when c_emps%notfound or c_emps%rowcount>5;
      dbms_output.put_line(c_emps%rowcount|| ' ' ||v_emps.first_name|| ' ' ||v_emps.last_name);
    end loop;
  close c_emps;
end;


------------------------------------For Update Clause
declare
  cursor c_emps is select employee_id,first_name,last_name,department_name
      from employees_copy join departments using (department_id)
      where employee_id in (100,101,102)
      for update;
begin
  /* for r_emps in c_emps loop
    update employees_copy set phone_number = 3
      where employee_id = r_emps.employee_id; 
  end loop; */
  open c_emps;
end;
--------------- example of wait with second
declare
  cursor c_emps is select employee_id,first_name,last_name,department_name
      from employees_copy join departments using (department_id)
      where employee_id in (100,101,102)
      for update of employees_copy.phone_number, 
      departments.location_id wait 5;
begin
  /* for r_emps in c_emps loop
    update employees_copy set phone_number = 3
      where employee_id = r_emps.employee_id; 
  end loop; */
  open c_emps;
end;
---------------example of nowait
declare
  cursor c_emps is select employee_id,first_name,last_name,department_name
      from employees_copy join departments using (department_id)
      where employee_id in (100,101,102)
      for update of employees_copy.phone_number, 
      departments.location_id nowait;
begin
  /* for r_emps in c_emps loop
    update employees_copy set phone_number = 3
      where employee_id = r_emps.employee_id; 
  end loop; */
  open c_emps;
end;







select * from employee_salary;

DECLARE
  FUNCTION get_employee( emp_id EMPLOYEES.EMPLOYEE_ID%type) RETURN  EMPLOYEES%rowtype IS
  emp EMPLOYEES%rowtype;
begin
   select * into emp FROM EMPLOYEES where EMPLOYEE_ID = emp_id;
   
   RETURN emp;
end;



  PROCEDURE insert_employee_salary (emp_id_from_function EMPLOYEES.EMPLOYEE_ID%type) IS
  emp EMPLOYEES%rowtype;
BEGIN
  emp := get_employee(emp_id_from_function);
  INSERT into employee_salary values emp;
end;



begin 
  for emp_sal in (select * from EMPLOYEES) loop
    if emp_sal.salary > 15000 then
      insert_employee_salary(emp_sal.employee_id);
    end if;
    end loop;
end;   

/

create or replace procedure console( txt in VARCHAR2) is
  BEGIN
    DBMS_OUTput.put_line(txt);
  END;  
  


 create or REPLACE function get_emp(emp_num EMPLOYEES.EMPLOYEE_ID%type) return EMPLOYEES%rowtype IS
    emp EMPLOYEES%rowtype;
BEGIN
    SELECT * into emp from EMPLOYEES where EMPLOYEE_ID = emp_num;
    RETURN emp;

    EXCEPTION
      WHEN no_data_found THEN
        console('aia e');
        RETURN null;
end;    
  

DECLARE 
  v_emp EMPLOYEES%rowtype;
BEGIN
  v_emp := get_emp(10);
  console(v_emp.first_name);
end;


create type t_days as OBJECT(

  v_date date,
  v_day_number int
);

create type t_days_tab is table of t_days;

create or REPLACE FUNCTION f_get_days(p_start_date date, p_day_number int)  RETURN t_days_tab PIPELINED IS


begin
  for i in 1..p_day_number LOOP
  PIPE ROW( t_days(p_start_date + 1, TO_NUMBER(TO_CHAR(p_start_date + i, 'DDD'))));
  END LOOP;
  RETURN ;
end ; 


select * from table(f_get_days(SYSDATE, 5));



 create or replace PACKAGE pack as 
  v_salary_increase_rate number := 1000;
  cursor cur_emps is SELECT * from EMPLOYEES;
  PROCEDURE increase_salary;
  function get_avg_sal(p_dept_id int) RETURN NUMBER;

 end pack;


create or replace PACKAGE BODY pack AS
  PROCEDURE increase_salary AS
    BEGIN
      for r1 in cur_emps LOOP
        update EMPLOYEES_COPY set SALARY = SALARY + v_salary_increase_rate;
      end LOOP;
    end increase_salary;
  function get_avg_sal(p_dept_id int) RETURN NUMBER AS
    v_avg_sal NUMBER := 0;
    begin
      SELECT avg(salary) into v_avg_sal from EMPLOYEES_COPY where EMPLOYEE_ID = p_dept_id;
      RETURN v_avg_sal;
    end get_avg_sal;
end pack;  




exec pack.increase_salary;

