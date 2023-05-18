-- Connect to des02
show user
SPOOL C:\DB2\Project_P6\p6_q3-q4_spool.txt;
SELECT to_char(sysdate, 'DD Month YYYY Day HH:MI:SS Am') FROM dual;

SET SERVEROUTPUT ON

-- Question 3
CREATE OR REPLACE PROCEDURE p6_q3 AS
    CURSOR item_cursor IS
    SELECT item_id, item_desc, cat_id
    FROM item;
    
    v_item_id   item.item_id%TYPE;
    v_item_desc item.item_desc%TYPE;
    v_cat_id    item.cat_id%TYPE;
    
    CURSOR inventory_cursor(p_item_id item.item_id%TYPE) IS
    SELECT inv_id, color, inv_size, inv_price, inv_qoh
    FROM inventory
    WHERE item_id = p_item_id;
    
    v_inv_id    inventory.inv_id%TYPE;
    v_color     inventory.color%TYPE;
    v_inv_size  inventory.inv_size%TYPE;
    v_inv_price inventory.inv_price%TYPE;
    v_inv_qoh   inventory.inv_qoh%TYPE;
    
    BEGIN
        OPEN item_cursor;
        
        FETCH item_cursor INTO v_item_id, v_item_desc, v_cat_id;
        
        WHILE item_cursor%FOUND LOOP
            DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------------------------------');
            DBMS_OUTPUT.PUT_LINE('Item ID: ' || v_item_id || ' Description: ' || v_item_desc || ' Category ID: ' || v_cat_id);
            
            OPEN inventory_cursor(v_item_id);
            
            FETCH inventory_cursor INTO v_inv_id, v_color, v_inv_size, v_inv_price, v_inv_qoh;
            
            WHILE inventory_cursor%FOUND LOOP
                DBMS_OUTPUT.PUT_LINE('Inventory ID: ' || v_inv_id || ' Color: ' || v_color || ' Inventory Size: ' || v_inv_size ||
                ' Inventory Price: ' || v_inv_price || ' QOH: ' || v_inv_qoh);
                
                FETCH inventory_cursor INTO v_inv_id, v_color, v_inv_size, v_inv_price, v_inv_qoh;
            END LOOP;
            CLOSE inventory_cursor;
            
            FETCH item_cursor INTO v_item_id, v_item_desc, v_cat_id;
        END LOOP;        
        CLOSE item_cursor;
    END;
    /
    
    exec p6_q3;
    
-- Question 4
CREATE OR REPLACE PROCEDURE p6_q3 AS
    v_total_value NUMBER;

    CURSOR item_cursor IS
    SELECT item_id, item_desc, cat_id
    FROM item;
    
    v_item_id   item.item_id%TYPE;
    v_item_desc item.item_desc%TYPE;
    v_cat_id    item.cat_id%TYPE;
    
    CURSOR inventory_cursor(p_item_id item.item_id%TYPE) IS
    SELECT inv_id, color, inv_size, inv_price, inv_qoh
    FROM inventory
    WHERE item_id = p_item_id;
    
    v_inv_id    inventory.inv_id%TYPE;
    v_color     inventory.color%TYPE;
    v_inv_size  inventory.inv_size%TYPE;
    v_inv_price inventory.inv_price%TYPE;
    v_inv_qoh   inventory.inv_qoh%TYPE;
    
    CURSOR value_cursor(p_item_id item.item_id%TYPE) IS
    SELECT inv_qoh, inv_price
    FROM inventory
    WHERE item_id = p_item_id;
    
    v_qoh   inventory.inv_qoh%TYPE;
    v_price inventory.inv_price%TYPE;
    
    BEGIN
        OPEN item_cursor;
        
        FETCH item_cursor INTO v_item_id, v_item_desc, v_cat_id;
        
        WHILE item_cursor%FOUND LOOP
            v_total_value := 0;
            OPEN value_cursor(v_item_id);
            
            FETCH value_cursor INTO v_qoh, v_price;
            
            WHILE value_cursor%FOUND LOOP
                v_total_value := v_total_value + (v_qoh * v_price);
                FETCH value_cursor INTO v_qoh, v_price;
            END LOOP;
            CLOSE value_cursor;
        
            DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------------------------------');
            DBMS_OUTPUT.PUT_LINE('Item ID: ' || v_item_id || ' Description: ' || v_item_desc || ' Total Value: ' || v_total_value 
            || ' Category ID: ' || v_cat_id);
            
            OPEN inventory_cursor(v_item_id);
            
            FETCH inventory_cursor INTO v_inv_id, v_color, v_inv_size, v_inv_price, v_inv_qoh;
            
            WHILE inventory_cursor%FOUND LOOP
                DBMS_OUTPUT.PUT_LINE('Inventory ID: ' || v_inv_id || ' Color: ' || v_color || ' Inventory Size: ' || v_inv_size ||
                ' Inventory Price: ' || v_inv_price || ' QOH: ' || v_inv_qoh);
                
                FETCH inventory_cursor INTO v_inv_id, v_color, v_inv_size, v_inv_price, v_inv_qoh;
            END LOOP;
            CLOSE inventory_cursor;
            
            FETCH item_cursor INTO v_item_id, v_item_desc, v_cat_id;
        END LOOP;        
        CLOSE item_cursor;
    END;
    /
    
    exec p6_q3;


                
    
    




