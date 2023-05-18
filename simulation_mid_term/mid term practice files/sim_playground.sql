SET SERVEROUTPUT ON

-- Question 1
-- A)
CREATE OR REPLACE FUNCTION sp_f_1(p_date DATE) RETURN NUMBER AS
    BEGIN
        RETURN FLOOR(MONTHS_BETWEEN(sysdate, p_date) / 12);
    END;
    /

-- B)
SELECT sp_f_1('2000-October-22') FROM dual;
-- expected result: 22

-- C)
CREATE OR REPLACE PROCEDURE sp_p_1(p_s_id NUMBER, p_sec_id NUMBER, p_grade VARCHAR2) AS
    v_fname VARCHAR2(20);
    v_lname VARCHAR2(20);
    v_age NUMBER;
    v_dob DATE;
    v_grade VARCHAR2(10);
    v_sec_id NUMBER;
    v_counter NUMBER := 0;
    BEGIN
        SELECT s_first, s_last, s_dob
        INTO v_fname, v_lname, v_dob
        FROM student
        WHERE s_id = p_s_id;
        v_counter := 1;
        
        SELECT c_sec_id 
        INTO v_sec_id
        FROM course_section
        WHERE c_sec_id = p_sec_id;
        v_counter := 2;
        
        SELECT grade 
        INTO v_grade
        FROM enrollment
        WHERE s_id = p_s_id AND c_sec_id = p_sec_id;
        
        v_age := sp_f_1(v_dob);
        
        IF v_grade = p_grade THEN
            DBMS_OUTPUT.PUT_LINE('The row already exists, no need to update or insert anything!');
            DBMS_OUTPUT.PUT_LINE('Name: ' || v_fname || ' ' || v_lname || ' Birthdate: ' || v_dob || ' Age: ' || v_age);
        ELSE 
            DBMS_OUTPUT.PUT_LINE('Update needed!');
            UPDATE enrollment SET grade = p_grade WHERE s_id = p_s_id AND c_sec_id = p_sec_id;
            DBMS_OUTPUT.PUT_LINE('Student name: ' || v_fname || ' ' || v_lname || ' Birthdate: ' || v_dob || ' Age: ' || v_age);
        END IF;
        
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                IF v_counter = 0 THEN
                    DBMS_OUTPUT.PUT_LINE('Student ID is invalid');
                ELSIF v_counter = 1 THEN
                    DBMS_OUTPUT.PUT_LINE('Section ID is invalid');
                ELSIF v_counter = 2 THEN
                    DBMS_OUTPUT.PUT_LINE('We must create a new row');
                ELSE
                    DBMS_OUTPUT.PUT_LINE('This combination does not exist');
                END IF;
        END;
        /
    
     exec sp_p_1(1, 1, 'A');     
     
-- Question 2
CREATE OR REPLACE PROCEDURE sp_p_2 AS
    CURSOR faculty_curr IS
    SELECT f_id, f_first, f_last
    FROM faculty;
    
    v_f_id faculty.f_id%TYPE;
    v_f_first faculty.f_first%TYPE;
    v_f_last faculty.f_last%TYPE;
    
    CURSOR course_curr(id NUMBER) IS
    SELECT cs.c_sec_id, c.course_name, l.bldg_code, l.room
    FROM course_section cs
    JOIN course c ON c.course_id = cs.course_id
    JOIN location l ON l.loc_id = cs.loc_id
    WHERE cs.f_id = id;
    
    v_sec_id course_section.c_sec_id%TYPE;
    v_course_name course.course_name%TYPE;
    v_bldg_code location.bldg_code%TYPE;
    v_room location.room%TYPE;
    
    BEGIN
        OPEN faculty_curr;
        
        FETCH faculty_curr INTO v_f_id, v_f_first, v_f_last;
        
        WHILE faculty_curr%FOUND LOOP
            DBMS_OUTPUT.PUT_LINE('-------------------------------------');
            DBMS_OUTPUT.PUT_LINE('Faculty ID: ' || v_f_id || ' Name: ' || v_f_first || ' ' || v_f_last);
            
            OPEN course_curr(v_f_id);
            
            FETCH course_curr INTO v_sec_id, v_course_name, v_bldg_code, v_room;
            
            WHILE course_curr%FOUND LOOP
                DBMS_OUTPUT.PUT_LINE('Section ID: ' || v_sec_id || ' Course Name: ' || v_course_name || ' Building Code: ' || v_bldg_code 
                || ' Room: ' || v_room);
                FETCH course_curr INTO v_sec_id, v_course_name, v_bldg_code, v_room;
            END LOOP;
            CLOSE course_curr;
            
            FETCH faculty_curr INTO v_f_id, v_f_first, v_f_last;
        END LOOP;
        CLOSE faculty_curr;
    END;
    /
    
    exec sp_p_2;
    
-- Question 3
CREATE OR REPLACE PROCEDURE sp_p_3 AS
    CURSOR student_curr IS
    SELECT s_id, s_first, s_last, s_dob
    FROM student;
    
    v_s_id student.s_id%TYPE;
    v_s_first student.s_first%TYPE;
    v_s_last student.s_last%TYPE;
    v_s_dob student.s_dob%TYPE;
    
    v_age NUMBER;
    
    BEGIN
        OPEN student_curr;
        
        FETCH student_curr INTO v_s_id, v_s_first, v_s_last, v_s_dob;
        
        WHILE student_curr%FOUND LOOP
            v_age := sp_f_1(v_s_dob);
            DBMS_OUTPUT.PUT_LINE('Name: ' || v_s_first || ' ' || v_s_last || ' Student ID: ' || v_s_id || ' DOB: ' || v_s_dob || ' Age: ' || v_age);
            
            FETCH student_curr INTO v_s_id, v_s_first, v_s_last, v_s_dob;
        END LOOP;
        CLOSE student_curr;
    END;
    /
    
    exec sp_p_3;
            
        






