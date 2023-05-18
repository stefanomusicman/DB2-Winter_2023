SPOOL C:\DB2\Project_BONUS\bonus_q12_spool.txt;
SELECT to_char(sysdate, 'DD Month YYYY Day HH:MI:SS Am') FROM dual;

-- Question 1
-- connect to des02
CREATE OR REPLACE VIEW item_view AS
    SELECT i.item_desc, inv.item_id, inv.inv_price, inv.color, inv.inv_id, inv.inv_size
    FROM inventory inv, item i
    WHERE inv.item_id = i.item_id;

CREATE SEQUENCE inv_seq;
CREATE SEQUENCE item_seq;
    
CREATE OR REPLACE TRIGGER item_view_trigger
INSTEAD OF UPDATE OR INSERT ON item_view
FOR EACH ROW
    BEGIN  
        IF INSERTING THEN
            -- perform insert on inventory table
            INSERT INTO inventory (item_id, inv_price, color, inv_size)
            VALUES (inv_seq.NEXTVAL, :new.inv_price, :new.color, :new.inv_size);
            
            -- perform insert on item table
            INSERT INTO item(item_id, item_desc)
            VALUES (item_seq.NEXTVAL, :NEW.item_desc);
        ELSIF UPDATING THEN
            -- perform update on inventory table
            UPDATE inventory
            SET inv_price = :new.inv_price,
            color = :new.color,
            inv_size = :new.inv_size
            WHERE inv_id = :new.inv_id;
            
            -- perform update on item table
            UPDATE item
            SET item_desc = :NEW.item_desc
            WHERE item_id = :NEW.item_id;
        END IF;
    END;
    /