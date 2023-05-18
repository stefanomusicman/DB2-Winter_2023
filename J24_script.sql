-- Menu du jour
-- SELECT in PL/SQL
-- Handle Pre-defined EXCEPTION

show user
SPOOL C:\DB2\j24_spool.txt;
SELECT to_char(sysdate, 'DD Month YYYY Day HH:MI:SS Am') FROM dual;

SET SERVEROUTPUT ON

-- SELECT in PL/SQL
-- SYNTAX: SELECT column1, column2 ....
--         INTO variable1, variable2
--         FROM name_of_table
--         [ WHERE condition ]

-- Ex1: Create a Procedure that accepts an employee number to find 
-- and display his name, job and salary on the screen as follows:\
-- Employee number X is Y. He is a Z earning $D a month.
-- X = empNo, Y = ename, Z = job, D = salary of table

CREATE OR REPLACE PROCEDURE pj24_ex1(p_empno IN NUMBER) AS
    v_ename VARCHAR2(40);
    v_job VARCHAR2(40);
    v_sal NUMBER;
    BEGIN
        SELECT ename, job, sal
        INTO v_ename, v_job, v_sal
        FROM emp
        WHERE empno = p_empno;
        DBMS_OUTPUT.PUT_LINE('Employee number ' || p_empno || ' is ' || v_ename || '. He is a ' || v_job || ' earning $' || v_sal || ' a month.');
        
        EXCEPTION
            WHEN TOO_MANY_ROWS THEN
                DBMS_OUTPUT.PUT_LINE('The select statement returns too many rows');
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('Employee number ' || p_empno || ' does not exist my friend');
            --WHEN OTHERS THEN
                --DBMS_OUTPUT.PUT_LINE('There is something WRONG my friend');
    END;
    /
    
    exec pj24_ex1(7788);


-- Ex2: Create a procedure that accepts an employee number to
-- calculate and display his/her name, job, old and new salary using
-- the scale below:
-- >= 5000                  5% increase in salary
-- between 4000 and 4999    10% increase in salary
-- between 3000 and 3999    15% increase in salary
-- between 2000 and 2999    20% increase in salary
-- between 1000 and 1999    25% increase in salary
-- < 100                    100% increase in salary
-- The procedure will update the salary of the employee and display EXACTLY as follows
-- Employee number X is Y. He is a Z earning $D. 
-- With N percent increase in salary, his new salary is $N
-- where X = empno, Y = ename, Z = job, D = old salary, N = new salary

CREATE OR REPLACE PROCEDURE p24_ex2(p_empno IN NUMBER) AS
    v_ename VARCHAR2(40);
    v_job VARCHAR2(40);
    v_sal NUMBER;
    v_new_sal NUMBER;
    v_percent NUMBER;
    BEGIN
        SELECT ename, job, sal
        INTO v_ename, v_job, v_sal
        FROM emp
        WHERE empno = p_empno;
        
        IF v_sal >= 5000 THEN
            v_percent := 5;
        ELSIF v_sal >= 4000 THEN
            v_percent := 10;
        ELSIF v_sal >= 3000 THEN
            v_percent := 15;
        ELSIF v_sal >= 2000 THEN
            v_percent := 20;
        ELSIF v_sal >= 1000 THEN
            v_percent := 25;
        ELSIF v_sal >= 0 THEN
            v_percent := 100;
        END IF;
        
        v_new_sal := v_sal + v_sal * v_percent / 100;
        UPDATE emp SET sal = v_new_sal WHERE empno = p_empno;
        
        DBMS_OUTPUT.PUT_LINE('Employee number ' || p_empno || ' is ' || v_ename || '. He is a ' || v_job || ' earning $' || v_sal || ' a month.');
        DBMS_OUTPUT.PUT_LINE('With ' || v_percent || '% increase in salary, his new salary is now $' || v_new_sal);
        COMMIT;
        
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('Employee number ' || p_empno || ' does not exist my friend');
    END;
    /
    
    exec p24_ex2(7369);
    
    
    