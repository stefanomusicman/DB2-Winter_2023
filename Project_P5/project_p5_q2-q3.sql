-- CONNECT TO USER cdes02
show user
SPOOL C:\DB2\Project_P5\project_p5_q2-q3__spool.txt;
SELECT to_char(sysdate, 'DD Month YYYY Day HH:MI:SS Am') FROM dual;

SET SERVEROUTPUT ON

-- Question 2
-- Display the following information: Item description, price, color, and quantity on hand. 
CREATE OR REPLACE PROCEDURE p5_q2 AS
    CURSOR inv_info IS
    SELECT item.item_desc, inventory.inv_price, inventory.color, inventory.inv_qoh
    FROM inventory
    JOIN item ON item.item_id = inventory.item_id;
    
    v_item_desc item.item_desc%TYPE;
    v_inv_price inventory.inv_price%TYPE;
    v_inv_color inventory.color%TYPE;
    v_inv_qoh inventory.inv_qoh%TYPE;
    
    BEGIN
        OPEN inv_info;
        
        FETCH inv_info INTO v_item_desc, v_inv_price, v_inv_color, v_inv_qoh;
        
        WHILE inv_info%FOUND LOOP
            DBMS_OUTPUT.PUT_LINE('Item Description: ' || v_item_desc || ' Inventory Price: ' || v_inv_price || ' Color: ' || v_inv_color || ' Quantity: ' || v_inv_qoh);
            
            FETCH inv_info INTO v_item_desc, v_inv_price, v_inv_color, v_inv_qoh;
        END LOOP;
        CLOSE inv_info;
    END;
    /
    
    exec p5_q2;
    
-- Question 3
CREATE OR REPLACE PROCEDURE p5_q3(increase_in NUMBER) AS
    CURSOR price_info IS
    SELECT item_id, inv_price
    FROM inventory
    GROUP BY item_id, inv_price;
    
    v_item_id   inventory.item_id%TYPE;
    v_old_price inventory.inv_price%TYPE;
    v_new_price inventory.inv_price%TYPE;
            
    BEGIN
        OPEN price_info;
        
        FETCH price_info INTO v_item_id, v_old_price;
        
        WHILE price_info%FOUND LOOP
            v_new_price := v_old_price + ((v_old_price * increase_in) / 100);
            DBMS_OUTPUT.PUT_LINE('Item ID: ' || v_item_id || ' Old Price: ' || v_old_price || ' New Price: ' || v_new_price);
            UPDATE inventory SET inv_price = v_new_price WHERE item_id = v_item_id;
            COMMIT;
            FETCH price_info INTO v_item_id, v_old_price;
        END LOOP;
        CLOSE price_info;
    END;
    /
    
    exec p5_q3(10);
            
            
            