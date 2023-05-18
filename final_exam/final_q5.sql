SPOOL C:\DB2\final_exam\final_q5_spool.txt;
SELECT to_char(sysdate, 'DD Month YYYY Day HH:MI:SS Am') FROM dual;
SET SERVEROUTPUT ON

-- Question 5
-- connect to des03
CREATE OR REPLACE PROCEDURE stefano_q5(stud_id NUMBER, c_section_id NUMBER, p_grade VARCHAR2) AS
    v_first VARCHAR2(30);
    v_last VARCHAR2(30);
    v_counter NUMBER := 0;
    v_grade enrollment.grade%TYPE;
    v_course VARCHAR2(30);
    BEGIN
        SELECT s_last, s_first
        INTO v_last, v_first
        FROM student
        WHERE s_id = stud_id;
        v_counter := 1;
        
        SELECT c.course_name
        INTO v_course
        FROM course c
        JOIN course_section cs ON c.course_id = cs.course_id
        WHERE cs.c_sec_id = c_section_id;
        v_counter := 2;
        
        SELECT grade
        INTO v_grade
        FROM enrollment
        WHERE s_id = stud_id AND c_sec_id = c_section_id;
        
        IF v_grade = p_grade THEN
            DBMS_OUTPUT.PUT_LINE('Row already exists, there is no need to UPDATE or INSERT anything.');
        ELSE 
            UPDATE enrollment
            SET grade = v_grade
            WHERE s_id = stud_id AND c_sec_id = c_section_id;
            commit;
            DBMS_OUTPUT.PUT_LINE('DML Performed: UPDATE ' || ' Course Name: ' || v_course || ' Student: ' || v_first || ' ' || v_last);
        END IF;
        
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                IF v_counter = 0 THEN
                    DBMS_OUTPUT.PUT_LINE('Student id ' || stud_id || ' is invalid.');
                ELSIF v_counter = 1 THEN
                    DBMS_OUTPUT.PUT_LINE('Course section id ' || c_section_id || ' is invalid.');
                ELSIF v_counter = 2 THEN
                    INSERT INTO enrollment
                    VALUES(stud_id, c_section_id, p_grade);
                    commit;
                    DBMS_OUTPUT.PUT_LINE('DML Performed: INSERT ' || ' Course Name: ' || v_course || ' Student: ' || v_first || ' ' || v_last);
                END IF;
    END;
    /
    
-- TEST
exec stefano_q5(1, 2, 'B');
exec stefano_q5(1, 3, 'A');






