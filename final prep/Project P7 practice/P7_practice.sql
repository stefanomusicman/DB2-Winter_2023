-- Question 1
-- connect to des03
-- (f_id, f_last, f_first, f_rank)
-- (s_id, s_last, s_first, birthdate, s_class)
SET SERVEROUTPUT ON
CREATE OR REPLACE PROCEDURE p7q1v2 AS
    CURSOR fac_curr IS
    SELECT f_id, f_last, f_first, f_rank
    FROM faculty;
    
    CURSOR stud_curr(id NUMBER) IS
    SELECT s_id, s_last, s_first, s_dob, s_class
    FROM student
    WHERE f_id = id;
    
    BEGIN
        FOR fac IN fac_curr LOOP
            DBMS_OUTPUT.PUT_LINE('----------------------------------------');
            DBMS_OUTPUT.PUT_LINE('Teacher ID: ' || fac.f_id || ' Teacher Name: ' || fac.f_first || ' ' || fac.f_last || ' Rank: ' || fac.f_rank);
            
            FOR stud IN stud_curr(fac.f_id) LOOP
                DBMS_OUTPUT.PUT_LINE('Student ID: ' || stud.s_id || ' Student Name: ' || stud.s_first || ' ' || stud.s_last || 
                ' Birthdate: ' || stud.s_dob || ' Student Class: ' || stud.s_class);
            END LOOP;
        END LOOP;
    END;
    /
    
    -- TEST
    exec p7q1v2;
    
-- Question 2
-- connect to des04
SET SERVEROUTPUT ON
CREATE OR REPLACE PROCEDURE p7q2v2 AS
    CURSOR con_curr IS
    SELECT c_id, c_last, c_first
    FROM consultant;
    v_con_row con_curr%ROWTYPE;
    
    CURSOR skill_curr(p_c_id NUMBER) IS
    SELECT cs.skill_id, cs.certification, s.skill_description
    FROM consultant_skill cs
    JOIN skill s ON cs.skill_id = s.skill_id
    WHERE cs.c_id = p_c_id;
    v_skill_row skill_curr%ROWTYPE;
    
    BEGIN
        OPEN con_curr;
        
        FETCH con_curr INTO v_con_row;
        
        WHILE con_curr%FOUND LOOP
            DBMS_OUTPUT.PUT_LINE('----------------------------------------');
            DBMS_OUTPUT.PUT_LINE('Consultant ID: ' || v_con_row.c_id || ' Consultant Name: ' || v_con_row.c_first || ' ' || v_con_row.c_last);
            
            OPEN skill_curr(v_con_row.c_id);
            
            FETCH skill_curr INTO v_skill_row;
            
            WHILE skill_curr%FOUND LOOP
                DBMS_OUTPUT.PUT_LINE('Skill ID: ' || v_skill_row.skill_id || ' Skill Description: ' || v_skill_row.skill_description 
                || ' Certification: ' || v_skill_row.certification);
                FETCH skill_curr INTO v_skill_row;
            END LOOP;
            CLOSE skill_curr;
            
            FETCH con_curr INTO v_con_row;
        END LOOP;
        CLOSE con_curr;
    END;
    /
    
    -- TEST 
    exec p7q2v2;
    
-- Question 3
-- connect to des02
SET SERVEROUTPUT ON
-- (item_id, item_desc, cat_id) 
CREATE OR REPLACE PROCEDURE p7q3v2 AS
    BEGIN
        FOR item IN (SELECT item_id, item_desc, cat_id FROM item) LOOP
            DBMS_OUTPUT.PUT_LINE('----------------------------------------');
            DBMS_OUTPUT.PUT_LINE('Item ID: ' || item.item_id || ' Item Description: ' || item.item_desc || ' Cat ID: ' || item.cat_id);
            
            FOR inv IN (SELECT inv_id, inv_price, inv_qoh FROM inventory WHERE item_id = item.item_id) LOOP
                DBMS_OUTPUT.PUT_LINE('Inv ID: ' || inv.inv_id || ' Inventory Price: ' || inv.inv_price || ' QOH: ' || inv.inv_qoh);
            END LOOP;
        END LOOP;
    END;
    /
    
    -- TEST
    exec p7q3v2;

-- Question 4
-- connect to des02
SET SERVEROUTPUT ON
CREATE OR REPLACE PROCEDURE p7q4v2 AS
    v_total_inv_value NUMBER := 0;
    v_value NUMBER;
    
    BEGIN
        FOR item IN (SELECT item_id, item_desc, cat_id FROM item) LOOP
            FOR total_inv IN (SELECT inv_qoh, inv_price FROM inventory WHERE item_id = item.item_id) LOOP
                v_total_inv_value := v_total_inv_value + (total_inv.inv_qoh * total_inv.inv_price);
            END LOOP;
            
            DBMS_OUTPUT.PUT_LINE('----------------------------------------');
            DBMS_OUTPUT.PUT_LINE('Item ID: ' || item.item_id || ' Item Description: ' || item.item_desc || ' Cat ID: ' || item.cat_id || 
            ' Total Inv Value: ' || v_total_inv_value);
            
            FOR inv IN (SELECT inv_id, inv_price, inv_qoh FROM inventory WHERE item_id = item.item_id) LOOP
                v_value := inv.inv_price * inv.inv_qoh;
                DBMS_OUTPUT.PUT_LINE('Inv ID: ' || inv.inv_id || ' Inventory Price: ' || inv.inv_price || ' QOH: ' || inv.inv_qoh 
                || ' Inventory Value: ' || v_value);
            END LOOP;
            
            v_total_inv_value := 0;
        END LOOP;
    END;
    /
    
    -- TEST 
    exec p7q4v2;







            
                
    




