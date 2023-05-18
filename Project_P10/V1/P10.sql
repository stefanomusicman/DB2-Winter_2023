show user
SPOOL C:\DB2\Project_P10\p10_spool.txt;
SELECT to_char(sysdate, 'DD Month YYYY Day HH:MI:SS Am') FROM dual;

SET SERVEROUTPUT ON

DROP TABLE customer_audit;
DROP TABLE order_line_row_audit;

-- Question 1
CREATE TABLE customer_audit(row_id NUMBER, updating_user VARCHAR2(30), updating_time DATE);
CREATE SEQUENCE customer_audit_seq;

CREATE OR REPLACE TRIGGER customer_audit_trigger
AFTER INSERT OR UPDATE OR DELETE ON customer
    BEGIN
        INSERT INTO customer_audit
        VALUES(customer_audit_seq.NEXTVAL, user, sysdate);
    END;
/

-- TEST
UPDATE customer SET c_city = 'Manhattan' WHERE c_id = 27;

-- Question 2
ALTER TABLE customer_audit
ADD (action_performed VARCHAR2(25));

CREATE OR REPLACE TRIGGER customer_audit_trigger
AFTER INSERT OR UPDATE OR DELETE ON customer
    BEGIN
        IF INSERTING THEN
            INSERT INTO customer_audit
            VALUES(customer_audit_seq.NEXTVAL, user, sysdate, 'INSERT');
        ELSIF UPDATING THEN
            INSERT INTO customer_audit
            VALUES(customer_audit_seq.NEXTVAL, user, sysdate, 'UPDATING');
        ELSIF DELETING THEN
            INSERT INTO customer_audit
            VALUES(customer_audit_seq.NEXTVAL, user, sysdate, 'DELETING');
        END IF;
    END;
/

-- TEST
UPDATE customer SET c_city = 'Los Angeles' WHERE c_id = 28;
exec customer_package.customer_insert('Scott', 'Nathan', sysdate);
DELETE FROM customer WHERE c_last = 'Scott';

-- Question 3
CREATE TABLE order_line_row_audit(row_id NUMBER, updating_user VARCHAR2(30), updating_time DATE, old_quantity NUMBER);

CREATE SEQUENCE order_line_audit_seq;

CREATE OR REPLACE TRIGGER order_line_trigger
AFTER UPDATE ON order_line
FOR EACH ROW
    BEGIN
        INSERT INTO order_line_row_audit
        VALUES(order_line_audit_seq.NEXTVAL, user, sysdate, :OLD.ol_quantity);
    END;
/

-- TEST
UPDATE order_line SET ol_quantity = 4 WHERE o_id = 2;







