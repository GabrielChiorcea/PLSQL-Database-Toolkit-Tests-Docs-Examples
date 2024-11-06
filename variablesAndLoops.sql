-----------------------===================-----------------------
-----------------------DECLARING VARIABLES-----------------------
-----------------------===================-----------------------
SET SERVEROUTPUT ON;
DECLARE 
    v varchar2(20) := 2 + 25 * 3;
BEGIN
    dbms_output.put_line(v);
END;
-----------------------===================-----------------------
DECLARE 
    v_text varchar2(50) NOT NULL DEFAULT 'Hello';
    v_number1 number := 50;
    v_number2 number(2) := 50.42;
    v_number3 number(10,2) := 50.42;
    v_number4 PLS_INTEGER := 50;
    v_number5 BINARY_float := 50.42;
    v_DATE1 DATE := '22-NOV-18 12:01:32';
    v_DATE2 timestamp := systimestamp;
    v_DATE3 timestamp(9) WITH TIME ZONE := systimestamp;
    v_DATE4 interval day(4) to second (3) := '124 02:05:21.012 ';
    v_DATE5 interval year to month := '12-3';
BEGIN
    V_TEXT := 'PL/SQL' || 'Course';
    DBMS_OUTPUT.PUT_LINE(V_TEXT);
    DBMS_OUTPUT.PUT_LINE(v_number1);
    DBMS_OUTPUT.PUT_LINE(v_number2);
    DBMS_OUTPUT.PUT_LINE(v_number3);
    DBMS_OUTPUT.PUT_LINE(v_number4);
    DBMS_OUTPUT.PUT_LINE(v_number5);
    DBMS_OUTPUT.PUT_LINE(v_DATE1);
    DBMS_OUTPUT.PUT_LINE(v_DATE2);
    DBMS_OUTPUT.PUT_LINE(v_DATE3);
    DBMS_OUTPUT.PUT_LINE(v_DATE4);
    DBMS_OUTPUT.PUT_LINE(v_DATE5);
    END;
----------------==================================---------------
----------------USING BOOLEAN DATA TYPE in PL/SQL----------------
----------------==================================---------------
DECLARE
    v_boolean boolean := true;
BEGIN
    dbms_output.put_line(sys.diutil.bool_to_int(v_boolean));
END;

---------------------%TYPE ATTRIBUTE---------------------
desc employees;
declare
V_TYPE employees.JOB_ID%TYPE;
V_TYPE2 V_TYPE%TYPE;
V_TYPE3 employees.JOB_ID%TYPE ;
begin
v_type := 'IT_PROG';
v_type2 := 'SA_MAN';
v_type3 := NULL;
dbms_output.put_line(v_type);
dbms_output.put_line(v_type2);
dbms_output.put_line('HELLO' || v_type3);
end;
---------------------------------------------------------



/*************** IF ELSIF ELSE ***************
 
/************************ Example 1 *************************/
SET SERVEROUTPUT ON;
DECLARE
  v_number NUMBER := 30;
BEGIN
  IF v_number < 10 THEN
    dbms_output.put_line('I am smaller than 10');
  ELSIF v_number < 20 THEN
    dbms_output.put_line('I am smaller than 20');
  ELSIF v_number < 30 THEN
    dbms_output.put_line('I am smaller than 30');
  ELSE
    dbms_output.put_line('I am equal or greater than 30');
  END IF;
END;
 
/************************ Example 2 *************************/
DECLARE
  v_number NUMBER       := 5;
  v_name   VARCHAR2(30) := 'Adam';
BEGIN
  IF v_number < 10 OR v_name = 'Carol' THEN
    dbms_output.put_line('HI');
    dbms_output.put_line('I am smaller than 10');
  ELSIF v_number < 20 THEN
    dbms_output.put_line('I am smaller than 20');
  ELSIF v_number < 30 THEN
    dbms_output.put_line('I am smaller than 30');
  ELSE
    IF v_number IS NULL THEN
      dbms_output.put_line('The number is null..');
    ELSE
      dbms_output.put_line('I am equal or greater than 30');
    END IF;
  END IF;
END;
/************************************************************/




/****************** Simple Case Expression ******************/
DECLARE
  v_job_code        VARCHAR2(10) := 'SA_MAN';
  v_salary_increase NUMBER;
BEGIN
  v_salary_increase :=  CASE v_job_code 
                         WHEN 'SA_MAN' THEN 0.2
                         WHEN 'SA_REP' THEN 0.3
                        ELSE 0
                        END;
  dbms_output.put_line('Your salary increase is : '|| v_salary_increase);
END;
/************************************************************/
 
/****************** Searched Case Expression ****************/
DECLARE
  v_job_code        VARCHAR2(10) := 'IT_PROG';
  v_department      VARCHAR2(10) := 'IT';
  v_salary_increase NUMBER;
BEGIN
  v_salary_increase:=CASE
                      WHEN v_job_code   = 'SA_MAN' THEN 0.2
                      WHEN v_department = 'IT' AND v_job_code = 'IT_PROG' THEN 0.3
                     ELSE 0
                     END;
  dbms_output.put_line('Your salary increase is : '|| v_salary_increase);
