show user
SPOOL C:\DB2\mid_term\mid_term.txt;
SELECT to_char(sysdate, 'DD Month YYYY Day HH:MI:SS Am') FROM dual;

SET SERVEROUTPUT ON

-- Question 1
-- A)
CREATE OR REPLACE FUNCTION stefano_f1(num1 NUMBER, num2 NUMBER) RETURN NUMBER AS
    BEGIN
        RETURN num1 * num2;
    END;
    /
    
-- B)
SELECT stefano_f1(2,2) FROM dual;

-- C)
CREATE OR REPLACE FUNCTION stefano_f2(num1 NUMBER, num2 NUMBER) RETURN NUMBER AS
    BEGIN
        RETURN num1 + num2;
    END;
    /
    
-- D)
SELECT stefano_f2(1,1) FROM dual;

-- E)
CREATE OR REPLACE PROCEDURE stefano_p1(p_inv_id NUMBER, p_price_shift NUMBER) AS
    v_id inventory.inv_id%TYPE;
    v_price inventory.inv_price%TYPE;
    v_color inventory.color%TYPE;
    v_qoh inventory.inv_qoh%TYPE;
    v_new_price NUMBER;
    v_inv_value NUMBER;
    v_counter NUMBER := 0;
    BEGIN
        IF p_price_shift > -50 AND p_price_shift < 300 THEN
            SELECT inv_id, inv_price, color, inv_qoh
            INTO v_id, v_price, v_color, v_qoh
            FROM inventory
            WHERE inv_id = p_inv_id;
            v_counter := 1;
            
            v_new_price := stefano_f2(v_price, (v_price * p_price_shift / 100));
            v_inv_value := stefano_f1(v_new_price, v_qoh);
            
            UPDATE inventory SET inv_price = v_new_price WHERE inv_id = p_inv_id;
            commit;
            
            DBMS_OUTPUT.PUT_LINE('Inv ID: ' || v_id || ' Color: ' || v_color || ' Old Price: ' || v_price || ' New Price: ' || v_new_price
                                    || ' New Inventory Value: ' || v_inv_value);
        ELSE 
            DBMS_OUTPUT.PUT_LINE('The price of the item can be shifted by more than 3 times its original price or be shifted by more than half
                                    of its original price');
        END IF;
    
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                IF v_counter = 0 THEN
                    DBMS_OUTPUT.PUT_LINE('CURSOR%NOTFOUND');
                END IF;
    END;
    /
    
    -- TEST
    exec stefano_p1(2, 10);
    exec stefano_p1(1, 400);
    exec stefano_p1(1000000000, 10);
    
-- F)
SET SERVEROUTPUT ON
-- most expensive inventory is inv_id 23
exec stefano_p1(23, 200);

-- Question 2
CREATE OR REPLACE PROCEDURE stefano_p2 AS
    CURSOR source_curr IS
    SELECT os_id, os_desc
    FROM order_source;
    
    v_os_id order_source.os_id%TYPE;
    v_os_desc order_source.os_desc%TYPE;
    
    CURSOR order_curr(id NUMBER) IS
    SELECT o.c_id, inv.inv_price, inv.color, i.item_desc
    FROM orders o
    JOIN order_line ol ON o.o_id = ol.o_id
    JOIN inventory inv ON inv.inv_id = ol.inv_id
    JOIN item i ON inv.item_id = i.item_id
    WHERE o.o_id = id;
    
    v_id orders.c_id%TYPE;
    v_inv_price inventory.inv_price%TYPE;
    v_color inventory.color%TYPE;
    v_desc item.item_desc%TYPE;
    
    BEGIN
        OPEN source_curr;
        
        FETCH source_curr INTO v_os_id, v_os_desc;
        
        WHILE source_curr%FOUND LOOP
            DBMS_OUTPUT.PUT_LINE('------------------------------------');
            DBMS_OUTPUT.PUT_LINE('Order Source ID: ' || v_os_id || ' Order Source Description: ' || v_os_desc);
            
            OPEN order_curr(v_os_id);
            
            FETCH order_curr INTO v_id, v_inv_price, v_color, v_desc;
            
            WHILE order_curr%FOUND LOOP
                DBMS_OUTPUT.PUT_LINE('Order ID: ' || v_id || ' Price: ' || v_inv_price || ' Color: ' || v_color || ' Item desc: ' || v_desc);
                
                FETCH order_curr INTO v_id, v_inv_price, v_color, v_desc;
            END LOOP;
            CLOSE order_curr;
            
            FETCH order_curr INTO v_id, v_inv_price, v_color, v_desc;
        END LOOP;
        CLOSE order_curr;
    END;
    /
    
-- Question 3
CREATE OR REPLACE PROCEDURE stefano_p3 AS
    CURSOR inv_curr IS
    SELECT inv_id, item_id, color, inv_size, inv_price, inv_qoh
    FROM inventory;
    
    v_id inventory.inv_id%TYPE;
    v_item_id inventory.item_id%TYPE;
    v_color inventory.color%TYPE;
    v_size inventory.inv_size%TYPE;
    v_inv_price inventory.inv_price%TYPE;
    v_qoh inventory.inv_qoh%TYPE;
    
    inv_total NUMBER;
    
    BEGIN
        OPEN inv_curr;
        
        FETCH inv_curr INTO v_id, v_item_id, v_color, v_size, v_inv_price, v_qoh;
        
        WHILE inv_curr%FOUND LOOP
            inv_total := stefano_f1(v_inv_price, v_qoh);
            DBMS_OUTPUT.PUT_LINE('Inv ID: ' || v_id || ' Item ID: ' || v_item_id || ' Color: ' || v_color || ' Inv Size: ' || v_size ||
                                ' Inv Price: ' || v_inv_price || ' Total Inv Value: ' || inv_total || ' QOH: ' || v_qoh);
            
            FETCH inv_curr INTO v_id, v_item_id, v_color, v_size, v_inv_price, v_qoh;
        END LOOP;
        CLOSE inv_curr;
    END;
    /
    
    -- TEST
    exec stefano_p3;
                
            














