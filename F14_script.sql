show user
SPOOL C:\DB2\f14_spool.txt;
SELECT to_char(sysdate, 'DD Month YYYY Day HH:MI:SS Am') FROM dual;

SET SERVEROUTPUT ON

-- Example 1: Create a procedure to display all departments
CREATE OR REPLACE PROCEDURE feb14_ex1 AS
    -- STEP 1
    CURSOR dept_curr IS
    SELECT deptno, dname, loc
    FROM dept;
    
    v_deptno dept.deptno%TYPE;
    v_dname  dept.dname%TYPE;
    v_loc    dept.loc%TYPE;
    
    BEGIN
        -- STEP 2
        OPEN dept_curr;
        -- STEP 3
        FETCH dept_curr INTO v_deptno, v_dname, v_loc;
        
        WHILE dept_curr%FOUND LOOP
            DBMS_OUTPUT.PUT_LINE('Department number ' || v_deptno || ' is ' || v_dname || ' located in the city of ' || v_loc || '.');
            FETCH dept_curr INTO v_deptno, v_dname, v_loc;
        END LOOP;
        -- STEP 4
        CLOSE dept_curr;
    END;
    /
    
    exec feb14_ex1;
    
-- Example 2: Modify the procedure of example 1 to display under each department, all the employees working in it.
-- HINT: use CURSOR WITH PARAMETER

-- SYNTAX:
-- CURSOR name_of_cursor (name_of_parameter DATATYPE) IS
-- SELECT name_of_column
-- FROM name_of_table
-- WHERE name_of_column = name_of_parameter;

-- OPEN name_of_cursor (value);

CREATE OR REPLACE PROCEDURE feb14_ex2 AS
    -- STEP 1
    CURSOR dept_curr IS
    SELECT deptno, dname, loc
    FROM dept;
    
    v_deptno dept.deptno%TYPE;
    v_dname  dept.dname%TYPE;
    v_loc    dept.loc%TYPE;
    
    CURSOR emp_curr (pc_deptno dept.deptno%TYPE) IS
    SELECT empno, ename, job, sal
    FROM emp
    WHERE deptno = pc_deptno;
    
    v_empno emp.empno%TYPE;
    v_ename emp.ename%TYPE;
    v_job   emp.job%TYPE;
    v_sal   emp.sal%TYPE;
    
    BEGIN
        -- STEP 2
        OPEN dept_curr;
        -- STEP 3
        FETCH dept_curr INTO v_deptno, v_dname, v_loc;
        
        WHILE dept_curr%FOUND LOOP
            DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------------------------------');
            DBMS_OUTPUT.PUT_LINE('Department number ' || v_deptno || ' is ' || v_dname || ' located in the city of ' || v_loc || '.');
            
            -- ***INNER CURSOR***
            OPEN emp_curr(v_deptno);
            FETCH emp_curr INTO v_empno, v_ename, v_job, v_sal;
            WHILE emp_curr%FOUND LOOP
                DBMS_OUTPUT.PUT_LINE('Employee number ' || v_empno || 'is ' || v_ename || '. He/she is a ' || v_job || ' earning a salary of ' ||
                v_sal || ' a month. ');
                FETCH emp_curr INTO v_empno, v_ename, v_job, v_sal;
            END LOOP;
            CLOSE emp_curr;
            
            FETCH dept_curr INTO v_deptno, v_dname, v_loc;
        END LOOP;
        -- STEP 4
        CLOSE dept_curr;
    END;
    /
 
    exec feb14_ex2;
        
----------------------------------- CURSOR FOR UPDATE -------------------------------------------------------------

-- SYNTAX: 
-- CURSOR name_of_cursor IS
-- SELECT name_of_column
-- FROM name_of_table
-- FOR UPDATE OF name_of_column;

-- Example 3: Create a procedure that accepts a number representing the percentage increase in salary.
-- The procedure will lock and update the salary with the new salary calculated using the percentage that was inserted.

CREATE OR REPLACE PROCEDURE feb14_ex3(p_percent NUMBER) IS
    CURSOR emp_curr IS
    SELECT ename, sal
    FROM emp
    FOR UPDATE OF sal;
    
    v_ename   emp.ename%TYPE;
    v_sal     emp.sal%TYPE;
    v_new_sal NUMBER;
    
    BEGIN
        OPEN emp_curr;
        
        FETCH emp_curr INTO v_ename, v_sal;
        
        WHILE emp_curr%FOUND LOOP
            v_new_sal := v_sal + ((v_sal * p_percent)/100);
            UPDATE emp SET sal = v_new_sal
            WHERE CURRENT OF emp_curr;
            DBMS_OUTPUT.PUT_LINE('The salary of Mr. ' || v_ename || ' has been changed from ' || v_sal || ' to ' || v_new_sal || ' my friend Ciro');
            FETCH emp_curr INTO v_ename, v_sal;
        END LOOP;
        CLOSE emp_curr;
        commit;
    END;
    /

    exec feb14_ex3(10);


SPOOL OFF

