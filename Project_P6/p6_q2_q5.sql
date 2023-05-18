-- Connect to des04
show user
SPOOL C:\DB2\Project_P6\p6_q2_spool.txt;
SELECT to_char(sysdate, 'DD Month YYYY Day HH:MI:SS Am') FROM dual;

SET SERVEROUTPUT ON

-- Question 2
CREATE OR REPLACE PROCEDURE p6_q2 AS
    CURSOR con_cursor IS
    SELECT c_id, c_first, c_last
    FROM consultant;
    
    v_c_id    consultant.c_id%TYPE;
    v_c_first consultant.c_first%TYPE;
    v_c_last  consultant.c_last%TYPE;
    
    CURSOR skill_cursor(p_c_id consultant.c_id%TYPE) IS
    SELECT skill.skill_description, consultant_skill.certification
    FROM consultant_skill
    JOIN skill ON consultant_skill.skill_id = skill.skill_id
    WHERE consultant_skill.c_id = p_c_id;
    
    v_s_desc skill.skill_description%TYPE;
    v_s_cert consultant_skill.certification%TYPE;
    
    BEGIN
        OPEN con_cursor;
        
        FETCH con_cursor INTO v_c_id, v_c_first, v_c_last;
        
        WHILE con_cursor%FOUND LOOP
            DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------------------------------');
            DBMS_OUTPUT.PUT_LINE('Consultant ID: ' || v_c_id || ' First Name: ' || v_c_first || ' Last Name: ' || v_c_last);
            
            OPEN skill_cursor(v_c_id);
            
            FETCH skill_cursor INTO v_s_desc, v_s_cert;
            
            WHILE skill_cursor%FOUND LOOP
                DBMS_OUTPUT.PUT_LINE('Skill Description: ' || v_s_desc || ' Certification: ' || v_s_cert);
                
                FETCH skill_cursor INTO v_s_desc, v_s_cert;
            END LOOP;
            CLOSE skill_cursor;
            
            FETCH con_cursor INTO v_c_id, v_c_first, v_c_last;
        END LOOP;
        
        CLOSE con_cursor;
    END;
    /
    
    exec p6_q2;
        
        
-- Question 5
CREATE OR REPLACE PROCEDURE p6_q5(p_id NUMBER, p_char VARCHAR2) AS
    CURSOR con_curr IS
    SELECT c_id, c_first, c_last
    FROM consultant
    WHERE c_id = p_id;
    
    v_id         consultant.c_id%TYPE;
    v_first_name consultant.c_first%TYPE;
    v_last_name  consultant.c_last%TYPE;
    
    CURSOR skill_curr(id NUMBER) IS
    SELECT s.skill_description, ck.certification
    FROM consultant_skill ck
    JOIN skill s on ck.skill_id = s.skill_id
    WHERE ck.c_id = id
    FOR UPDATE OF ck.certification;
    
    v_skill skill.skill_description%TYPE;
    v_cert  consultant_skill.certification%TYPE;
    
    BEGIN
        OPEN con_curr;
        
        FETCH con_curr INTO v_id, v_first_name, v_last_name;
        
        WHILE con_curr%FOUND LOOP
            DBMS_OUTPUT.PUT_LINE('Consultant ID: ' || v_id || ' First Name: ' || v_first_name || ' Last Name: ' || v_last_name);
            
            OPEN skill_curr(v_id);
            
            FETCH skill_curr INTO v_skill, v_cert;
            
            WHILE skill_curr%FOUND LOOP
                DBMS_OUTPUT.PUT_LINE('Skill Description: ' || v_skill || ' Old cert: ' || v_cert || ' New Cert: ' || p_char);
                UPDATE consultant_skill SET certification = p_char
                WHERE CURRENT OF skill_curr;
                FETCH skill_curr INTO v_skill, v_cert;
            END LOOP;
            CLOSE skill_curr;
            commit;
            FETCH con_curr INTO v_id, v_first_name, v_last_name;
        END LOOP;
        CLOSE con_curr;
    END;
    /
    
    -- TEST
    exec p6_q5(100, 'Y');
            
                
        
        
    
    
    
        
        
        
        
        
        
        