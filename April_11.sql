-- schedule for the day
-- review VIEW
-- INSTEAD OF TRIGGER
-- User define EXCEPTION

-- A VIEW is a select statement but looks like a table.
--  1. for sensitive data
--      Example 1: User SCOTT doesn't want Miwa to access the salary of all
--      employees but he wants Miwa to manipulate the data of the column empno,
--      ename, job, deptno of emp. Create a VIEW named EMPLOYEE and give Miwa
--      full access

-- sys
connect sys/sys as sysdba;
GRANT create view to c##scott;
CREATE USER miwa IDENTIFIED BY 123;
GRANT CONNECT, RESOURCE TO miwa;

CREATE OR REPLACE VIEW employee AS
    SELECT empno, ename, job, deptno
    FROM emp;
    
-- Miwa
    SELECT * FROM c##scott.employee;
    UPDATE c##scott.employee
    SET ename = 'Miwa' WHERE empno = 7934;
    
-- 2. to make the SELECT from multiple tables easier
--  Example: Create a view name employee_detail with columns
--  empno, ename, job, sal, deptno from table emp and dname, loc from table dept.
--  Give Miwa full access to th eview to test for the update of the dname and loc.
CREATE OR REPLACE VIEW employee_detail AS
    SELECT empno, ename, job, sal, d.deptno, dname, loc
    FROM emp e, dept d
    WHERE e.deptno = d.deptno;
    
    UPDATE employee_detail
    SET job = 'MANAGER'
    WHERE empno = 7934;
    
    UPDATE employee_detail
    SET loc = 'Montreal'
    WHERE deptno = 10;
    
    
------------------------ INSTEAD OF TRIGGER ----------------------------------

-- SYNTAX
-- CREATE OR REPLACE TRIGGER name_of_trigger
-- INSTEAD OF INSERT | UPDATE | DELETE ON name_of_view
-- FOR EACH ROW
--  BEGIN
--      EXECUTE TABLE STATEMENT;
--  END;
--  /

-- Example 3: Create an INSTEAD OF TRIGGER for the view of example 2 so that 
-- we could UPDATE all the data of all the columns of the view.

CREATE OR REPLACE TRIGGER emp_detail_trigger
INSTEAD OF UPDATE ON employee_detail
FOR EACH ROW
    BEGIN
        UPDATE emp
        SET ename = :NEW.ename, job = :NEW.job, sal = :NEW.sal
        WHERE empno = :NEW.empno;
        
        UPDATE dept
        SET dname = :NEW.dname, loc = :NEW.loc
        WHERE deptno = :NEW.deptno;
    END;
    /
    
-- TESTING
UPDATE employee_detail
SET job = 'Special C'
WHERE empno = 7934;


UPDATE employee_detail
SET loc = 'Montreal'
WHERE deptno = 10; 

--------------------------- User define EXCEPTION -----------------------------
-- Pre-defined exception
--  NO_DATA_FOUND, TOO_MANY_ROW.......

-- Example: Create a procedure that accepts an employee number to display the name and salary of all employees.
-- The salary which are greater than 4000 is considered as an EXCEPTION, create a 
-- user-define EXCEPTION to handle this exception by displaying below:
SET SERVEROUTPUT ON
CREATE OR REPLACE PROCEDURE last_example(p_empno emp.empno%TYPE) AS
    v_ename emp.ename%TYPE;
    v_sal emp.sal%TYPE;
    e_high_salary EXCEPTION;
    BEGIN
        SELECT ename, sal
        INTO v_ename, v_sal
        FROM emp
        WHERE empno = p_empno;
        
        IF v_sal >= 4000 THEN
            RAISE e_high_salary;
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('Employee Number ' || p_empno || ' is ' || v_ename || ' earning a salary of $'
        || v_sal || ' a day.');
        
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('Employee Number ' || p_empno || ' does not exist my friend Ciro');
            WHEN e_high_salary THEN
                DBMS_OUTPUT.PUT_LINE('Cannot reveal Poor Employee!');
    END;
    /
    
exec last_example(7934);
    
    
    
    
    
    
    
    