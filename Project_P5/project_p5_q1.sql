-- CONNECT TO USER cdes03
show user
SPOOL C:\DB2\Project_P5\project_p5_q1__spool.txt;
SELECT to_char(sysdate, 'DD Month YYYY Day HH:MI:SS Am') FROM dual;

SET SERVEROUTPUT ON

-- Question 1
CREATE OR REPLACE PROCEDURE p5_q1 AS
    CURSOR term_info IS
    SELECT term_id, term_desc, status
    FROM term;
    
    v_term_id   term.term_id%TYPE;
    v_term_desc term.term_desc%TYPE;
    v_status    term.status%TYPE;
    
    BEGIN
        OPEN term_info;
        
        FETCH term_info INTO v_term_id, v_term_desc, v_status;
        
        WHILE term_info%FOUND LOOP
        
            DBMS_OUTPUT.PUT_LINE('Term ID: ' || v_term_id || ' Term Description: ' || v_term_desc || ' Term Status: ' || v_status);
            
            FETCH term_info INTO v_term_id, v_term_desc, v_status;
        END LOOP;
        
       CLOSE term_info;
    END;
    /
    
    exec p5_q1;
    
    