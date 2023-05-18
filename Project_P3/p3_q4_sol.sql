SET SERVEROUTPUT ON
CREATE OR REPLACE PROCEDURE p3q4(p_c_id NUMBER, p_skill_id NUMBER, p_status VARCHAR2) AS
  v_c_last consultant.c_last%TYPE;
  v_c_first consultant.c_first%TYPE;
  v_skill_description skill.skill_description%TYPE;
  v_certification consultant_skill.certification%TYPE;
    v_counter NUMBER := 0;
BEGIN
  IF p_status = 'Y' OR p_status = 'N' THEN
  SELECT c_last, c_first
  INTO   v_c_last, v_c_first
  FROM   consultant
  WHERE  c_id = p_c_id;
    v_counter := 1;
  
  SELECT skill_description
  INTO   v_skill_description
  FROM   skill
  WHERE  skill_id = p_skill_id;
    v_counter := 2;
  SELECT certification
  INTO   v_certification
  FROM   consultant_skill
  WHERE  c_id = p_c_id AND skill_id = p_skill_id;
     IF v_certification = p_status THEN
       DBMS_OUTPUT.PUT_LINE('Combination exist. But NO NEED to update!');
     ELSE
       UPDATE consultant_skill SET certification = p_status
       WHERE  c_id = p_c_id AND skill_id = p_skill_id;
       COMMIT;
       DBMS_OUTPUT.PUT_LINE('Consultant number ' ||p_c_id ||' is ' || v_c_first ||
       ' ' || v_c_last ||'. His skill: ' || v_skill_description || 
       ' has been changed from ' ||v_certification ||' to ' || p_status ||' successfully!');
     END IF; 
     
     ELSE
       DBMS_OUTPUT.PUT_LINE('Please insert Y or N only!');
    END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    IF v_counter = 0 THEN
      DBMS_OUTPUT.PUT_LINE('Consultant number ' ||p_c_id ||' not exist!');
    ELSIF v_counter = 1 THEN
      DBMS_OUTPUT.PUT_LINE('Skill number ' ||p_skill_id ||' not exist!');
    ELSIF v_counter = 2 THEN
      --DBMS_OUTPUT.PUT_LINE('Combination not exist. INSERT needed!');
      INSERT INTO consultant_skill
      VALUES(p_c_id, p_skill_id, p_status);
      COMMIT;
      DBMS_OUTPUT.PUT_LINE('Consultant number ' ||p_c_id ||' is ' || v_c_first ||
       ' ' || v_c_last ||'. His skill: ' || v_skill_description || 
       ' with status = ' ||p_status ||' has been INSERTED successfully!');
    END IF;
END;
/
-- test for status
exec P3Q4(100, 1, 'X')

-- test for c_id
exec P3Q4(999, 1, 'Y')

-- test for skill_id
exec P3Q4(100, 88, 'Y')

-- test for combination c_id, skill_id NO change
exec P3Q4(100, 1, 'Y')

-- test for combination c_id, skill_id Exist , Update needed
exec P3Q4(100, 3, 'Y')

-- test for combination c_id, skill_id NOT Exist , insert needed
exec P3Q4(100, 5, 'N')

-- update
exec P3Q4(100, 5, 'Y')