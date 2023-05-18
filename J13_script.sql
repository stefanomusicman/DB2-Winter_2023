show user
SPOOL C:\DB2\j13_spool.txt;
SELECT to_char(sysdate, 'DD Month YYYY Day HH:MI:SS Am') FROM dual;

SET SERVEROUTPUT ON

-- create a procedure
CREATE OR REPLACE PROCEDURE pj10_ex2 AS
BEGIN
    NULL;
END;
/

-- execute a procedure
exec pj10_ex2;

-- create a procedure including a variable
CREATE OR REPLACE PROCEDURE pjan10_ex3 AS
v_num10 NUMBER;
BEGIN
    v_num10 := 10;
END;
/

exec pjan10_ex3;

-- print value of variable and a string
CREATE OR REPLACE PROCEDURE pjan10_ex4 AS
v_num1 NUMBER;
BEGIN
    v_num1 := 10;
    DBMS_OUTPUT.PUT_LINE('The content of variable v_num1 is ' || v_num1);
END;
/

exec pjan10_ex4;

-- EX5: create a procedure that accepts a number to calculate and display 7 times the input value
-- seven times of X is Y
CREATE OR REPLACE PROCEDURE pj13_ex5 (p_num_in IN NUMBER) AS
    v_num_in NUMBER; 
    v_result NUMBER;
    BEGIN
        v_num_in := p_num_in;
        v_result := v_num_in * 7;
        DBMS_OUTPUT.PUT_LINE('Seven time of ' || v_num_in || ' is ' || v_result || ' !' );
    END;
    /
    
exec pj13_ex5(7);

-- EX6: create a function named f_7_time that accepts a number to return 7 times the input value to the calling environment
-- syntax for creating function: CREATE OR REPLACE FUNCTION name_of_function
--                               [ (name_of_parameter MODE datatype, ....) ]
--                               RETURN datatype AS
--                                  BEGIN
--                                      RETURN variable;
--                                  END;
--                                  /
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

-- execute a function:
-- SELECT name_of_function FROM dual;
-- FUNCTIONS are meant to be called within SELECT statements

SELECT f_7_time(7) FROM dual;
SELECT table_name FROM user_tables;
DESCRIBE emp;




SPOOL OFF;