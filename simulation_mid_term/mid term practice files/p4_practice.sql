SET SERVEROUTPUT ON

-- CONNECT TO cdes02

-- Question 1
CREATE OR REPLACE PROCEDURE check_nums(num1 IN NUMBER, num2 IN NUMBER, verdict OUT VARCHAR2) AS
    BEGIN
        IF num1 = num2 THEN
            verdict := 'EQUAL';
        ELSE 
            verdict := 'DIFFERENT';
        END IF;
    END;
    /
    
CREATE OR REPLACE PROCEDURE p4_q1(num1 NUMBER, num2 NUMBER) AS
    v_shape VARCHAR2(20);
    v_same_or_diff VARCHAR2(20);
    v_area NUMBER := num1 * num2;
    v_perimeter NUMBER := (2 * num1) + (2 * num2);
    BEGIN
        check_nums(num1, num2, v_same_or_diff);
        
        IF v_same_or_diff = 'EQUAL' THEN
            v_shape := 'sqaure';
        ELSE   
            v_shape := 'rectangle';
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('The area of a ' || v_shape || ' size ' || num1 || ' by ' || num2 || ' is ' || v_area || '. Its perimeter is ' 
        || v_perimeter || '.');
    END;
    /
    
    -- TEST
    exec p4_q1(2,3);
    
-- Question 2
CREATE OR REPLACE PROCEDURE pseudo_fun(num1 IN NUMBER, num2 IN NUMBER, area OUT NUMBER, perimeter OUT NUMBER) AS
    BEGIN
        area := num1 * num2;
        perimeter := (2 * num1) + (2 * num2);
    END;
    /
    
CREATE OR REPLACE PROCEDURE p4_q2(num1 NUMBER, num2 NUMBER) AS
    v_area NUMBER;
    v_perimeter NUMBER;
    v_shape VARCHAR2(20);
    BEGIN
        pseudo_fun(num1, num2, v_area, v_perimeter);
        
        IF num1 = num2 THEN
            v_shape := 'sqaure';
        ELSE   
            v_shape := 'rectangle';
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('The area of a ' || v_shape || ' size ' || num1 || ' by ' || num2 || ' is ' || v_area || '. Its perimeter is ' 
        || v_perimeter || '.');
    END;
    /
    
    -- TEST
    exec p4_q2(2,3);
    
-- Question 3
CREATE OR REPLACE PROCEDURE pseudo_adjust(p_id IN NUMBER, p_increase IN NUMBER, new_price OUT NUMBER, quantity OUT NUMBER) AS
    v_old_price NUMBER;
    v_quantity NUMBER;
    BEGIN
        SELECT inv_price, inv_qoh
        INTO v_old_price, v_quantity
        FROM inventory
        WHERE inv_id = p_id;
        
        new_price := v_old_price + ((v_old_price * p_increase) / 100);
        quantity := v_quantity;
        
        UPDATE inventory SET inv_price = new_price WHERE inv_id = p_id;
    END;
    /
    
CREATE OR REPLACE PROCEDURE p4_q3(p_id NUMBER, p_increase NUMBER) AS
    v_new_price NUMBER;
    v_quantity NUMBER;
    v_inv_value NUMBER;
    BEGIN
        pseudo_adjust(p_id, p_increase, v_new_price, v_quantity);
        
        v_inv_value := v_new_price * v_quantity;
        
        DBMS_OUTPUT.PUT_LINE('Inventory ID: ' || p_id || ' New Price: ' || v_new_price || ' Total Inventory Value: ' || v_inv_value);
    END;
    /
    
    -- TEST 
    exec p4_q3(1, 10);
    









        
        
        
    
