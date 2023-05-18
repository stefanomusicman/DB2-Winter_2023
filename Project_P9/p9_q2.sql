show user
SPOOL C:\DB2\Project_P9\p9_q2_spool.txt;
SELECT to_char(sysdate, 'DD Month YYYY Day HH:MI:SS Am') FROM dual;

SET SERVEROUTPUT ON

-- connect to user des03
-- Question 2

CREATE OR REPLACE PACKAGE student_package IS
    PROCEDURE add_student(p_stud_id NUMBER, p_lname VARCHAR2, p_bdate DATE);
    PROCEDURE add_student(p_lname VARCHAR2, p_bdate DATE);
    PROCEDURE add_student(p_lname VARCHAR2, p_address VARCHAR2);
    PROCEDURE add_student(p_lname VARCHAR2, p_fname VARCHAR2, p_bdate DATE, p_fac_id NUMBER);
END;
/

CREATE SEQUENCE student_sequence START WITH 7;

CREATE OR REPLACE PACKAGE BODY student_package IS
    -- A)
    PROCEDURE add_student(p_stud_id NUMBER, p_lname VARCHAR2, p_bdate DATE) AS
        v_stud_id student.s_id%TYPE;
        BEGIN
            SELECT s_id
            INTO v_stud_id
            FROM student
            WHERE s_id = p_stud_id;
            
            DBMS_OUTPUT.PUT_LINE('Student ID: ' || p_stud_id || ' already exists.');
            
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    IF p_bdate < sysdate THEN
                        INSERT INTO student(s_id, s_last, s_dob)
                        VALUES(p_stud_id, p_lname, p_bdate);
                        commit;
                    ELSE
                        DBMS_OUTPUT.PUT_LINE('Birth date cannot be after current date.');
                    END IF;
        END;
    -- B)
    PROCEDURE add_student(p_lname VARCHAR2, p_bdate DATE) AS
        BEGIN
            IF p_bdate < sysdate THEN
                INSERT INTO student(s_id, s_last, s_dob)
                VALUES(student_sequence.NEXTVAL, p_lname, p_bdate);
                commit;
            ELSE
                DBMS_OUTPUT.PUT_LINE('Birth date cannot be after current date.');
            END IF;
        END;
    -- C)
    PROCEDURE add_student(p_lname VARCHAR2, p_address VARCHAR2) AS
        BEGIN
            INSERT INTO student(s_id, s_last, s_address)
            VALUES(student_sequence.NEXTVAL, p_lname, p_address);
            commit;
        END;
    -- D)
    PROCEDURE add_student(p_lname VARCHAR2, p_fname VARCHAR2, p_bdate DATE, p_fac_id NUMBER) AS
        v_fac_id student.f_id%TYPE;
        BEGIN
            SELECT f_id
            INTO v_fac_id
            FROM faculty
            WHERE f_id = p_fac_id;
            
            IF p_bdate < sysdate THEN
                INSERT INTO student(s_id, s_first, s_last, s_dob, f_id)
                VALUES(student_sequence.NEXTVAL, p_fname, p_lname, p_bdate, p_fac_id);
                commit;
            ELSE
                DBMS_OUTPUT.PUT_LINE('Birth date cannot be after current date.');
            END IF;
            
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    DBMS_OUTPUT.PUT_LINE('Faculty ID: ' || p_fac_id || ' does not exist.');
        END;
END;
/

-- TEST
-- A)
exec student_package.add_student(30, 'Johnson', sysdate - 10);
exec student_package.add_student(1, 'Johnson', sysdate - 10);
exec student_package.add_student(40, 'Johnson', sysdate + 10);

-- B)
exec student_package.add_student('Richardson', sysdate - 10);
exec student_package.add_student('Richardson', sysdate + 10);          

-- C)
exec student_package.add_student('James', '123 Yellow Brick Road');
        
-- D)
exec student_package.add_student('Jackson', 'Donald', sysdate - 10, 1);
exec student_package.add_student('Jackson', 'Donald', sysdate - 10, 1000); 
exec student_package.add_student('Jackson', 'Donald', sysdate + 10, 1);
