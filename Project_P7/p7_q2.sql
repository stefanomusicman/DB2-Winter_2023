show user
SPOOL C:\DB2\Project_P7\p7_q2_spool.txt;
SELECT to_char(sysdate, 'DD Month YYYY Day HH:MI:SS Am') FROM dual;

SET SERVEROUTPUT ON

-- connect to des04
-- Question 2
CREATE OR REPLACE PROCEDURE p7q2 AS
  CURSOR con_curr IS
  SELECT c_id, c_last, c_first
  FROM   consultant;
  v_con_row con_curr%ROWTYPE;
  
  CURSOR skill_curr (pc_f_id NUMBER) IS
  SELECT cs.skill_id, skill_description, certification
  FROM   skill s, consultant_skill cs
  WHERE  s.skill_id = cs.skill_id
  AND c_id = pc_f_id;
  v_skill_row skill_curr%ROWTYPE;
BEGIN
  OPEN con_curr;
  FETCH con_curr INTO v_con_row;
  WHILE con_curr%FOUND LOOP
    DBMS_OUTPUT.PUT_LINE('---------------------');
    DBMS_OUTPUT.PUT_LINE('Consultant number '|| v_con_row.c_id ||
  ' is ' || v_con_row.c_last || ' ' || v_con_row.c_first ||'.' );
       -- inner cursor
       OPEN skill_curr(v_con_row.c_id);
       FETCH skill_curr INTO v_skill_row;
       WHILE skill_curr%FOUND LOOP
         DBMS_OUTPUT.PUT_LINE('Skill number '|| v_skill_row.skill_id ||
         ' is ' || v_skill_row.skill_description || ' ' || 
     ' Certification? = ' || v_skill_row.certification );
        FETCH skill_curr INTO v_skill_row;
       END LOOP;
       CLOSE skill_curr;

   FETCH con_curr INTO v_con_row;
  END LOOP;
  CLOSE con_curr;
END;
/

exec p7q2;