END;
/************************************************************/
 
/********************* CASE Statements **********************/
DECLARE
  v_job_code        VARCHAR2(10) := 'IT_PROG';
  v_department      VARCHAR2(10) := 'IT';
  v_salary_increase NUMBER;
BEGIN
  CASE
    WHEN v_job_code = 'SA_MAN' THEN
      v_salary_increase := 0.2;
      dbms_output.put_line('The salary increase for a Sales Manager is: '|| v_salary_increase);
    WHEN v_department = 'IT' AND v_job_code = 'IT_PROG' THEN
      v_salary_increase := 0.2;
      dbms_output.put_line('The salary increase for a Sales Manager is: '|| v_salary_increase);
    ELSE
      v_salary_increase := 0;
      dbms_output.put_line('The salary increase for this job code is: '|| v_salary_increase);
  END CASE;
END;
/************************************************************/

/*********************** Basic Loops ************************/
DECLARE
  v_counter NUMBER(2) := 1;
BEGIN
  LOOP
    dbms_output.put_line('state is : '|| v_counter);
    v_counter := v_counter + 1;
    IF v_counter = 10 THEN
      dbms_output.put_line('state reached : '|| v_counter);
      EXIT;
    END IF;
    EXIT WHEN v_counter > 10;
  END LOOP;
END;
/************************************************************/


/********************** WHILE LOOP **************************/
DECLARE
  v_counter NUMBER(2) := 1;
BEGIN
  WHILE v_counter <= 10 LOOP
    dbms_output.put_line('My counter is : '|| v_counter);
    v_counter := v_counter + 1;
   -- EXIT WHEN v_counter > 3;
  END LOOP;
END;
/************************************************************/
/************************ FOR LOOP **************************/
BEGIN
  FOR i IN REVERSE 1..3 LOOP
    dbms_output.put_line('My counter is : ' || i);
  END LOOP;
END;
/************************************************************/

/*********************** Nested Loops ***********************/
DECLARE
 v_inner NUMBER := 1;
BEGIN
 FOR v_outer IN 1..5 LOOP
  dbms_output.put_line('My outer value is : ' || v_outer );
    v_inner := 1;
    LOOP
      v_inner := v_inner+1;
      dbms_output.put_line('  My inner value is : ' || v_inner );
      EXIT WHEN v_inner * v_outer >= 15;
    END LOOP;
 END LOOP;
END;
/************************************************************/
 
/**************** Nested Loops with Labels ******************/
DECLARE
 v_inner NUMBER := 1;
BEGIN
<<outer_loop>>
 FOR v_outer IN 1..5 LOOP
  dbms_output.put_line('My outer value is : ' || v_outer );
    v_inner := 1;
    <<inner_loop>>
    LOOP
      v_inner := v_inner+1;
      dbms_output.put_line('  My inner value is : ' || v_inner );
      EXIT outer_loop WHEN v_inner * v_outer >= 16;
      EXIT WHEN v_inner * v_outer >= 15;
    END LOOP inner_loop;
 END LOOP outer_loop;
END;
/************************************************************/
/*********************** CONTINUE Statement **************************/
DECLARE
 v_inner NUMBER := 1;
BEGIN
 FOR v_outer IN 1..10 LOOP
  dbms_output.put_line('My outer value is : ' || v_outer );
    v_inner := 1;
    WHILE v_inner * v_outer < 15 LOOP
      v_inner := v_inner + 1;
      CONTINUE WHEN MOD(v_inner * v_outer,3) = 0;
      dbms_output.put_line('  My inner value is : ' || v_inner );
    END LOOP;
 END LOOP;
END;
/************************************************************/


                          
/********************** GOTO Statement **********************/
 
/******** Finding Prime Numbers Using GOTO Statement ********/
DECLARE
  v_searched_number NUMBER  := 22;
  v_is_prime        BOOLEAN := true;
BEGIN
  FOR x IN 2..v_searched_number-1 LOOP
    IF v_searched_number MOD x = 0 THEN
      dbms_output.put_line(v_searched_number|| ' is not a prime number..');
      v_is_prime := false;
      GOTO end_point;
    END IF;
  END LOOP;
  IF v_is_prime THEN 
    dbms_output.put_line(v_searched_number|| ' is a prime number..');
  END IF;
<<end_point>>
  dbms_output.put_line('Check complete..');
END;
 
/************************************************************/
DECLARE
  v_searched_number NUMBER  := 32457;
  v_is_prime        BOOLEAN := TRUE;
  x                 NUMBER  := 2;
BEGIN
  <<start_point>>
    IF v_searched_number MOD x = 0 THEN
      dbms_output.put_line(v_searched_number|| ' is not a prime number..');
      v_is_prime := FALSE;
      GOTO end_point;
    END IF;
  x := x+1;
  IF x = v_searched_number THEN
    GOTO prime_point;
  END IF;
  GOTO start_point;
  <<prime_point>>
  IF v_is_prime THEN
    dbms_output.put_line(v_searched_number || ' is a prime number..');
  END IF;
<<end_point>>
  dbms_output.put_line('Check complete..');
END;
/************************************************************/
