SPOOL C:\DB2\final_exam\final_q3_Q4_spool.txt;
SELECT to_char(sysdate, 'DD Month YYYY Day HH:MI:SS Am') FROM dual;
SET SERVEROUTPUT ON

-- Question 3
-- connect to des04
CREATE OR REPLACE PROCEDURE stefano_q3 IS
    CURSOR project_curr IS
    SELECT p.p_id projectId, p.project_name name, c.c_last lastName
    FROM project p
    JOIN consultant c ON p.mgr_id = c.c_id;
    
    CURSOR consultant_curr(proj_id NUMBER) IS
    SELECT c.c_last last, c.c_first first, pc.roll_on_date rollOn, pc.roll_off_date rollOff
    FROM consultant c 
    JOIN project_consultant pc ON pc.c_id = c.c_id
    WHERE pc.p_id = proj_id;
    
    BEGIN
        FOR project IN project_curr LOOP
            DBMS_OUTPUT.PUT_LINE('-------------------------------------------------');
            DBMS_OUTPUT.PUT_LINE('Project Name: ' || project.name || ' Manager Last Name: ' || project.lastName);
            
            FOR consultant IN consultant_curr(project.projectId) LOOP
                DBMS_OUTPUT.PUT_LINE('Consultant Last Name: ' || consultant.last || ' Consultant First Name: ' || consultant.first ||
                                    ' Roll On Date: ' || consultant.rollOn || ' Roll Off Date: ' || consultant.rollOff);
            END LOOP;
        END LOOP;
    END;
    /

-- TEST
exec stefano_q3;

-- Question 4
--DROP TABLE audit_project_consultant;
CREATE TABLE audit_project_consultant(audit_id NUMBER, project_id NUMBER, consultant_id NUMBER, roll_on_date DATE, roll_off_date DATE, 
                                        date_updated DATE, updating_user VARCHAR2(30));

--DROP SEQUENCE audit_project_consultant_seq;
CREATE SEQUENCE audit_project_consultant_seq;

CREATE OR REPLACE TRIGGER q4_trigger
AFTER UPDATE ON project_consultant
FOR EACH ROW
    BEGIN
        INSERT INTO audit_project_consultant
        VALUES(audit_project_consultant_seq.NEXTVAL, :OLD.p_id, :OLD.c_id, :OLD.roll_on_date, :OLD.roll_off_date, sysdate, user);
    END;
    /
    
-- TEST
UPDATE project_consultant SET p_id = 2 WHERE c_id = 101;









    
