-- connect to user cdes03
show user
SPOOL C:\DB2\simulation_mid_term\sim_mid_term_spool.txt;
SELECT to_char(sysdate, 'DD Month YYYY Day HH:MI:SS Am') FROM dual;

SET SERVEROUTPUT ON

-- Question 1
-- A)
CREATE OR REPLACE FUNCTION your_name_f1(p_date DATE) RETURN NUMBER AS
    v_age NUMBER;
    BEGIN
        v_age := FLOOR((MONTHS_BETWEEN(sysdate, p_date)) / 12);
        RETURN v_age;
    END;
    /

-- B) 
SELECT your_name_f1('2000-October-22') FROM dual;

-- C)
CREATE OR REPLACE PROCEDURE your_name_p1(p_s_id NUMBER, p_sec_id NUMBER, p_grade VARCHAR2) AS
    v_s_last  student.s_last%TYPE;
    v_s_first student.s_first%TYPE;
    v_s_dob   student.s_dob%TYPE;
    v_s_grade enrollment.grade%TYPE;
    v_s_age   NUMBER;
    v_counter NUMBER := 0;
    BEGIN
        IF p_s_id IN (1,2,3,4,5,6) THEN
            SELECT s_first, s_last, s_dob
            INTO v_s_first, v_s_last, v_s_dob
            FROM student
            WHERE s_id = p_s_id;
        END IF;
        
        IF p_sec_id BETWEEN 1 AND 13 THEN
            SELECT grade 
            INTO v_s_grade
            FROM enrollment
            WHERE s_id = p_s_id AND c_sec_id = p_sec_id;
            v_counter := 1;
        END IF;
            
        IF v_s_grade = p_grade THEN
            DBMS_OUTPUT.PUT_LINE('Combination exist. But NO NEED to update!');
        ELSE
            UPDATE enrollment SET grade = p_grade
            WHERE s_id = p_s_id AND c_sec_id = p_sec_id;
            commit;
            v_s_age := your_name_f1(v_s_dob);
            DBMS_OUTPUT.PUT_LINE('First Name: ' || v_s_first || ' Last Name: ' || v_s_last || ' DOB: ' || v_s_dob || ' Age: ' || v_s_age);
        END IF;
        
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    IF v_counter = 0 THEN
      DBMS_OUTPUT.PUT_LINE('Student ID: ' ||p_s_id ||' does not exist!');
    ELSIF v_counter = 1 THEN
      DBMS_OUTPUT.PUT_LINE('Section number ' ||p_sec_id ||' does not exist!');
    END IF;
    END;
    /
    
-- D)
exec your_name_p1(1,1,'A');
        
-- Question 2
CREATE OR REPLACE PROCEDURE your_name_p2 AS
    CURSOR faculty_curr IS
    SELECT f_id, f_first, f_last, f_rank
    FROM faculty;
    
    v_id faculty.f_id%TYPE;
    v_first faculty.f_first%TYPE;
    v_last faculty.f_last%TYPE;
    v_rank faculty.f_rank%TYPE;
    
    CURSOR section_curr(id NUMBER) IS
    SELECT cs.c_sec_id, c.course_name, l.bldg_code, l.room
    FROM course_section cs
    JOIN course c ON c.course_id = cs.course_id
    JOIN location l ON cs.loc_id = l.loc_ID
    WHERE cs.f_id = id;
    
    v_sec_id course_section.c_sec_id%TYPE;
    v_course_name course.course_name%TYPE;
    v_b_code location.bldg_code%TYPE;
    v_room location.room%TYPE;
    
    BEGIN
        OPEN faculty_curr;
        
        FETCH faculty_curr INTO v_id, v_first, v_last, v_rank;
        
        WHILE faculty_curr%FOUND LOOP
            DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------------------------------------');
            DBMS_OUTPUT.PUT_LINE('ID: ' || v_id || ' First Name: ' || v_first || ' Last Name: ' || v_last || ' Rank: ' || v_rank);
            
            OPEN section_curr(v_id);
            
            FETCH section_curr INTO v_sec_id, v_course_name, v_b_code, v_room;
            
            WHILE section_curr%FOUND LOOP
                DBMS_OUTPUT.PUT_LINE('ID: ' || v_sec_id || ' Course Name: ' || v_course_name || ' Building Code: ' || v_b_code || ' Room: ' || v_room);
                FETCH section_curr INTO v_sec_id, v_course_name, v_b_code, v_room;
            END LOOP;
            CLOSE section_curr;
            
            FETCH faculty_curr INTO v_id, v_first, v_last, v_rank;
        END LOOP;
        CLOSE faculty_curr;
    END;
    /
    
exec your_name_p2;
            
            

            
            
            
            
            
            
            
            
            
            

