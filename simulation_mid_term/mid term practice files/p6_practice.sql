SET SERVEROUTPUT ON

-- connect to des03
-- Question 1
CREATE OR REPLACE PROCEDURE p6_q1 AS
    CURSOR faculty_curr IS
    SELECT f_id, f_last, f_first, f_rank
    FROM faculty;
    
    v_f_id faculty.f_id%TYPE;
    v_f_last faculty.f_last%TYPE;
    v_f_first faculty.f_first%TYPE;
    v_f_rank faculty.f_rank%TYPE;
    
    CURSOR student_curr(id NUMBER) IS
    SELECT s_id, s_last, s_first, s_dob, s_class
    FROM student
    WHERE f_id = id;
    
    v_s_id student.s_id%TYPE;
    v_s_last student.s_last%TYPE;
    v_s_first student.s_first%TYPE;
    v_s_dob student.s_dob%TYPE;
    v_s_class student.s_class%TYPE;
    
    BEGIN
        OPEN faculty_curr;
        
        FETCH faculty_curr INTO v_f_id, v_f_last, v_f_first, v_f_rank;
        
        WHILE faculty_curr%FOUND LOOP   
            DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------------------------------');
            DBMS_OUTPUT.PUT_LINE('Faculty ID: ' || v_f_id || ' Name: ' || v_f_first || ' ' || v_f_last || ' Rank: ' || v_f_rank);
            
            OPEN student_curr(v_f_id);
            
            FETCH student_curr INTO v_s_id, v_s_last, v_s_first, v_s_dob, v_s_class;
            
            WHILE student_curr%FOUND LOOP
                DBMS_OUTPUT.PUT_LINE('Student ID: ' || v_s_id || ' Name: ' || v_s_first || ' ' || v_s_last || ' DOB: ' || v_s_dob || ' Class: ' ||
                v_s_class);
                
                FETCH student_curr INTO v_s_id, v_s_last, v_s_first, v_s_dob, v_s_class;
            END LOOP;
            CLOSE student_curr;
            
            FETCH faculty_curr INTO v_f_id, v_f_last, v_f_first, v_f_rank;
        END LOOP;
        CLOSE faculty_curr;
    END;
    /
    
    -- TEST
    exec p6_q1;
    
-- connect to des04
-- Question 2
CREATE OR REPLACE PROCEDURE p6_q2 AS
    CURSOR consultant_curr IS
    SELECT c_id, c_first, c_last
    FROM consultant;
    
    v_c_id consultant.c_id%TYPE;
    v_c_first consultant.c_first%TYPE;
    v_c_last consultant.c_last%TYPE;
    
    CURSOR skill_curr(id NUMBER) IS
    SELECT cs.skill_id, cs.certification, s.skill_description
    FROM consultant_skill cs
    JOIN skill s ON cs.skill_id = s.skill_id
    WHERE cs.c_id = id;
    
    v_skill_id consultant_skill.skill_id%TYPE;
    v_cert consultant_skill.certification%TYPE;
    v_skill_desc skill.skill_description%TYPE;
    
    BEGIN
        OPEN consultant_curr;
        
        FETCH consultant_curr INTO v_c_id, v_c_first, v_c_last;
        
        WHILE consultant_curr%FOUND LOOP
            DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------------------------------');
            DBMS_OUTPUT.PUT_LINE('Consultant ID: ' || v_c_id || ' Name: ' || v_c_first || ' ' || v_c_last);
            
            OPEN skill_curr(v_c_id);
            
            FETCH skill_curr INTO v_skill_id, v_cert, v_skill_desc;
            
            WHILE skill_curr%FOUND LOOP
                DBMS_OUTPUT.PUT_LINE('Skill ID: ' || v_skill_id || ' Skill Description: ' || v_skill_desc || ' Certification: ' || v_cert);
                
                FETCH skill_curr INTO v_skill_id, v_cert, v_skill_desc;
            END LOOP;
            CLOSE skill_curr;
            
            FETCH consultant_curr INTO v_c_id, v_c_first, v_c_last;
        END LOOP;
    END;
    /
    
    -- TEST
    exec p6_q2;
            
-- connect to des02
-- Question 3
CREATE OR REPLACE PROCEDURE p6_q3 AS
    CURSOR item_curr IS
    SELECT item_id, item_desc, cat_id
    FROM item;
    
    v_item_id item.item_id%TYPE;
    v_item_desc item.item_desc%TYPE;
    v_cat_id item.cat_id%TYPE;
    
    CURSOR inv_curr(id NUMBER) IS
    SELECT inv_id, color, inv_price, inv_qoh
    FROM inventory
    WHERE item_id = id;
    
    v_inv_id inventory.inv_id%TYPE;
    v_color inventory.color%TYPE;
    v_price inventory.inv_price%TYPE;
    v_qoh inventory.inv_qoh%TYPE;
    
    BEGIN
        OPEN item_curr;
        
        FETCH item_curr INTO v_item_id, v_item_desc, v_cat_id;
        
        WHILE item_curr%FOUND LOOP
            DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------------------------------');
            DBMS_OUTPUT.PUT_LINE('Item ID: ' || v_item_id || ' Description: ' || v_item_desc || ' Category ID: ' || v_cat_id);
            
            OPEN inv_curr(v_item_id);
            
            FETCH inv_curr INTO v_inv_id, v_color, v_price, v_qoh;
            
            WHILE inv_curr%FOUND LOOP
                DBMS_OUTPUT.PUT_LINE('Inventory ID: ' || v_inv_id || ' Color: ' || v_color || ' Price: ' || v_price || ' QOH: ' || v_qoh);
                
                FETCH inv_curr INTO v_inv_id, v_color, v_price, v_qoh;
            END LOOP;
            CLOSE inv_curr;
            
            FETCH item_curr INTO v_item_id, v_item_desc, v_cat_id;
        END LOOP;
        CLOSE item_curr;
    END;
    /
    
    -- TEST
    exec p6_q3;
    
