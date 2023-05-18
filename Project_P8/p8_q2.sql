show user
SPOOL C:\DB2\Project_P8\p8_q2_spool.txt;
SELECT to_char(sysdate, 'DD Month YYYY Day HH:MI:SS Am') FROM dual;

SET SERVEROUTPUT ON

-- Question 2
CREATE OR REPLACE PACKAGE consultant_package IS
    PROCEDURE create_new_cert(con_id NUMBER, s_id NUMBER, cert VARCHAR2);
    END;
    /
    
CREATE OR REPLACE PACKAGE BODY consultant_package IS
    PROCEDURE create_new_cert(con_id NUMBER, s_id NUMBER, cert VARCHAR2) AS
        v_con_first consultant.c_first%TYPE;
        v_con_last consultant.c_last%TYPE;
        v_skill_id skill.skill_id%TYPE;
        v_counter NUMBER := 0;
        v_certified VARCHAR2(30);
        BEGIN   
          IF cert = 'Y' OR cert = 'N' THEN
            IF cert = 'Y' THEN
                v_certified := 'CERTIFIED';
            ELSE 
                v_certified := 'Not Yet Certified';
            END IF;
          
            -- VERIFYING THE CONSULTANT ID
            SELECT c_first, c_last
            INTO v_con_first, v_con_last
            FROM consultant
            WHERE c_id = con_id;
            v_counter := 1;
            
            -- VERIFYING THE SKILL ID
            SELECT skill_id
            INTO v_skill_id
            FROM skill
            WHERE skill_id = s_id;
            v_counter := 2;
            
            -- INSERT NEW ROW
            INSERT INTO consultant_skill VALUES(con_id, v_skill_id, cert);
            commit;
            
            DBMS_OUTPUT.PUT_LINE('Consultant ID: ' || con_id || ' Name: ' || v_con_first || ' ' || v_con_last || ' Certification Status: ' 
                                    || v_certified);
        ELSE 
            DBMS_OUTPUT.PUT_LINE('Please enter either Y or N');
        END IF;
        
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                IF v_counter = 0 THEN
                    DBMS_OUTPUT.PUT_LINE('Consultant id ' || con_id || ' is invalid.');
                ELSIF v_counter = 1 THEN
                    DBMS_OUTPUT.PUT_LINE('Skill id ' || s_id || ' is invalid.');
                END IF;
            WHEN DUP_VAL_ON_INDEX THEN
                    DBMS_OUTPUT.PUT_LINE('Already exists');
        END create_new_cert;
    END;
    /
    
    -- TEST
    BEGIN
        consultant_package.create_new_cert(102, 1, 'N');
        consultant_package.create_new_cert(102, 1, 'S');
    END;
    /
            
            
            
            
            
            