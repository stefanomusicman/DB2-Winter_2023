--------------------- DATABASE TRIGGER -------------------------

-- Syntax
-- CREATE OR REPLACE TRIGGER name_of_trigger
-- [ BEFORE | AFTER | INSERT | UPDATE | DELETE ]
-- ON name_of_table
-- [ FOR EACH ROW ]
-- [ WHEN (condition) ]

-- connect to des03

-- Example 1: create a tigger to monitor table enrollment by inserting the time
-- and the name of the user who does a DML on the table enrollment. Use a sequence
-- named enrl_audit_seq to record the row number of the table enrl_audit of the 
-- design below:

-- ENRL_AUDIT (row_id, updating_user, updating_time)

CREATE TABLE enrl_audit(row_id NUMBER, updating_user VARCHAR2(30), updating_time DATE);
CREATE SEQUENCE enrl_audit_seq;

CREATE OR REPLACE TRIGGER enrl_audit_trigger
AFTER INSERT OR UPDATE OR DELETE ON enrollment
    BEGIN
        INSERT INTO enrl_audit
        VALUES(enrl_audit_seq.NEXTVAL, user, sysdate);
    END;
/

-- Example 2: Modify table enrl_audit to add column ACTION_PERFORM of type 
-- VARCHAR2 to record the action performed on the table enrollment. Then modify
-- the trigger enrl_audit_trigger to record the action performed accordingly.

ALTER TABLE enrl_audit
ADD (action_performed VARCHAR2(25));

CREATE OR REPLACE TRIGGER enrl_audit_trigger
AFTER INSERT OR UPDATE OR DELETE ON enrollment
    BEGIN
        IF INSERTING THEN
            INSERT INTO enrl_audit
            VALUES(enrl_audit_seq.NEXTVAL, user, sysdate, 'INSERT');
        ELSIF UPDATING THEN
            INSERT INTO enrl_audit
            VALUES(enrl_audit_seq.NEXTVAL, user, sysdate, 'UPDATING');
        ELSIF DELETING THEN
            INSERT INTO enrl_audit
            VALUES(enrl_audit_seq.NEXTVAL, user, sysdate, 'DELETING');
        END IF;
    END;
/

INSERT INTO enrollment
VALUES(1,2,'A');

DELETE FROM enrollment
WHERE S_ID = 1 and c_sec_id = 9;

SELECT row_id, updating_user, TO_CHAR(updating_time, 'DD Month Year HH:MI:SS'), action_performed
FROM enrl_audit;

-- Example 3: Create table and trigger to audit the table enrollment by recording
-- WHEN, WHO AND the old value of the s_id, c_sec_id, and grade in the table of 
-- the design below:

-- enrl_row_audit(row_id, updating_user, updating_time, old_s_id, old_c_sec_id, old_grade);

CREATE TABLE enrl_row_audit(row_id NUMBER, updating_user VARCHAR2(30), updating_time DATE, old_s_id NUMBER, old_c_sec_id NUMBER,
old_grade CHAR(1));

CREATE SEQUENCE enrl_row_audit_seq;

CREATE OR REPLACE TRIGGER enrl_row_trigger
AFTER UPDATE ON enrollment
FOR EACH ROW
    BEGIN
        INSERT INTO enrl_row_audit
        VALUES(enrl_row_audit_seq.NEXTVAL, user, sysdate, :OLD.s_id, :OLD.c_sec_id, :OLD.grade);
    END;
/

UPDATE enrollment
SET grade = 'A' 
WHERE s_id = 3;

commit;

-- Example 4: Modify the trigger enrl_audit_row_trigger to make sure that the
-- trigger will be fired ONLY if the grade exists (IS NOT NULL).

CREATE OR REPLACE TRIGGER enrl_row_trigger
AFTER UPDATE ON enrollment
FOR EACH ROW
WHEN (old.grade IS NOT NULL)
    BEGIN
        INSERT INTO enrl_row_audit
        VALUES(enrl_row_audit_seq.NEXTVAL, user, sysdate, :OLD.s_id, :OLD.c_sec_id, :OLD.grade);
    END;
/

UPDATE enrollment
SET grade = 'A'
WHERE s_id = 5;
