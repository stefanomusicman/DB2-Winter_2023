SET SERVEROUTPUT ON
-------------------------- Package ----------------------------------

-- Why do we need them?
--      - Global Variables
--      - Overloading PROCEDURE / FUNCTION
--      - Performance

-- Packages are made up of 2 parts
--      - PACKAGE SPECIFICATION
--      - PACKAGE BODY

-- 1/ PACKAGE SPECIFICATION
--  Syntax:
--      CREATE OR REPLACE PACKAGE name_of_package IS
--          global variable declaration
--          global cursor declaration
--          PROCEDURE / FUNCTION declaration
--      END;
--      /

-- Example 1: Using application clearwater, create a package specification
-- named order_package with 2 variables of type NUMBER name global_qiantity and global_inv_id.
CREATE OR REPLACE PACKAGE order_package IS
    global_quantity NUMBER;
    global_inv_id NUMBER;
END;
/

-- Example 2: Create an anonimous block to assign number 10 to the variable
-- global_quantity and number 32 to variable global_inv_id.

BEGIN
    order_package.global_quantity := 10;
    order_package.global_inv_id := 32;
END;
/

-- Example 3: Create a PROCEDURE named afficher_valeur to display the contents
-- of the 2 global variables as follows:
    -- Ciro would like to buy X of inventory number Y.
    -- where X = global_quantity, and Y = global_inv_id
    
CREATE OR REPLACE PROCEDURE afficher_valeur AS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Ciro would like to buy ' || order_package.global_quantity || ' of inventory number ' || order_package.global_inv_id
        || '.');
    END;
    /
    
    exec afficher_valeur;

-- Up to now the package can be called BODYLESS package.

-------------- Add PROCEDURE / FUNCTION to the package

-- Example 4: Modify the order_package by adding procedure create_new_order
-- which accepts 3 params: customer id, method of payment and source id to insert 
-- a new row into table orders and procedure create_new_order_line to insert the details
-- of the order using the global variables global_quantity and global_inv_id.

CREATE OR REPLACE PACKAGE order_package IS
     global_quantity NUMBER;
     global_inv_id   NUMBER;
     PROCEDURE create_new_order(p_customer_id NUMBER,
       p_meth_pmt VARCHAR2, p_os_id NUMBER) ;
     PROCEDURE create_new_order_line(p_order_id NUMBER);
   END;
   /

-- 2/ Package Body

-- Syntax:
--      CREATE OR REPLACE PACKAGE BODY name_of_package IS
--          private variable 
--          Unit Program code (coding of PROCEDURE / FUNCTION
--      END;
--      /

-- Example 5: Create a sequence named order_sequence that starts with number 7
-- and program the 2 procedures of the order_package to insert a new order and
-- its details using the 2 global variables for the table order_line.

CREATE SEQUENCE order_sequence START WITH 7;

CREATE OR REPLACE PACKAGE BODY order_package IS   
     PROCEDURE create_new_order(p_customer_id NUMBER,
       p_meth_pmt VARCHAR2, p_os_id NUMBER) AS
         v_order_id NUMBER;
     BEGIN
       SELECT order_sequence.NEXTVAL
       INTO v_order_id
       FROM  dual ;
       INSERT INTO orders
       VALUES(v_order_id, sysdate, p_meth_pmt, 
              p_customer_id, p_os_id);
       COMMIT;
       create_new_order_line(v_order_id);
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
  order_package.global_quantity := 999;
  order_package.global_inv_id := 25;
END;
/

BEGIN
  order_package.create_new_order(2,'CASH',1);
END;
/


---------- REMOVING PACKAGE BODY -----
-- DROP PACKAGE BODY order_package;

---------- REMOVING THE ENTIRE PACKAGE
-- DROP PACKAGE order_package;