-- Question 4
CREATE OR REPLACE PROCEDURE p6_q4 AS
    CURSOR item_curr IS
    SELECT item_id, item_desc, cat_id
    FROM item;
    
    v_item_id item.item_id%TYPE;
    v_item_desc item.item_desc%TYPE;
    v_cat_id item.cat_id%TYPE;
    
    CURSOR inv_curr(id NUMBER) IS
    SELECT inv_id, color, inv_price, inv_qoh
    FROM inventory
    WHERE item_id = id;
    
    v_inv_id inventory.inv_id%TYPE;
    v_color inventory.color%TYPE;
    v_price inventory.inv_price%TYPE;
    v_qoh inventory.inv_qoh%TYPE;
    
    CURSOR value_curr(id NUMBER) IS
    SELECT inv_qoh, inv_price
    FROM inventory
    WHERE item_id = id;
    
    v_item_price inventory.inv_price%TYPE;
    v_quantity inventory.inv_qoh%TYPE;
    
    v_total_value NUMBER;
    
    BEGIN
        OPEN item_curr;
        
        FETCH item_curr INTO v_item_id, v_item_desc, v_cat_id;
        
        WHILE item_curr%FOUND LOOP
        
            v_total_value := 0;
            OPEN value_curr(v_item_id);
            
            FETCH value_curr INTO v_item_price, v_quantity;
            
            WHILE value_curr%FOUND LOOP
                v_total_value := v_total_value + (v_item_price * v_quantity);
                FETCH value_curr INTO v_item_price, v_quantity;
            END LOOP;
            CLOSE value_curr;             
        
            DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------------------------------');
            DBMS_OUTPUT.PUT_LINE('Item ID: ' || v_item_id || ' Description: ' || v_item_desc || ' Category ID: ' || v_cat_id || ' Total Value: ' 
            || v_total_value);
            
            OPEN inv_curr(v_item_id);
            
            FETCH inv_curr INTO v_inv_id, v_color, v_price, v_qoh;
            
            WHILE inv_curr%FOUND LOOP
                DBMS_OUTPUT.PUT_LINE('Inventory ID: ' || v_inv_id || ' Color: ' || v_color || ' Price: ' || v_price || ' QOH: ' || v_qoh);
                
                FETCH inv_curr INTO v_inv_id, v_color, v_price, v_qoh;
            END LOOP;
            CLOSE inv_curr;
            
            FETCH item_curr INTO v_item_id, v_item_desc, v_cat_id;
        END LOOP;
        CLOSE item_curr;
    END;
    /
    
    -- TEST 
    exec p6_q4;
    
-- connect to des04
-- Question 5
CREATE OR REPLACE PROCEDURE p6_q5(con_id NUMBER, cert VARCHAR2) AS
    v_c_id consultant.c_id%TYPE;
    v_c_first consultant.c_first%TYPE;
    v_c_last consultant.c_last%TYPE;
    
    CURSOR skill_curr(id NUMBER) IS
    SELECT s.skill_description, cs.certification
    FROM consultant_skill cs
    JOIN skill s ON cs.skill_id = s.skill_id
    WHERE cs.c_id = id
    FOR UPDATE OF cs.certification;
    
    v_skill_desc skill.skill_description%TYPE;
    v_cert consultant_skill.certification%TYPE;
    
    BEGIN
        SELECT c_id, c_first, c_last
        INTO v_c_id, v_c_first, v_c_last
        FROM consultant
        WHERE c_id = con_id;
        
        OPEN skill_curr(con_id);
        
        FETCH skill_curr INTO v_skill_desc, v_cert;
        
        DBMS_OUTPUT.PUT_LINE('Consultant ID: ' || v_c_id || ' Name: ' || v_c_first || ' ' || v_c_last);
        WHILE skill_curr%FOUND LOOP
            DBMS_OUTPUT.PUT_LINE('Skill Description: ' || v_skill_desc || ' Old cert: ' || v_cert || ' New Cert: ' || cert);
            UPDATE consultant_skill SET certification = cert
            WHERE CURRENT OF skill_curr;
            
            FETCH skill_curr INTO v_skill_desc, v_cert;
        END LOOP;
        CLOSE skill_curr;
        
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('Consultant ID is invalid');
    END;
    /
    
    -- TEST
    exec p6_q5(101, 'Y');
            
            
    
            
            
            
            
            
            
            
            
            
            
            