show user
SPOOL C:\DB2\Project_P7\p7_q1_spool.txt;
SELECT to_char(sysdate, 'DD Month YYYY Day HH:MI:SS Am') FROM dual;

SET SERVEROUTPUT ON

-- connect to des03
-- Question 1
CREATE OR REPLACE PROCEDURE p7q1 AS
  CURSOR fac_curr IS
  SELECT f_id, f_last, f_first, f_rank
  FROM   faculty;

  CURSOR stud_curr (pc_f_id NUMBER) IS
  SELECT s_id, s_last, s_first, s_dob, s_class
  FROM student 
  WHERE f_id = pc_f_id;

BEGIN
  FOR fac IN fac_curr LOOP
    DBMS_OUTPUT.PUT_LINE('---------------------');
    DBMS_OUTPUT.PUT_LINE('Faculty member '|| fac.f_id ||
  ' is ' || fac.f_last || ' ' || fac.f_first ||
   ' Rank = ' ||fac.f_rank );
       -- inner cursor
       FOR stud IN stud_curr(fac.f_id) LOOP
         DBMS_OUTPUT.PUT_LINE('Student number '|| stud.s_id ||
         ' is ' || stud.s_last || ' ' || stud.s_first ||
        ' Birthdate = ' ||stud.s_dob || ' Class = ' ||
          stud.s_class );
       END LOOP;
  END LOOP;
END;
/

exec p7q1;