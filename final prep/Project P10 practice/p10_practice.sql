SET SERVEROUTPUT ON
-- connect to des02

-- Question 1
CREATE TABLE customer_audit(row_id NUMBER, updating_user VARCHAR2(30), updating_time DATE);
CREATE SEQUENCE customer_audit_seq;

CREATE OR REPLACE TRIGGER customer_audit_trigger
AFTER INSERT OR UPDATE OR DELETE ON CUSTOMER
    BEGIN
        INSERT INTO customer_audit
        VALUES(customer_audit_seq.NEXTVAL, user, sysdate);
    END;
    /
    
-- Question 2
CREATE TABLE order_line_audit(row_id NUMBER, updating_user VARCHAR2(30), updating_time DATE, action VARCHAR2(30));
CREATE SEQUENCE order_line_audit_seq;

CREATE OR REPLACE TRIGGER order_line_audit_trigger
AFTER INSERT OR UPDATE OR DELETE ON order_line
    BEGIN
        IF INSERTING THEN
            INSERT INTO order_line_audit
            VALUES(order_line_audit_seq.NEXTVAL, user, sysdate, 'INSERTING');
        ELSIF UPDATING THEN
            INSERT INTO order_line_audit
            VALUES(order_line_audit_seq.NEXTVAL, user, sysdate, 'UPDATING');
        ELSIF DELETING THEN
            INSERT INTO order_line_audit
            VALUES(order_line_audit_seq.NEXTVAL, user, sysdate, 'DELETING');
        END IF;
    END;
    /

-- Question 3
CREATE TABLE order_line_row_audit(row_id NUMBER, updating_user VARCHAR2(30), updating_time DATE, old_quantity NUMBER);
CREATE SEQUENCE order_line_row_audit_seq;

CREATE OR REPLACE TRIGGER order_line_row_audit_trigger
AFTER UPDATE ON order_line
FOR EACH ROW
    BEGIN   
        INSERT INTO order_line_row_audit
        VALUES(order_line_row_audit_seq.NEXTVAL, user, sysdate, :OLD.ol_quantity);
    END;
    /







