-- Connect to des03
show user
SPOOL C:\DB2\Project_P6\p6_q1_spool.txt;
SELECT to_char(sysdate, 'DD Month YYYY Day HH:MI:SS Am') FROM dual;

SET SERVEROUTPUT ON

-- Question 1
CREATE OR REPLACE PROCEDURE p6_q1 AS
    CURSOR faculty_cursor IS
    SELECT f_id, f_last, f_first, f_rank
    FROM faculty;
    
    v_f_id    faculty.f_id%TYPE;
    v_f_last  faculty.f_last%TYPE;
    v_f_first faculty.f_first%TYPE;
    v_f_rank  faculty.f_rank%TYPE;
    
    CURSOR student_cursor(pc_f_id faculty.f_id%TYPE) IS
    SELECT s_id, s_last, s_first, s_dob, s_class
    FROM student
    WHERE f_id = pc_f_id;
    
    v_s_id    student.s_id%TYPE;
    v_s_last  student.s_last%TYPE;
    v_s_first student.s_first%TYPE;
    v_s_dob   student.s_dob%TYPE;
    v_s_class student.s_class%TYPE;
    
    BEGIN
        OPEN faculty_cursor;
        
        FETCH faculty_cursor INTO v_f_id, v_f_last, v_f_first, v_f_rank;
        
        WHILE faculty_cursor%FOUND LOOP
            DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------------------------------');
            DBMS_OUTPUT.PUT_LINE('Faculty ID: ' || v_f_id || ' First Name: ' || v_f_first || ' Last Name: ' || v_f_last || ' Rank: ' || v_f_rank);
            
            -- INNER CURSOR --
            OPEN student_cursor(v_f_id);
            
            FETCH student_cursor INTO v_s_id, v_s_last, v_s_first, v_s_dob, v_s_class;
            
            WHILE student_cursor%FOUND LOOP
                DBMS_OUTPUT.PUT_LINE('Student ID: ' || v_s_id || ' First Name: ' || v_s_first || ' Last Name: ' || v_s_last || ' Birthdate: ' || 
                v_s_dob || ' Class: ' || v_s_class);   
                
                FETCH student_cursor INTO v_s_id, v_s_last, v_s_first, v_s_dob, v_s_class;
            END LOOP;
            CLOSE student_cursor;
            
            FETCH faculty_cursor INTO v_f_id, v_f_last, v_f_first, v_f_rank;
        END LOOP;
        CLOSE faculty_cursor;
    END;
    /
    
    exec p6_q1;



