show user
SPOOL C:\DB2\Project_P7\p7_q3_q4_spool.txt;
SELECT to_char(sysdate, 'DD Month YYYY Day HH:MI:SS Am') FROM dual;

SET SERVEROUTPUT ON

-- connect to des02
-- Question 3
CREATE OR REPLACE PROCEDURE p7q3 AS
BEGIN
  FOR item IN (SELECT item_id, item_desc, cat_id FROM item) LOOP
    DBMS_OUTPUT.PUT_LINE('---------------------');
    DBMS_OUTPUT.PUT_LINE('Item number '|| item.item_id || ' is ' || item.item_desc || '. ' );
       FOR inv IN (SELECT inv_id, inv_price, inv_qoh, color FROM inventory WHERE item_id = item.item_id) LOOP
         DBMS_OUTPUT.PUT_LINE('inventory number '|| inv.inv_id || ' color ' || inv.color || ' Price = ' || inv.inv_price || ' QOH = ' || inv.inv_qoh);
       END LOOP;
  END LOOP;
END;
/

exec p7q3;

-- Question 4
CREATE OR REPLACE PROCEDURE p7q4 AS
    v_value_inv NUMBER;
    v_value_ITEM NUMBER := 0;

BEGIN
  FOR item IN (SELECT item_id, item_desc, cat_id FROM item) LOOP
    FOR inv2 IN (SELECT inv_id, inv_price, inv_qoh, color FROM inventory WHERE item_id = item.item_id) LOOP
        v_value_inv := inv2.inv_price * inv2.inv_qoh;
        v_value_ITEM := v_value_ITEM + v_value_inv;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('---------------------');
    DBMS_OUTPUT.PUT_LINE('Item number '|| item.item_id || ' is ' || item.item_desc || '. Value Item '|| v_value_ITEM);
       FOR inv IN (SELECT inv_id, inv_price, inv_qoh, color FROM inventory WHERE item_id = item.item_id) LOOP
         v_value_inv := inv.inv_price * inv.inv_qoh;
         DBMS_OUTPUT.PUT_LINE('inventory number '|| inv.inv_id || ' color ' || inv.color || ' Price = ' || inv.inv_price || ' QOH = ' || 
         inv.inv_qoh || ' Value inv = ' || v_value_inv );
       END LOOP;
       v_value_ITEM := 0;
  END LOOP;
END;
/

exec p7q4;











