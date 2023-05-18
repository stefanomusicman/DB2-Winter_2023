CONNECT system/7099

alter session set "_ORACLE_SCRIPT"=true;
-- DROP USER formula1 cascade;

CREATE USER f1 IDENTIFIED BY f1

DEFAULT TABLESPACE USERS;

GRANT CONNECT,RESOURCE TO f1 ;

GRANT UNLIMITED TABLESPACE TO f1;

grant create view to f1 ;

-- Jan 10
connect sys/sys as sysdba -- add in login info where it says sys/sys
SPOOL C:\DB2\j10_spool.txt;
SELECT to_char(sysdate, 'DD Month YYYY Day HH:MI:SS Am') FROM dual;

-- PL/SQL is a block language
-- BEGIN
--      executable statement;
-- END;

-- Example 1: Create an anonymous block that does nothing

BEGIN
    NULL;
END;

DROP USER jan10;
CREATE USER jan10 IDENTIFIED BY JAN10;
GRANT CONNECT, resource TO jan10;
connect jan10/jan10;
show user;

-- Example 2 create a procedure named pj10_ex2 that does nothing
-- syntax:
--  CREATE OR REPLACE PROCEDURE name_of_procedure [  (name_of_parameter MODE datatype, ...)  ] AS
-- BEGIN
--      executable statement;
-- END;

CREATE OR REPLACE PROCEDURE pj10_ex2 AS
BEGIN
    NULL
END;
/

-- To run or exevute a procefure do: 
-- EXECUTE name_of_procedure OR exec name_of_procedure

exec pj10_ex22

SELECT object_name, object_type FROM user_objects;

-- Example 3: create a procedure  named pjan10_ex3 which has a variable named 
-- v_num1 of type NUMBER. Assign number 10 to the variable in the executable section of the procedure
-- HINT: declare the variable between the keyword AS and BEGIN
-- Assign a value using the assigning operator := )

CREATE OR REPLACE PROCEDURE pjan10_ex3 AS
v_num1 NUMBER;
BEGIN
    v_num1 := 10;
END
/

-- Example 4: Modify the procedure of example 3 to display the contentof the v_num1 on the screen as follows:
-- The content of variable v_num1 is X.
-- HINT: use function PUT_LINE of DBMS_OUTPUT package to display text and variable. use concactenation operator || to join the text and variable together

CREATE OR REPLACE PROCEDURE pjan10_ex4 AS
v_num1 NUMBER;
BEGIN
    v_num1 := 10;
    DBMS_OUTPUT.PUT_LINE('The content of variable v_num1 is ' || v_num1);
END
/
-- we have to turn on the package with the following command
SET SERVEROUTPUT ON
exec pjan10_ex3

