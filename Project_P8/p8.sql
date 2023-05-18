show user
SPOOL C:\DB2\Project_P8\p8_spool.txt;
SELECT to_char(sysdate, 'DD Month YYYY Day HH:MI:SS Am') FROM dual;

SET SERVEROUTPUT ON

-- connect to des02
-- Question 1
CREATE OR REPLACE PACKAGE order_package IS
     global_quantity NUMBER;
     global_inv_id   NUMBER;
     PROCEDURE create_new_order(p_customer_id NUMBER,
       p_meth_pmt VARCHAR2, p_os_id NUMBER) ;
     PROCEDURE create_new_order_line(p_order_id NUMBER);
   END;
   /

--DROP SEQUENCE order_sequence_test;
CREATE SEQUENCE order_sequence_test START WITH 7;
   
CREATE OR REPLACE PACKAGE BODY order_package IS   
     PROCEDURE create_new_order(p_customer_id NUMBER,
       p_meth_pmt VARCHAR2, p_os_id NUMBER) AS
         v_order_id NUMBER;
         v_current_qoh NUMBER;
         v_leftover NUMBER;
     BEGIN
       SELECT order_sequence_test.NEXTVAL
       INTO v_order_id
       FROM  dual ;
       
       -- get current quantity on hand of inventory
       SELECT inv_qoh
       INTO v_current_qoh
       FROM inventory
       WHERE inv_id = order_package.global_inv_id;
       
       IF v_current_qoh = 0 THEN
            DBMS_OUTPUT.PUT_LINE(p_os_id || ' items of inventory id ' || order_package.global_inv_id || ' will be available tomorrow'); 
       ELSIF order_package.global_quantity <= v_current_qoh THEN
            INSERT INTO orders
            VALUES(v_order_id, sysdate, p_meth_pmt, 
                    p_customer_id, p_os_id);
            UPDATE inventory SET inv_qoh = v_current_qoh - order_package.global_quantity WHERE inv_id = order_package.global_inv_id;
            COMMIT;
            create_new_order_line(v_order_id);
       ELSIF order_package.global_quantity > v_current_qoh THEN
            v_leftover := order_package.global_quantity - v_current_qoh;
            INSERT INTO orders
            VALUES(v_order_id, sysdate, p_meth_pmt, 
                    p_customer_id, p_os_id);
            UPDATE inventory SET inv_qoh = 0 WHERE inv_id = order_package.global_inv_id;
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('The remaining ' || v_leftover || ' items of inventory id ' || order_package.global_inv_id 
            || ' will be available tomorrow'); 
            create_new_order_line(v_order_id);
       END IF;
     END create_new_order;

     PROCEDURE create_new_order_line(p_order_id NUMBER) AS
     BEGIN
       INSERT INTO order_line
       VALUES(p_order_id, global_inv_id, global_quantity);
       COMMIT;
     END create_new_order_line;
   END;
   /
   
BEGIN
  order_package.global_quantity := 17;
  order_package.global_inv_id := 1;
END;
/

BEGIN
  order_package.create_new_order(1,'CC',2);
END;
/





