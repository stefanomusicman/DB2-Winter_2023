-- connect to des03
SET SERVEROUTPUT ON

-- Question 1

-- A)
CREATE OR REPLACE FUNCTION sp_f1(p_date DATE) RETURN NUMBER AS
    BEGIN
        RETURN FLOOR(MONTHS_BETWEEN(sysdate, p_date) / 12);
    END;
    /
    
-- B)
SELECT sp_f1('2000-October-22') FROM dual;

-- C)
CREATE OR REPLACE PROCEDURE sp_p1(stud_id NUMBER, sec_id NUMBER, p_grade VARCHAR2) AS
    v_c_id course_section.c_sec_id%TYPE;
    v_fname student.s_first%TYPE;
    v_lname student.s_last%TYPE;
    v_dob student.s_dob%TYPE;
    v_grade enrollment.grade%TYPE;
    v_age NUMBER;
    v_counter NUMBER := 0;

    BEGIN
        IF sec_id BETWEEN 1 AND 13 THEN
            SELECT s_first, s_last, s_dob
            INTO v_fname, v_lname, v_dob
            FROM student
            WHERE s_id = stud_id;
            v_counter := 1;
            
            v_age := sp_f1(v_dob);
            
            SELECT grade
            INTO v_grade
            FROM enrollment
            WHERE s_id = stud_id AND c_sec_id = sec_id;
            v_counter := 2;
        
            IF v_grade = p_grade THEN
                DBMS_OUTPUT.PUT_LINE('Row already exists, no need to update');
                DBMS_OUTPUT.PUT_LINE('Name: ' || v_fname || ' ' || v_lname || ' Birthday: ' || v_dob || ' Age: ' || v_age);
            ELSE 
                DBMS_OUTPUT.PUT_LINE('Update needed');
                UPDATE enrollment SET grade = p_grade 
                WHERE s_id = stud_id AND c_sec_id = sec_id;
                DBMS_OUTPUT.PUT_LINE('Update complete');
                DBMS_OUTPUT.PUT_LINE('Name: ' || v_fname || ' ' || v_lname || ' Birthday: ' || v_dob || ' Age: ' || v_age);
            END IF;        
        ELSE 
            DBMS_OUTPUT.PUT_LINE('Section ID ' || sec_id || ' not valid');
        END IF;
        
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                IF v_counter = 0 THEN
                    DBMS_OUTPUT.PUT_LINE('Student id ' || stud_id || ' is invalid');
                ELSIF v_counter = 1 THEN
                    DBMS_OUTPUT.PUT_LINE('This combination does not exist');
                END IF;
    END;
    /
    
-- D)
exec sp_p1(1, 1, 'A');

-- Question 2
CREATE OR REPLACE PROCEDURE sp_p2 AS
    CURSOR faculty_curr IS
    SELECT f_id, f_first, f_last, f_rank
    FROM faculty;
    
    v_f_id faculty.f_id%TYPE;
    v_f_fname faculty.f_first%TYPE;
    v_f_lname faculty.f_last%TYPE;
    v_f_rank faculty.f_rank%TYPE;
    
    CURSOR course_curr(id NUMBER) IS
    SELECT cs.c_sec_id, c.course_name, l.bldg_code, l.room
    FROM course_section cs
    JOIN course c ON cs.course_id = c.course_id
    JOIN location l ON cs.loc_id = l.loc_id
    WHERE cs.f_id = id;
    
    v_sec_id course_section.c_sec_id%TYPE;
    v_course_name course.course_name%TYPE;
    v_bldg_code location.bldg_code%TYPE;
    v_room location.room%TYPE;
    
    BEGIN
        OPEN faculty_curr;
        
        FETCH faculty_curr INTO v_f_id, v_f_fname, v_f_lname, v_f_rank;
        
        WHILE faculty_curr%FOUND LOOP
            DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------------------------------------------------');
            DBMS_OUTPUT.PUT_LINE('Faculty ID: ' || v_f_id || ' Faculty Name: ' || v_f_fname || ' ' || v_f_lname || ' Rank: ' || v_f_rank);
            
            OPEN course_curr(v_f_id);
            
            FETCH course_curr INTO v_sec_id, v_course_name, v_bldg_code, v_room;
            
            WHILE course_curr%FOUND LOOP
                DBMS_OUTPUT.PUT_LINE('Section ID: ' || v_sec_id || ' Course Name: ' || v_course_name || ' Building Code: ' || v_bldg_code
                || ' Room: ' || v_room);
                
                FETCH course_curr INTO v_sec_id, v_course_name, v_bldg_code, v_room;
            END LOOP;
            CLOSE course_curr;
            
            FETCH faculty_curr INTO v_f_id, v_f_fname, v_f_lname, v_f_rank;
        END LOOP;
        CLOSE faculty_curr;
    END;
    /
    
    exec sp_p2;
    
