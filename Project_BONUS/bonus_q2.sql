SPOOL C:\DB2\Project_BONUS\bonus_q2_spool.txt;
SELECT to_char(sysdate, 'DD Month YYYY Day HH:MI:SS Am') FROM dual;

-- connect to des03
-- Question 2
CREATE OR REPLACE VIEW bonus_q2_view AS
    SELECT s_last, s_first, cs.c_sec_id, cs.sec_num, c.course_name, c.credits
    FROM student, course_section cs, course c
    WHERE cs.course_id = c.course_id;

CREATE SEQUENCE stud_seq;
CREATE SEQUENCE course_sec_seq;
CREATE SEQUENCE course_seq;

CREATE OR REPLACE TRIGGER bonus_q2_view_trigger
INSTEAD OF INSERT OR UPDATE ON bonus_q2_view
    BEGIN
        IF INSERTING THEN
            -- PERFORM INSERT ON STUDENT TABLE
            INSERT INTO student (s_id, s_last, s_first)
            VALUES(stud_seq.NEXTVAL, :NEW.s_last, :NEW.s_first);
            
            -- PERFORM INSERT ON COURSE_SECTION TABLE
            INSERT INTO course_section (c_sec_id, sec_num)
            VALUES(course_sec_seq.NEXTVAL, :NEW.sec_num);
            
            -- PERFORM INSERT ON COURSE TABLE
            INSERT INTO course(course_id, course_name, credits)
            VALUES(course_seq.NEXTVAL, :NEW.course_name, :NEW.credits);
        ELSIF UPDATING THEN
            -- PERFORM UPDATE ON STUDENT TABLE
            UPDATE student 
            SET s_last = :NEW.s_last, s_first = :NEW.s_first
            WHERE s_last = :NEW.s_last;
            
            -- PERFORM UPDATE ON COURSE_SECTION TABLE
            UPDATE course_section
            SET sec_num = :NEW.sec_num
            WHERE c_sec_id = :NEW.c_sec_id;
            
            -- PERFORM UPDATE ON COURSE TABLE
            UPDATE course
            SET course_name = :NEW.course_name, credits = :NEW.credits
            WHERE course_name = :NEW.course_name;
        END IF;
    END;
    /
    