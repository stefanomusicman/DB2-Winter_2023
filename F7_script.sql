show user
SPOOL C:\DB2\feb7_spool.txt;
SELECT to_char(sysdate, 'DD Month YYYY Day HH:MI:SS Am') FROM dual;

SET SERVEROUTPUT ON

-- EXPLICIT CURSOR -- MANIPULATE MULTIPLE ROWS IN PL/SQL
-- WE MUST FOLLOW 4 STEPS

-- STEP 1: DECLARATION
--      IS DONE IN THE DECLARATION SECTION
--      SYNTAX:
--      CURSOR name_of_cursor IS
--      SELECT statement;

-- EX: CURSOR dept_curr IS
--     SELECT deptno, dname FROM dept;

-- STEP 2: OPEN
--      IS DONE IN THE EXECUTE SECTION
--      SYNTAX:
--      OPEN name_of_cursor;

-- EX: OPEN dept_curr;
-- RESULT OF OPEN: - The SELECT statement you declared in step 1 is executed. 
--                 - The result of the SELECT statement if exists will be 
--                   to the memory area named ACTIVE SET
--                 - The cursor attribute %ISOPEN is set to TRUE.

-- STEP 3: FETCH
--      IS DONE IN THE EXECUTABLE SECTION
--      SYNTAX:
--      FETCH name_of_cursor INTO variable;

-- EX: FETCH dept_curr INTO v_deptno, v_dname;
-- RESULT OF FETCH: There are 2 possibilities.
--      - Successful FETCH (data exists in the ACTIVE SET
--          The cursor attribute %FOUND is set to TRUE
--          The cursor attribute %NOTFOUND is set to FALSE
--          The cursor attribute %ROWCOUNT is increased by 1
--      - Unsuccessful FETCH (data exists in the ACTIVE SET
--          The cursor attribute %FOUND is set to FALSE
--          The cursor attribute %NOTFOUND is set to TRUE
--          The cursor attribute %ROWCOUNT remains the same as previous value

-- STEP 4: CLOSE
--      IS DONE IN THE EXECUTE TABLE SECTION
--      SYNTAX:
--      CLOSE name_of_cursor;

-- EX: CLOSE dept_curr;
-- RESULT OF CLOSE
--      - The memory occupied by the ACTIVE SET is returned to the system
--      - The cursor attribute %ISOPEN is set to FALSE.

-- Example 5: Create a procedure name feb7_ex5 to display, calculate and update 
--            the salary of all employees using the scale below:
-- >= 5000      5%
-- 4000 - 4999  10%
-- 3000 - 3999  15%
-- 2000 - 2999  20%
-- 1000 - 1999  25%
-- 0 - 999      100%
-- Display as follows:
-- Employee number X is Y. With M% increase in salary his/her salary was changing from $O to $N!
-- X = empno, Y = ename, M = percent increase, O = old salary, N = new salary

CREATE OR REPLACE PROCEDURE feb7_ex5 AS
    -- STEP 1: DECLARATION
    CURSOR emp_curr IS
    SELECT empno, ename, sal
    FROM emp;
    
    -- variable declaration
    v_empno emp.empno%TYPE;
    v_ename emp.ename%TYPE;
    v_sal   emp.sal%TYPE;
    v_percent NUMBER;
    v_new_sal NUMBER;
    
    BEGIN
        -- STEP 2: OPEN
        OPEN emp_curr;
        
        -- STEP 3: FETCH
        FETCH emp_curr INTO v_empno, v_ename, v_sal;
        
        WHILE emp_curr%FOUND LOOP
            IF v_sal > 5000 THEN
                v_percent := 5;
            ELSIF v_sal >= 4000  THEN
                v_percent := 10;  
            ELSIF v_sal >= 3000  THEN
                v_percent := 15;
            ELSIF v_sal >= 2000  THEN
                v_percent := 20;  
            ELSIF v_sal >= 1000  THEN
                v_percent := 25;
            ELSIF v_sal >= 0 THEN
                v_percent := 100;  
            END IF;
            
            v_new_sal := v_sal + ((v_sal * v_percent) / 100);
            UPDATE emp SET sal = v_new_sal WHERE empno = v_empno;
            DBMS_OUTPUT.PUT_LINE('Employee number ' || v_empno || ' is ' || v_ename || '. With ' || v_percent || 
            '% increase in salary, his/her was changing from $' || v_sal || ' to ' || v_new_sal || '!');
            
            -- MUST FETCH NEXT ROW OTHERWISE LOOP WILL BE INFINITE
            FETCH emp_curr INTO v_empno, v_ename, v_sal;
            COMMIT;
        END LOOP;
        -- STEP 4: CLOSE
        CLOSE emp_curr;
    END;
    /
    
    exec feb7_ex5;


--------------------------------- LOOPS ------------------------------------
-- 1. BASIC LOOP
--  SYNTAX:
--      LOOP
--          statement;
--      EXIT WHEN condition;
--      END LOOP;

-- The statement is executed until the condition is evaluate to TRUE.

-- EXAMPLE 1: Create a procedure to display number 0 to 10 on the screen using BASIC LOOP

CREATE OR REPLACE PROCEDURE feb7_ex1 AS
    v_counter NUMBER := 0;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('BASIC LOOP');
        LOOP
            DBMS_OUTPUT.PUT_LINE(v_counter);
            v_counter := v_counter + 1;
        EXIT WHEN v_counter > 10;
        END LOOP;
    END;
    /

    exec feb7_ex1;
    
-- 2. WHILE LOOP
--  SYNTAX:
--      WHILE condition LOOP
--          statement;
--      END LOOP;

-- The statement is executed until the condition is evaluate to TRUE.

-- EXAMPLE 2: Create a procedure to display number 0 to 10 on the screen using WHILE LOOP

CREATE OR REPLACE PROCEDURE feb7_ex2 AS
    v_counter NUMBER := 0;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('WHILE LOOP');
        WHILE v_counter <= 10 LOOP
            DBMS_OUTPUT.PUT_LINE(v_counter);
            v_counter := v_counter + 1;
        END LOOP;
    END;
    /

    exec feb7_ex2;
    
-- 3. FOR LOOP
--  SYNTAX:
--      FOR index IN low_end .. high_end LOOP
--          statement;
--      END LOOP;

-- The statement is executed from the low_end to the high_end. No need to declare and increment the index.

-- EXAMPLE 3: Create a procedure to display number 0 to 10 on the screen using FOR LOOP

CREATE OR REPLACE PROCEDURE feb7_ex3 AS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('FOR LOOP');
        FOR ciro IN 0 .. 10 LOOP
            DBMS_OUTPUT.PUT_LINE(ciro);
        END LOOP;
    END;
    /

    exec feb7_ex3;
    
-- EXAMPLE 4: Create a procedure to display number 10 to 0 on the screen using FOR LOOP

CREATE OR REPLACE PROCEDURE feb7_ex4 AS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('FOR LOOP IN REVERSE');
        FOR ciro IN REVERSE 0 .. 10 LOOP
            DBMS_OUTPUT.PUT_LINE(ciro);
        END LOOP;
    END;
    /

    exec feb7_ex4;

SPOOL OFF














