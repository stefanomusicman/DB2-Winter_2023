SET SERVEROUTPUT ON
-- connect to des02
-- Question 1
CREATE OR REPLACE PACKAGE order_package_v2 IS
    quantity_to_order NUMBER;
    inv_id_to_order NUMBER;
    PROCEDURE create_new_order(p_customer_id NUMBER, p_meth_pmt VARCHAR2, p_os_id NUMBER);
    PROCEDURE create_new_order_line(p_order_id NUMBER);
    END;
    /
    
CREATE SEQUENCE order_sequence_v2 START WITH 50;
    
CREATE OR REPLACE PACKAGE BODY order_package_v2 IS
    PROCEDURE create_new_order(p_customer_id NUMBER, p_meth_pmt VARCHAR2, p_os_id NUMBER) AS
        v_order_id NUMBER;
        v_current_qoh NUMBER;
        v_leftover NUMBER;
        BEGIN
            SELECT inv_qoh
            INTO v_current_qoh
            FROM inventory
            WHERE inv_id = order_package_v2.inv_id_to_order;
            
            IF v_current_qoh = 0 THEN
                DBMS_OUTPUT.PUT_LINE('This inventory is currently unavailable, please come back tomorrow.');
            ELSIF order_package_v2.quantity_to_order <= v_current_qoh THEN
                v_order_id := order_sequence.NEXTVAL;
                INSERT INTO orders 
                VALUES(v_order_id, sysdate, p_meth_pmt, p_customer_id, p_os_id);
                UPDATE inventory SET inv_qoh = (v_current_qoh - order_package_v2.quantity_to_order) WHERE inv_id = order_package_v2.inv_id_to_order;
                create_new_order_line(v_order_id);
                DBMS_OUTPUT.PUT_LINE('Your order of quantity ' || order_package_v2.quantity_to_order || ' of inventory id ' || order_package_v2.inv_id_to_order
                || ' has been placed.');
            ELSIF order_package_v2.quantity_to_order > v_current_qoh THEN
                v_leftover := order_package_v2.quantity_to_order - v_current_qoh;
                v_order_id := order_sequence.NEXTVAL;
                INSERT INTO orders
                VALUES(v_order_id, sysdate, p_meth_pmt, p_customer_id, p_os_id);
                UPDATE inventory SET inv_qoh = 0 WHERE inv_id = order_package_v2.inv_id_to_order;
                create_new_order_line(v_order_id);
                DBMS_OUTPUT.PUT_LINE('Your order of quantity ' || order_package_v2.quantity_to_order || ' of inventory id ' || order_package_v2.inv_id_to_order
                || ' has been placed. You will be notified when the remaining ' || v_leftover || ' arrives.');
            END IF;
        END create_new_order;
        
    PROCEDURE create_new_order_line(p_order_id NUMBER) AS
        BEGIN
            INSERT INTO order_line
            VALUES(p_order_id, global_inv_id, global_quantity);
        END create_new_order_line;
    END;
    /
    
-- Question 2
CREATE OR REPLACE PACKAGE consultant_package_v2 IS
    PROCEDURE create_new_cert(con_id NUMBER, s_id NUMBER, cert VARCHAR2);
    END;
    /
    
CREATE OR REPLACE PACKAGE BODY consultant_package_v2 IS
    PROCEDURE create_new_cert(con_id NUMBER, s_id NUMBER, cert VARCHAR2) AS
        v_first consultant.c_first%TYPE;
        v_last consultant.c_last%TYPE;
        v_skill_desc skill.skill_description%TYPE;
        v_cert_status VARCHAR2(20);
        v_cert consultant_skill.certification%TYPE;
        v_counter NUMBER := 0;
        BEGIN
            IF cert = 'Y' OR cert = 'N' THEN
                -- SETTING CERTIFICATION STATUS
                IF cert = 'Y' THEN
                    v_cert_status := 'CERTIFIED';
                ELSE 
                    v_cert_status := 'Not Yet Certified';
                END IF;
                
                -- VERIFYING THE ENTERED CONSULTANT ID
                SELECT c_first, c_last 
                INTO v_first, v_last
                FROM consultant
                WHERE c_id = con_id;
                v_counter := 1;
                
                -- VERIFYING THE ENTERED SKILL ID
                SELECT skill_description
                INTO v_skill_desc
                FROM skill
                WHERE skill_id = s_id;
                v_counter := 2;
                
                -- VERIFYING IF THE COMBINATION ALREADY EXISTS
                SELECT certification 
                INTO v_cert
                FROM consultant_skill
                WHERE c_id = con_id AND skill_id = s_id;
                
                IF v_cert = cert THEN
                    DBMS_OUTPUT.PUT_LINE('This combination already exists, no need to take any action.');
                ELSE 
                    UPDATE consultant_skill SET certification = cert WHERE c_id = con_id AND skill_id = s_id;
                    DBMS_OUTPUT.PUT_LINE('Update has been done.');
                    DBMS_OUTPUT.PUT_LINE('Consultant Name: ' || v_first || ' ' || v_last || ' Skill Description: ' || v_skill_desc ||
                    ' Certification Status: ' || v_cert_status);
                END IF;
            ELSE 
                DBMS_OUTPUT.PUT_LINE('The certification status must be either Y or N');
            END IF;
                
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        IF v_counter = 0 THEN
                            DBMS_OUTPUT.PUT_LINE('Consultant ID: ' || con_id || ' is not valid.');
                        ELSIF v_counter = 1 THEN
                            DBMS_OUTPUT.PUT_LINE('Skill ID: ' || s_id || ' is not valid.');
                        ELSIF v_counter = 2 THEN
                            INSERT INTO consultant_skill
                            VALUES(con_id, s_id, cert);
                            DBMS_OUTPUT.PUT_LINE('Consultant Name: ' || v_first || ' ' || v_last || ' Skill Description: ' || v_skill_desc ||
                            ' Certification Status: ' || v_cert_status);
                        END IF;
            END create_new_cert;
        END;
        /
        
        --TEST
        exec consultant_package_v2.create_new_cert(100, 1, 'Y');
        exec consultant_package_v2.create_new_cert(100, 1, 'S');
        exec consultant_package_v2.create_new_cert(105, 2, 'Y');
        exec consultant_package_v2.create_new_cert(105, 1, 'Y');                   











