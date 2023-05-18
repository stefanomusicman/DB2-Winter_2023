-- Question 1
 connect sys/sys as sysdba
 CREATE USER c##dwight IDENTIFIED BY schrute;
 GRANT connect, resource TO c##dwight;
 connect c##dwight/schrute
--c##des02

SPOOL C:\DB2\Project_P10\p10_v2_spool.txt;
SELECT to_char(sysdate, 'DD Month YYYY Day HH:MI:SS Am') FROM dual;

CREATE TABLE cust_audit (row_id NUMBER, 
         updating_user VARCHAR2(30), updating_time DATE);
CREATE SEQUENCE cust_audit_seq;

CREATE OR REPLACE TRIGGER cust_audit_trigger
AFTER INSERT OR UPDATE OR DELETE ON customer
  BEGIN
    INSERT INTO cust_audit
    VALUES(cust_audit_seq.NEXTVAL, user, sysdate);
  END;
/

-- dwight

 SELECT * FROM c##des02.customer;
 UPDATE c##des02.customer
 SET   c_city = 'Montreal'
 WHERE  c_id = 1;
COMMIT;

--c##desc02


SELECT row_id , updating_user , 
       TO_CHAR(updating_time,'DD Month Year HH:MI:SS')
FROM  cust_audit;

-- dwight

INSERT INTO c##des02.customer
VALUES (10, 'schrute', 'Dwight', 'E', to_date('04/09/1953', 'mm/dd/yyyy'), '1000 M Street, Apt. #10', 'Montreal', 'WI', 
'54705', '7155558943', '7155559035', 'harrispe', 'asdfjk');

COMMIT;

--c##desc02


SELECT row_id , updating_user , 
       TO_CHAR(updating_time,'DD Month Year HH:MI:SS')
FROM  cust_audit;
SELECT * FROM customer;

-- dwight
 DELETE FROM c##des02.customer
 WHERE  c_id = 10;
COMMIT;

SPOOL OFF;


---------------------------------
-- Question 2

--c##des02

SPOOL C:\DB2\Project_P10\p10_v2_q2_spool.txt;

SELECT to_char(sysdate,'DD Month Year Day HH:MI:SS Am') FROM dual;
CREATE TABLE order_line_audit (row_id NUMBER, updating_user VARCHAR2(30), updating_time DATE, action_performed VARCHAR2(25));
CREATE SEQUENCE order_line_audit_seq;


CREATE OR REPLACE TRIGGER order_line_audit_trigger
AFTER INSERT OR UPDATE OR DELETE ON order_line
  BEGIN
   IF INSERTING THEN
    INSERT INTO order_line_audit
    VALUES(order_line_audit_seq.NEXTVAL, user, sysdate, 'INSERT');
   ELSIF UPDATING THEN
    INSERT INTO order_line_audit
    VALUES(order_line_audit_seq.NEXTVAL, user, sysdate, 'UPDATE');
   ELSIF DELETING THEN
    INSERT INTO order_line_audit
    VALUES(order_line_audit_seq.NEXTVAL, user, sysdate, 'DELETE');
   END IF;
  END;
/

GRANT SELECT, INSERT, UPDATE , DELETE ON order_line TO dwight;


-- dwight
 SELECT * FROM c##des02.order_line;

UPDATE c##des02.order_line
 SET   ol_quantity = 8
 WHERE  o_id = 1 AND inv_id= 1;


 INSERT INTO c##des02.order_line
 VALUES(1,2,10);


 DELETE FROM c##des02.order_line
 WHERE  o_id = 1  AND inv_id= 1;
COMMIT;

--c##desc02
SELECT row_id , updating_user , 
       TO_CHAR(updating_time,'DD Month Year HH:MI:SS'),
       action_performed 
FROM  order_line_audit;

SPOOL OFF;

------------------------------
-- Question 3

SPOOL C:\DB2\Project_P10\p10_v2_q3_spool.txt;

SELECT to_char(sysdate,'DD Month Year Day HH:MI:SS Am') FROM dual;

CREATE TABLE order_line_row_audit (row_id NUMBER, updating_user VARCHAR2(30), updating_time DATE,old_o_id NUMBER, old_inv_id NUMBER, old_ol_quantity NUMBER);

CREATE SEQUENCE order_line_row_audit_seq;

CREATE OR REPLACE TRIGGER order_line_row_audit_trigger
AFTER UPDATE ON order_line
FOR EACH ROW
BEGIN
  INSERT INTO order_line_row_audit
  VALUES(order_line_row_audit_seq.NEXTVAL, user, sysdate, :OLD.o_id , :OLD.inv_id,
         :OLD.ol_quantity);
END;
/
GRANT SELECT, INSERT, UPDATE , DELETE ON order_line TO dwight;

-- dwight
 SELECT * FROM c##des02.order_line;
 UPDATE c##des02.order_line
 SET   ol_quantity = 36
 WHERE  o_id = 1 AND inv_id= 1;

commit;

--c##desc02
SELECT row_id , updating_user , 
       TO_CHAR(updating_time,'DD Month Year HH:MI:SS'),
       old_ol_quantity , old_o_id , old_inv_id
FROM  order_line_row_audit;


SPOOL OFF;