SET SERVEROUTPUT ON

-- CONNECT TO USER cdes03
-- Question 1
CREATE OR REPLACE PROCEDURE p5_q1 AS
    CURSOR term_curr IS
    SELECT term_id, term_desc, status
    FROM term;
    
    v_id term.term_id%TYPE;
    v_desc term.term_desc%TYPE;
    v_status term.status%TYPE;
    
    BEGIN
        OPEN term_curr;
        
        FETCH term_curr INTO v_id, v_desc, v_status;
        
        WHILE term_curr%FOUND LOOP
            DBMS_OUTPUT.PUT_LINE('Term ID: ' || v_id || ' Term Description: ' || v_desc || ' Status: ' || v_status);
            
            FETCH term_curr INTO v_id, v_desc, v_status;
        END LOOP;
        CLOSE term_curr;
    END;
    /
    
    -- TEST
    exec p5_q1;
    
-- connect to des02
-- Question 2
CREATE OR REPLACE PROCEDURE p5_q2 AS
    CURSOR item_curr IS
    SELECT inv.inv_price, inv.color, inv.inv_qoh, i.item_desc
    FROM inventory inv
    JOIN item i ON inv.item_id = i.item_id;
    
    v_price inventory.inv_price%TYPE;
    v_color inventory.color%TYPE;
    v_qoh inventory.inv_qoh%TYPE;
    v_desc item.item_desc%TYPE;
    
    BEGIN
        OPEN item_curr;
        
        FETCH item_curr INTO v_price, v_color, v_qoh, v_desc;
        
        WHILE item_curr%FOUND LOOP
            DBMS_OUTPUT.PUT_LINE('Item Description: ' || v_desc || ' Color: ' || v_color || ' Price: ' || v_price || ' QOH: ' || v_qoh);
            
            FETCH item_curr INTO v_price, v_color, v_qoh, v_desc;
        END LOOP;
        CLOSE item_curr;
    END;
    /
    
    -- TEST
    exec p5_q2;
        
-- Question 3
CREATE OR REPLACE PROCEDURE p5_q3(price_increase NUMBER) AS
    CURSOR price_curr IS
    SELECT inv_id, inv_price
    FROM inventory;
    
    v_id inventory.inv_id%TYPE;
    v_old_price inventory.inv_price%TYPE;
    v_new_price inventory.inv_price%TYPE;
    
    BEGIN
        OPEN price_curr;
        
        FETCH price_curr INTO v_id, v_old_price;
        
        WHILE price_curr%FOUND LOOP
            v_new_price := v_old_price + (v_old_price * price_increase / 100);
            DBMS_OUTPUT.PUT_LINE('Inventory ID: ' || v_id || ' Old Price: ' || v_old_price || ' New Price: ' || v_new_price);
            UPDATE inventory SET inv_price = v_new_price WHERE inv_id = v_id;
            
            FETCH price_curr INTO v_id, v_old_price;
        END LOOP;
        CLOSE price_curr;
    END;
    /
    
    -- TEST
    exec p5_q3(10);
    
-- connect to user scott
-- Question 4
CREATE OR REPLACE PROCEDURE p5_q4(num_sals NUMBER) AS
    CURSOR sal_curr IS
    SELECT ename, sal
    FROM emp
    ORDER BY sal DESC
    FETCH NEXT num_sals ROWS ONLY;
    
    v_name emp.ename%TYPE;
    v_sal emp.sal%TYPE;
    
    BEGIN
        OPEN sal_curr;
        
        FETCH sal_curr INTO v_name, v_sal;
        
        DBMS_OUTPUT.PUT_LINE('The top ' || num_sals || ' employees are: ');
        WHILE sal_curr%FOUND LOOP
            DBMS_OUTPUT.PUT_LINE(v_name || ' ' || v_sal);
            
            FETCH sal_curr INTO v_name, v_sal;
        END LOOP;
        CLOSE sal_curr;
    END;
    /
    
    -- TEST 
    exec p5_q4(3);
    
-- Question 5
CREATE OR REPLACE PROCEDURE p5_q5(num_sals NUMBER) AS
    CURSOR sal_curr IS
    SELECT ename, sal
    FROM emp 
    WHERE SAL IN (
    SELECT sal
    FROM emp
    GROUP BY sal
    ORDER BY sal DESC
    FETCH NEXT num_sals ROWS ONLY);
    
    v_name emp.ename%TYPE;
    v_sal emp.sal%TYPE;
    
    BEGIN
        OPEN sal_curr;
        
        FETCH sal_curr INTO v_name, v_sal;
        
        DBMS_OUTPUT.PUT_LINE('The employees with the top ' || num_sals || ' salaries are: ');
        WHILE sal_curr%FOUND LOOP
            DBMS_OUTPUT.PUT_LINE(v_name || ' ' || v_sal);
            
            FETCH sal_curr INTO v_name, v_sal;
        END LOOP;
        CLOSE sal_curr;
    END;
    /
    
    -- TEST
    exec p5_q5(3);














    
    
    
    