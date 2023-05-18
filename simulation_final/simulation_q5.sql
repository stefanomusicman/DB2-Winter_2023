SPOOL C:\DB2\simulation_final\simulation_final_q5_spool.txt;
SELECT to_char(sysdate, 'DD Month YYYY Day HH:MI:SS Am') FROM dual;

SET SERVEROUTPUT ON

-- connect to ***booking***..... it contains all the scripts of scott and northwoods (des03)
-- Question 5
CREATE OR REPLACE PACKAGE stefano_final IS
    FUNCTION stefano_find_age(p_id NUMBER, p_dob DATE) RETURN NUMBER;
    PROCEDURE stefano_p1(p_id NUMBER, p_fname VARCHAR2, p_lname VARCHAR2, p_dob DATE);
    PROCEDURE sim_final_q3;
    END;
    /
    
CREATE OR REPLACE PACKAGE BODY stefano_final IS
    -- PACKAGE OBJECT 1
    FUNCTION stefano_find_age(p_id NUMBER, p_dob DATE) RETURN NUMBER AS
        BEGIN
            RETURN FLOOR((sysdate - p_dob)/365.5);
        END stefano_find_age;
    
    -- PACKAGE OBJECT 2
    PROCEDURE stefano_p1(p_id NUMBER, p_fname VARCHAR2, p_lname VARCHAR2, p_dob DATE) AS
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
    END stefano_p1;
    
    -- PACKAGE OBJECT 3
    PROCEDURE sim_final_q3 AS
    CURSOR dept_curr IS
    SELECT deptno, dname, loc
    FROM dept;
    
    CURSOR emp_curr(dept_id NUMBER) IS
    SELECT ename, job, hiredate
    FROM emp
    WHERE deptno = dept_id;
    
    v_exp NUMBER;
    
    BEGIN
        FOR dept IN dept_curr LOOP
            DBMS_OUTPUT.PUT_LINE('-----------------------------------------');
            DBMS_OUTPUT.PUT_LINE('Department ID: ' || dept.deptno || ' Department Name: ' || dept.dname || ' Department Location: ' || dept.loc);
            
            FOR emp IN emp_curr(dept.deptno) LOOP
                v_exp := FLOOR((sysdate - emp.hiredate)/365.5);
                DBMS_OUTPUT.PUT_LINE('Employee Name: ' || emp.ename || ' Job: ' || emp.job || ' Hire Date: ' || emp.hiredate  || 
                ' Years of Experience: ' || v_exp);
            END LOOP;
        END LOOP;
    END sim_final_q3;
END;
/

BEGIN
    stefano_final.stefano_p1(7, 'scott', 'Nathan', sysdate - 10000);
END;
/

BEGIN
    stefano_final.sim_final_q3;
END;
/

BEGIN
    stefano_final.stefano_p1(1, 'Miller', 'Sarah', sysdate + 1000);
END;
/








