show user
SPOOL C:\DB2\j17_spool.txt;
SELECT to_char(sysdate, 'DD Month YYYY Day HH:MI:SS Am') FROM dual;

SET SERVEROUTPUT ON

CREATE OR REPLACE FUNCTION f_7_time (p_num_in IN NUMBER)
RETURN NUMBER AS 
    v_num_in NUMBER;
    v_result NUMBER;
    BEGIN
        v_num_in := p_num_in;
        v_result := v_num_in * 7;
        RETURN v_result;
    END;
    /
    
SELECT f_7_time(7) FROM dual;

-- alternate way of writing previous function
CREATE OR REPLACE FUNCTION f_7_timeB (p_num_in IN NUMBER)
RETURN NUMBER AS 
    v_num_in NUMBER := p_num_in;
    v_result NUMBER;
    BEGIN
        v_result := v_num_in * 7;
        RETURN v_result;
    END;
    /

SELECT f_7_timeB(7) FROM dual;

-- alternate way of writing previous function
CREATE OR REPLACE FUNCTION f_7_timeC (p_num_in IN NUMBER)
RETURN NUMBER AS 
    v_result NUMBER;
    BEGIN
        v_result := p_num_in * 7;
        RETURN v_result;
    END;
    /

SELECT f_7_timeC(7) FROM dual;

-- alternate way of writing the previous function
CREATE OR REPLACE FUNCTION f_7_timeD (p_num_in IN NUMBER)
RETURN NUMBER AS 
    BEGIN
        RETURN p_num_in * 7;
    END;
    /

SELECT f_7_timeD(7) FROM dual;

------------------------------------------------------------------------------
-- TODAY'S LESSON:
-- How to use functions within a procedure
-- the IF statement
-- Function which returns a BOOLEAN datatype

-- EX1: Create a procedure named pj17_ex1 that accepts a number and use 
-- the function f_7_time to display exactly the following:
    -- Seven time of X is Y !
    -- where X is the input value and Y is the value returned by the function
CREATE OR REPLACE PROCEDURE pj17_ex1(p_num_in IN NUMBER) AS
    v_result NUMBER;
    BEGIN
        v_result := f_7_time(p_num_in); -- IMPORTANT: USING FUNCTION INSIDE OF PROCEDURE
        DBMS_OUTPUT.PUT_LINE('Seven time of ' || p_num_in || ' is ' || v_result || ' !' );
    END;
    /
    
exec pj17_ex1(7);

-- IF statement
-- Syntax:
--  IF condition1 THEN
--      statement1;
--  END IF;
-- statement1 will be executed when condition1 evaluates to TRUE

-- IF/ELSE statement
--  IF condition1 THEN
--      statement1;
--  ELSE
--      statement2;
--  END IF;
-- statement1 will be executed when condition1 evaluates to TRUE
-- otherwise statement2 will be executed

-- NESTED IF statements
--  IF condition1 THEN
--      statement1;
--  ELSE
--      IF condition2 THEN
--          statement2;
--      END IF;
--      IF condition3 THEN
--          statement3;
--      END IF;
--  END IF;

-- JOINING ELSE AND IF
-- ELSIF is the same as ELSE IF in javascript and C#

-- Ex2: Create a procedure named p_grade_convert that accepts a numerical grade
-- to convert into a letter grade using the following scale:
    -- >= 90   === A
    -- 80 - 89 === B
    -- 70 - 79 === C
    -- 60 - 69 === D
    -- < 60     === 'See you again'
CREATE OR REPLACE PROCEDURE p_grade_convert(p_mark IN NUMBER) AS
    v_grade VARCHAR2(40);
    BEGIN
        IF p_mark > 100 OR p_mark < 0 THEN
            DBMS_OUTPUT.PUT_LINE('Please enter a mark between 0 and 100' );
        ELSE
            IF p_mark >= 90 THEN
                v_grade := 'A';
            ELSIF p_mark > 80 THEN
                v_grade := 'B';
            ELSIF p_mark > 70 THEN
                v_grade := 'C';       
            ELSIF p_mark > 60 THEN
                v_grade := 'D';
            ELSE 
                v_grade := 'See you again my friend';
            END IF;
            DBMS_OUTPUT.PUT_LINE('For a grade of ' || p_mark || ' you will have a grade of ' || v_grade || '.' );
        END IF;
    END;
    /
    
exec p_grade_convert(85);

-- FUNCTION that returns a BOOLEAN datatype
-- Ex3: Create a FUNCTION named f_if_equal that accepts 2 numbers to return TRUE if they are equal, 
-- otherwise return FALSE
CREATE OR REPLACE FUNCTION f_if_equal(p_num1 IN NUMBER, p_num2 IN NUMBER)
RETURN BOOLEAN AS
    v_result BOOLEAN := FALSE;
    BEGIN
        IF p_num1 = p_num2 THEN
            v_result := TRUE;
        END IF;
        RETURN v_result;
    END;
    /
    
SELECT f_if_equal(2,2) FROM dual; -- CANNOT WORK BECAUSE BOOLEANS EXIST IN PL/SQL AND SELECT IS SQL
                                  -- MUST CALL FUNCTION WITHIN A PROCEDURE....SEE BELOW

-- Ex4: Create a procedure pj17_ex4 that accepts 2 numbers to use the function f_if_equal to display either:
    -- The 2 number X and Y are EQUAL
    -- The 2 number X and Y are NOT EQUAL
CREATE OR REPLACE PROCEDURE pj17_ex4(p1 IN NUMBER, p2 IN NUMBER) AS
    v1 NUMBER := p1;
    v2 NUMBER := p2;
    v_result VARCHAR(20) := 'NOT EQUAL';
    BEGIN
        IF f_if_equal(v1, v2) THEN
            v_result := 'EQUAL';
        END IF;
        DBMS_OUTPUT.PUT_LINE('The two number ' || v1 || ' and ' || v2 || ' are ' || v_result || ' !');
    END;
    /
    
exec pj17_ex4(2,2);
exec pj17_ex4(2,3);

SPOOL OFF;