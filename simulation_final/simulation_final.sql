SPOOL C:\DB2\simulation_final\simulation_final_spool.txt;
SELECT to_char(sysdate, 'DD Month YYYY Day HH:MI:SS Am') FROM dual;

SET SERVEROUTPUT ON

-- connect to des03
-- Question 2
CREATE OR REPLACE FUNCTION stefano_find_age(p_id NUMBER, p_dob DATE) RETURN NUMBER AS
    BEGIN
        RETURN FLOOR((sysdate - p_dob)/365.5);
    END;
    /
    
-- TEST
SELECT stefano_find_age(1,sysdate - 10000) FROM dual;

CREATE OR REPLACE PROCEDURE stefano_p1(p_id NUMBER, p_fname VARCHAR2, p_lname VARCHAR2, p_dob DATE) AS
    v_bad_dob EXCEPTION;
    v_id NUMBER;
    v_age NUMBER := stefano_find_age(p_id, p_dob);
    BEGIN   
        SELECT s_id 
        INTO v_id 
        FROM student
        WHERE s_id = p_id;
        
        IF p_dob > sysdate THEN
            RAISE v_bad_dob;
        ELSE    
            UPDATE student
            SET s_first = p_fname, s_last = p_lname, s_dob = p_dob
            WHERE s_id = p_id;
            
            DBMS_OUTPUT.PUT_LINE('Update completed successfully');
            DBMS_OUTPUT.PUT_LINE('Student number ' || p_id || ' is ' || p_fname || ' ' || p_lname || '. Born on the ' || 
            p_dob || ', ' || v_age || ' year old.');
        END IF;
        
        EXCEPTION
            WHEN v_bad_dob THEN
                DBMS_OUTPUT.PUT_LINE('Cannot perform update with date that is in the future.');
            WHEN NO_DATA_FOUND THEN
                INSERT INTO student(s_id, s_first, s_last, s_dob)
                VALUES(p_id, p_fname, p_lname, p_dob);
                IF v_age < 0 THEN
                    DBMS_OUTPUT.PUT_LINE('Student number ' || p_id || ' is ' || p_fname || ' ' || p_lname || '. Not born yet.');
                ELSE
                    DBMS_OUTPUT.PUT_LINE('Student number ' || p_id || ' is ' || p_fname || ' ' || p_lname || '. Born on the ' || 
                    p_dob || ', ' || v_age || ' year old.');
                END IF;
    END;
    /




