CREATE OR REPLACE PROCEDURE p6q1 AS
  CURSOR fac_curr IS
    SELECT f_id, f_last, f_first, f_rank
    FROM   faculty;
    v_faculty_row fac_curr%ROWTYPE;
  CURSOR stud_curr (pc_f_id NUMBER) IS
    SELECT s_id, s_last, s_first, s_dob, s_class
    FROM student 
    WHERE f_id = pc_f_id;
    v_student_row stud_curr%ROWTYPE;
BEGIN
  OPEN fac_curr;
  FETCH fac_curr INTO v_faculty_row;
  WHILE fac_curr%FOUND LOOP
    DBMS_OUTPUT.PUT_LINE('---------------------');
    DBMS_OUTPUT.PUT_LINE('Faculty member '|| v_faculty_row.f_id ||
  ' is ' || v_faculty_row.f_last || ' ' || v_faculty_row.f_first ||
   ' Rank = ' ||v_faculty_row.f_rank );
       -- inner cursor
       OPEN stud_curr(v_faculty_row.f_id);
       FETCH stud_curr INTO v_student_row;
       WHILE stud_curr%FOUND LOOP
         DBMS_OUTPUT.PUT_LINE('Student number '|| v_student_row.s_id ||
         ' is ' || v_student_row.s_last || ' ' || v_student_row.s_first ||
        ' Birthdate = ' ||v_student_row.s_dob || ' Class = ' ||
          v_student_row.s_class );
        FETCH stud_curr INTO v_student_row;
       END LOOP;
       CLOSE stud_curr;

   FETCH fac_curr INTO v_faculty_row;
  END LOOP;
  CLOSE fac_curr;
END;
/

set serveroutput on
exec p6q1


 

CREATE OR REPLACE PROCEDURE p6q2 AS
  CURSOR fac_curr IS
    SELECT c_id, c_last, c_first
    FROM   consultant;
    v_faculty_row fac_curr%ROWTYPE;
  CURSOR stud_curr (pc_f_id NUMBER) IS
    SELECT cs.skill_id, skill_description, certification
    FROM   skill s, consultant_skill cs
    WHERE  s.skill_id = cs.skill_id
    AND c_id = pc_f_id;
    v_student_row stud_curr%ROWTYPE;
BEGIN
  OPEN fac_curr;
  FETCH fac_curr INTO v_faculty_row;
  WHILE fac_curr%FOUND LOOP
    DBMS_OUTPUT.PUT_LINE('---------------------');
    DBMS_OUTPUT.PUT_LINE('Consultant number '|| v_faculty_row.c_id ||
  ' is ' || v_faculty_row.c_last || ' ' || v_faculty_row.c_first ||'.' );
       -- inner cursor
       OPEN stud_curr(v_faculty_row.c_id);
       FETCH stud_curr INTO v_student_row;
       WHILE stud_curr%FOUND LOOP
         DBMS_OUTPUT.PUT_LINE('Skill number '|| v_student_row.skill_id ||
         ' is ' || v_student_row.skill_description || ' ' || 
     ' Certification? = ' || v_student_row.certification );
        FETCH stud_curr INTO v_student_row;
       END LOOP;
       CLOSE stud_curr;

   FETCH fac_curr INTO v_faculty_row;
  END LOOP;
  CLOSE fac_curr;
END;
/

set serveroutput on
exec p6q2

SELECT inv_id, inv_price, inv_qoh, color
FROM   inventory
WHERE  item_id = 

CREATE OR REPLACE PROCEDURE p6q3 AS
  CURSOR fac_curr IS
    SELECT item_id, item_desc, cat_id
    FROM   item;
    v_faculty_row fac_curr%ROWTYPE;
  CURSOR stud_curr (pc_f_id NUMBER) IS
    SELECT inv_id, inv_price, inv_qoh, color
    FROM   inventory
    WHERE  item_id = pc_f_id;
    v_student_row stud_curr%ROWTYPE;
BEGIN
  OPEN fac_curr;
  FETCH fac_curr INTO v_faculty_row;
  WHILE fac_curr%FOUND LOOP
    DBMS_OUTPUT.PUT_LINE('---------------------');
    DBMS_OUTPUT.PUT_LINE('Item number '|| v_faculty_row.item_id ||
  ' is ' || v_faculty_row.item_desc || '. ' );
       -- inner cursor
       OPEN stud_curr(v_faculty_row.item_id);
       FETCH stud_curr INTO v_student_row;
       WHILE stud_curr%FOUND LOOP
         DBMS_OUTPUT.PUT_LINE('inventory number '|| v_student_row.inv_id ||
         ' color ' || v_student_row.color || ' Price = ' || 
   v_student_row.inv_price || ' QOH = ' || v_student_row.inv_qoh  );
        FETCH stud_curr INTO v_student_row;
       END LOOP;
       CLOSE stud_curr;

   FETCH fac_curr INTO v_faculty_row;
  END LOOP;
  CLOSE fac_curr;