-- Question 3
CREATE OR REPLACE PROCEDURE mt_q3 AS
    CURSOR student_curr IS
    SELECT s_first, s_last, s_dob
    FROM student;
    
    v_fname student.s_first%TYPE;
    v_lname student.s_last%TYPE;
    v_dob student.s_dob%TYPE;
    
    v_age NUMBER;
    
    BEGIN
        OPEN student_curr;
        
        FETCH student_curr INTO v_fname, v_lname, v_dob;
        
        WHILE student_curr%FOUND LOOP
            v_age := sp_f1(v_dob);
            DBMS_OUTPUT.PUT_LINE('Name: ' || v_fname || ' ' || v_lname || ' Birthday: ' || v_dob || ' Age: ' || v_age);
        
            FETCH student_curr INTO v_fname, v_lname, v_dob;
        END LOOP;
        CLOSE student_curr;
    END;
    /
    
    exec mt_q3;
    
    
-- Question 1C Alternate Version
CREATE OR REPLACE PROCEDURE sp_p1_v2(stud_id NUMBER, sec_id NUMBER, p_grade VARCHAR2) AS
    v_c_id course_section.c_sec_id%TYPE;
    v_fname student.s_first%TYPE;
    v_lname student.s_last%TYPE;
    v_dob student.s_dob%TYPE;
    v_grade enrollment.grade%TYPE;
    v_age NUMBER;
    v_counter NUMBER := 0;

    BEGIN
            SELECT s_first, s_last, s_dob
            INTO v_fname, v_lname, v_dob
            FROM student
            WHERE s_id = stud_id;
            v_counter := 1;
            
            v_age := sp_f1(v_dob);
            
            SELECT c_sec_id
            INTO v_c_id
            FROM course_section
            WHERE c_sec_id = sec_id;
            v_counter := 2;
            
            SELECT grade
            INTO v_grade
            FROM enrollment
            WHERE s_id = stud_id AND c_sec_id = sec_id;
            v_counter := 3;
        
            IF v_grade = p_grade THEN
                DBMS_OUTPUT.PUT_LINE('Row already exists, no need to update');
                DBMS_OUTPUT.PUT_LINE('Name: ' || v_fname || ' ' || v_lname || ' Birthday: ' || v_dob || ' Age: ' || v_age);
            ELSE 
                DBMS_OUTPUT.PUT_LINE('Update needed');
                UPDATE enrollment SET grade = p_grade 
                WHERE s_id = stud_id AND c_sec_id = sec_id;
                DBMS_OUTPUT.PUT_LINE('Update complete');
                DBMS_OUTPUT.PUT_LINE('Name: ' || v_fname || ' ' || v_lname || ' Birthday: ' || v_dob || ' Age: ' || v_age);
            END IF;        
        
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                IF v_counter = 0 THEN
                    DBMS_OUTPUT.PUT_LINE('Student id ' || stud_id || ' is invalid');
                ELSIF v_counter = 1 THEN
                    DBMS_OUTPUT.PUT_LINE('Section id ' || sec_id || ' is invalid');
                ELSIF v_counter = 2 THEN
                    DBMS_OUTPUT.PUT_LINE('This combination does not exist');
                END IF;
    END;
    /
    
    exec sp_p1(1, 1, 'A');
        
        
        
        
        
        
        
