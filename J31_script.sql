show user
SPOOL C:\DB2\j31_spool.txt;
SELECT to_char(sysdate, 'DD Month YYYY Day HH:MI:SS Am') FROM dual;

SET SERVEROUTPUT ON

-- 1 /IN
-- By default. You can mention the mode IN or leave it as follow
-- CREATE OR REPLACE PROCEDURE name_of_procedure (parameter DATATYPE)
-- We can READ only. The parameter is on the RIGHT side of the assigning operator
-- Ex:
--      SELECT .... INTO .... FROM 
--      WHERE column_name = PARAMETER
--     OR variable := PARAMETER;

-- we pass the parameter with a value
-- Ex:  EXEC name_of_procedure(VALUE)
--          exec p2_q1(10);

-- 2 /OUT
-- You HAVE TO mention the mode OUT as follows:
-- CREATE OR REPLACE PROCEDURE name_of_procedure (parameter OUT DATATYPE)
-- We can WRITE into the parameter only. The parameter is on the LEFT side of the assigning operator
-- Ex:      PARAMETER := VALUE;
--          p_salary_out := 5000;

-- we pass the parameter with a variable
-- Ex:  EXEC name_of_procedure(VARIABLE)
--          exec p2_q1(p_salary_out);

-- Example 1: Create a procedure named p_j31_ex1 that accepts an employee number
-- and sends out the salary of the employe via a parameterof datatype NUMBER

CREATE OR REPLACE PROCEDURE p_j31_ex1(p_empno NUMBER, p_sal_out OUT NUMBER) AS
    v_sal EMP.SAL%TYPE; -- ALTERNATE OF DECLARING A VARIABLE IN RELATION TO A COLUMN IN A TABLE
    BEGIN
        SELECT sal
        INTO v_sal
        FROM EMP
        WHERE empno = p_empno;
        
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('Employee number: ' || p_empno || ' does not exist my friend');
    END;
    /
    
-- Example 2: Create a procedure p_j31_ex2 that accepts an employee number
-- use the procedure of example 1 to display the following:
-- The salary of employee number X is Y
-- Where X is the employee number and Y is the salary sent out by the 
-- procedure p_j31_ex1.

CREATE OR REPLACE PROCEDURE p_j31_ex2(p_empno NUMBER) AS
    v_salary NUMBER;
    BEGIN
        p_j31_ex1(p_empno, v_salary);
        IF v_salary IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE('The salary of employee number ' || p_empno || ' is ' || v_salary || ' my friend Miwa!');
        END IF;
    END;
    /
    
    exec p_j31_ex2(7839);
    
-- 3 /IN OUT
-- You HAVE TO mention the mode IN OUT as follows:
-- CREATE OR REPLACE PROCEDURE name_of_procedure (parameter IN OUT DATATYPE)
-- We can WRITE into the parameter. The parameter is on the LEFT side of the assigning operator
-- Ex:      PARAMETER := VALUE;
--          p_salary_out := 5000;

-- we pass the parameter with a variable
-- Ex:  EXEC name_of_procedure(VARIABLE)
--          exec p2_q1(v_empno_salary_in_out);
-- Example 3: Create a procedure named p_j31_ex3 that has 2 parameters of 
-- mode IN OUT to accept the empno,job and to return salary and the name 
-- of the employee. The procedure will update the employee with the new job 
-- inserted via the second parameter.

CREATE OR REPLACE PROCEDURE p_j31_ex3(p_empno_sal IN OUT NUMBER, p_job_ename IN OUT VARCHAR2) AS
    v_ename emp.ename%TYPE;
    v_sal   emp.sal%TYPE;
    BEGIN
        SELECT ename, sal
        INTO v_ename, v_sal
        FROM emp
        WHERE empno = p_empno_sal;
        
        UPDATE emp SET job = p_job_ename
        WHERE empno = p_empno_sal;
        commit;
        
        p_empno_sal := v_sal;
        p_job_ename := v_ename;
        
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('Employee number: ' || p_empno_sal || ' does not exist my friend');
    END;
    /
    
    
-- Example 4: Create a procedure name p_31_ex4 that accepts an employee 
-- number and a job. Calling the procedure of example 3, the procedure will display the following:
-- With a new job of a X, employee number Y, Mr. Z , earning a salary of $D.
-- Where X = job, Y = empno, Z = enmae, D = salary

CREATE OR REPLACE PROCEDURE p_j31_ex4(p_empno NUMBER, p_job VARCHAR2) AS
    v_empno_sal NUMBER := p_empno;
    v_job_ename VARCHAR2(50) := p_job;
    BEGIN
        p_j31_ex3(v_empno_sal, v_job_ename);
        
        IF v_empno_sal <> p_empno THEN
            DBMS_OUTPUT.PUT_LINE('With a new job as a ' || p_job || '. Employee number ' || p_empno || ', Mr.' || v_job_ename || ' earning a salary of $' || v_empno_sal || ' a month.');
        END IF;
    END;
    /
    
    exec p_j31_ex4(7369, 'PRESIDENT');
    
    
SPOOL OFF;
    
