show user
SPOOL C:\DB2\Project_P4\project_p4_spool.txt;
SELECT to_char(sysdate, 'DD Month YYYY Day HH:MI:SS Am') FROM dual;

SET SERVEROUTPUT ON

-- CONNECT TO cdes02

-- QUESTION 1
CREATE OR REPLACE PROCEDURE check_nums(length_in IN NUMBER, width_in IN NUMBER, sq_or_rect OUT VARCHAR2) AS
    BEGIN
        IF length_in = width_in THEN
            sq_or_rect := 'EQUAL';
        ELSE 
            sq_or_rect := 'DIFFERENT';
        END IF;
    END;
    /
    
CREATE OR REPLACE PROCEDURE p4_q1(num1 IN NUMBER, num2 IN NUMBER) AS
    v_shape VARCHAR2(20);
    v_area NUMBER := num1 * num2;
    v_perimeter NUMBER := (2 * num1) + (2 * num2);
    BEGIN
        check_nums(num1, num2, v_shape);
    
        IF v_shape = 'EQUAL' THEN
            DBMS_OUTPUT.PUT_LINE('The area of a square size ' || num1 || ' by ' || num2 || ' is ' || v_area || '. It''s perimeter is ' || v_perimeter || '.');
        ELSE 
            DBMS_OUTPUT.PUT_LINE('The area of a rectangle size ' || num1 || ' by ' || num2 || ' is ' || v_area || '. It''s perimeter is ' || v_perimeter || '.');
        END IF;
    END;
    /
    
    -- TEST FOR SQUARE
    exec p4_q1(2,2);
    
    -- TEST FOR RECTANGLE 
    exec p4_q1(2,3);
    
-- QUESTION 2
CREATE OR REPLACE PROCEDURE pseudo_fun(length_in IN NUMBER, width_in IN NUMBER, area OUT NUMBER, perimeter OUT NUMBER) AS
    BEGIN
        area := length_in * width_in;
        perimeter := (2 * length_in) + (2 * width_in);
    END;
    /
    
CREATE OR REPLACE PROCEDURE p4_q2(num1 IN NUMBER, num2 IN NUMBER) AS
    v_area NUMBER;
    v_perimeter NUMBER;
    BEGIN
        pseudo_fun(num1, num2, v_area, v_perimeter);
        
        IF num1 = num2 THEN
            DBMS_OUTPUT.PUT_LINE('The area of a square size ' || num1 || ' by ' || num2 || ' is ' || v_area || '. It''s perimeter is ' || v_perimeter || '.');
        ELSE 
            DBMS_OUTPUT.PUT_LINE('The area of a rectangle size ' || num1 || ' by ' || num2 || ' is ' || v_area || '. It''s perimeter is ' || v_perimeter || '.');
        END IF;
    END;
    /
    
    -- TEST SQUARE
    exec p4_q2(2,2);
    
    -- TEST RECTANGLE 
    exec p4_q2(2,3);
    
-- Question 3
CREATE OR REPLACE PROCEDURE pseudo_adjust(inv_id_in IN NUMBER, percentage_shift IN NUMBER, new_price OUT NUMBER, quantity OUT NUMBER) AS
    v_price NUMBER;
    v_quantity NUMBER;
    BEGIN
        SELECT INV_PRICE, INV_QOH
        INTO v_price, v_quantity
        FROM INVENTORY
        WHERE INV_ID = inv_id_in;
    
        quantity := v_quantity;
        new_price := v_price + ((v_price * percentage_shift) / 100);
    END;
    /
    
CREATE OR REPLACE PROCEDURE p4_q3(inv_id_in IN NUMBER, percentage_shift IN NUMBER) AS
    v_quantity NUMBER;
    v_price NUMBER;
    BEGIN
        pseudo_adjust(inv_id_in, percentage_shift, v_price, v_quantity);
        DBMS_OUTPUT.PUT_LINE('For item number ' || inv_id_in || ' the new price is ' || v_price || ' and the quantity on hand is ' || v_quantity || '.');
        DBMS_OUTPUT.PUT_LINE('The total value is ' || v_quantity * v_price);
    END;
    /
    
    -- TEST
    exec p4_q3(1, 50);






    
    
    
    
    
    
    