END;
/

set serveroutput on
exec p6q3



CREATE OR REPLACE PROCEDURE p6q4 AS
  CURSOR fac_curr IS
    SELECT item_id, item_desc, cat_id
    FROM   item;
    v_faculty_row fac_curr%ROWTYPE;
  CURSOR stud_curr (pc_f_id NUMBER) IS
    SELECT inv_id, inv_price, inv_qoh, color
    FROM   inventory
    WHERE  item_id = pc_f_id;
    v_student_row stud_curr%ROWTYPE;
   v_value_inv NUMBER;
   v_value_ITEM NUMBER := 0;
BEGIN
  OPEN fac_curr;
  FETCH fac_curr INTO v_faculty_row;
  WHILE fac_curr%FOUND LOOP
    DBMS_OUTPUT.PUT_LINE('---------------------');
    
       -- inner cursor
       OPEN stud_curr(v_faculty_row.item_id);
       FETCH stud_curr INTO v_student_row;
       WHILE stud_curr%FOUND LOOP
         v_value_inv := v_student_row.inv_price * v_student_row.inv_qoh;
        
           
        FETCH stud_curr INTO v_student_row;
          v_value_ITEM := v_value_ITEM + v_value_inv;  
           
       END LOOP;
       DBMS_OUTPUT.PUT_LINE('Item number '|| v_faculty_row.item_id ||
      ' is ' || v_faculty_row.item_desc ||'. Value Item '|| v_value_ITEM);
           v_value_ITEM := 0;
       CLOSE stud_curr;

-- inner cursor
       OPEN stud_curr(v_faculty_row.item_id);
       FETCH stud_curr INTO v_student_row;
       WHILE stud_curr%FOUND LOOP
         v_value_inv := v_student_row.inv_price * v_student_row.inv_qoh;
         DBMS_OUTPUT.PUT_LINE('inventory number '|| v_student_row.inv_id ||
         ' color ' || v_student_row.color || ' Price = ' || 
   v_student_row.inv_price || ' QOH = ' || v_student_row.inv_qoh ||
             ' Value inv = ' || v_value_inv );
           
        FETCH stud_curr INTO v_student_row;
          v_value_ITEM := v_value_ITEM + v_value_inv;  
           
       END LOOP;
       -- DBMS_OUTPUT.PUT_LINE('Value Item '|| v_value_ITEM);
           v_value_ITEM := 0;
       CLOSE stud_curr;

   FETCH fac_curr INTO v_faculty_row;
  END LOOP;
  CLOSE fac_curr;
END;
/

set serveroutput on
exec p6q4

CREATE OR REPLACE PROCEDURE p6q5(p_c_id NUMBER, p_certi VARCHAR2) AS
    CURSOR consult_curr1 IS
    SELECT c_id, c_last, c_first, c_city
    FROM  consultant 
    WHERE c_id = p_c_id;

    v_consultant_row1 consult_curr1%ROWTYPE;

    CURSOR skill_curr(pc_c_id NUMBER) IS
    SELECT  skill_description, certification
    FROM  skill s, consultant_skill cs
    WHERE cs.skill_id = s.skill_id
    AND   cs.c_id = pc_c_id
    FOR UPDATE OF certification ;

  v_skill_row skill_curr%ROWTYPE;
BEGIN
  OPEN consult_curr1;
  FETCH consult_curr1 INTO v_consultant_row1;
  IF consult_curr1%FOUND THEN
     DBMS_OUTPUT.PUT_LINE('Consultant number '|| v_consultant_row1.c_id ||
         ' is ' || v_consultant_row1.c_last || ' ' || v_consultant_row1.c_first 
  || ' City = ' || v_consultant_row1.c_city);

     OPEN  skill_curr (v_consultant_row1.c_id);
     FETCH skill_curr INTO v_skill_row;
        WHILE skill_curr%FOUND LOOP
            UPDATE consultant_skill
            SET    certification = p_certi
            WHERE CURRENT OF skill_curr;
            DBMS_OUTPUT.PUT_LINE( ' Skill = ' ||
            v_skill_row.skill_description || ' Old Status = ' ||
            v_skill_row.certification || ' NEW Status = ' ||
             p_certi );
        FETCH skill_curr INTO v_skill_row;
       END LOOP;
       CLOSE skill_curr;
  ELSE
    DBMS_OUTPUT.PUT_LINE('Consultant number '|| p_c_id || ' not exist ');
  END IF;
CLOSE consult_curr1;
COMMIT;
END ;
/
set serveroutput on
exec p6q5(100,'N')