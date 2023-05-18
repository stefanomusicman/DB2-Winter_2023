show user
SPOOL C:\DB2\Project_P9\p9_q1_spool.txt;
SELECT to_char(sysdate, 'DD Month YYYY Day HH:MI:SS Am') FROM dual;

SET SERVEROUTPUT ON

-- connect to user des02
-- Question 1
CREATE OR REPLACE PACKAGE customer_package IS
    PROCEDURE customer_insert(p_lname VARCHAR2, p_address VARCHAR2);
    PROCEDURE customer_insert(p_lname VARCHAR2, p_bdate DATE);
    PROCEDURE customer_insert(p_lname VARCHAR2, p_fname VARCHAR2, p_bdate DATE);
    PROCEDURE customer_insert(p_cid NUMBER, p_lname VARCHAR2, p_bdate DATE);
END;
/

CREATE SEQUENCE customer_sequence START WITH 7;

CREATE OR REPLACE PACKAGE BODY customer_package IS
    PROCEDURE customer_insert(p_lname VARCHAR2, p_address VARCHAR2) AS
        v_customer_id customer.c_id%TYPE;
        BEGIN
            SELECT customer_sequence.NEXTVAL
            INTO v_customer_id
            FROM  dual;
            
            INSERT INTO customer(c_id, c_last, c_address)
            VALUES (v_customer_id, p_lname, p_address);
            commit;
        END;
    PROCEDURE customer_insert(p_lname VARCHAR2, p_bdate DATE) AS
        v_customer_id customer.c_id%TYPE;
        BEGIN
            SELECT customer_sequence.NEXTVAL
            INTO v_customer_id
            FROM  dual;
            
            INSERT INTO customer(c_id, c_last, c_birthdate)
            VALUES (v_customer_id, p_lname, p_bdate);
            commit;
        END;
    PROCEDURE customer_insert(p_lname VARCHAR2, p_fname VARCHAR2, p_bdate DATE) AS
        v_customer_id customer.c_id%TYPE;
        BEGIN
            SELECT customer_sequence.NEXTVAL
            INTO v_customer_id
            FROM  dual;
            
            INSERT INTO customer(c_id, c_last, c_first, c_birthdate)
            VALUES (v_customer_id, p_lname, p_fname, p_bdate);
            commit;
        END;
    PROCEDURE customer_insert(p_cid NUMBER, p_lname VARCHAR2, p_bdate DATE) AS
        BEGIN            
            INSERT INTO customer(c_id, c_last, c_birthdate)
            VALUES (p_cid, p_lname, p_bdate);
            commit;
        END;
END;
/

-- TEST
-- A 
exec customer_package.customer_insert('Evans', '123 red road');
-- B
exec customer_package.customer_insert('Johnson', sysdate);
-- C
exec customer_package.customer_insert('Ryan', 'Jack', sysdate);
-- D
exec customer_package.customer_insert(100, 'Nickson', sysdate);




