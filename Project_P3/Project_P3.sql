-- ***DISCLAIMER: SPOOL FILE WILL HAVE ERRORS BECAUSE YOU NEED TO SWITCH CONNECTIONS
-- FOR CERTAIN QUESTIONS IN ORDER FOR THEM TO FUNCTION CORRECTLY***

show user
SPOOL C:\DB2\Project_P3\project_p3_spool.txt;
SELECT to_char(sysdate, 'DD Month YYYY Day HH:MI:SS Am') FROM dual;

SET SERVEROUTPUT ON

-- Question 1 (USER: scott)
CREATE OR REPLACE PROCEDURE p3_q1(emp_num IN NUMBER) AS
    v_ename VARCHAR2(40);
    v_dept VARCHAR2(40);
    v_comm NUMBER;
    v_sal NUMBER;
    v_total_sal NUMBER;
    BEGIN
        SELECT e.ename, d.dname, e.sal, NVL(e.comm,0)
        INTO v_ename, v_dept, v_sal, v_comm
        FROM EMP e
        JOIN DEPT d ON d.deptno = e.deptno
        WHERE e.empno = emp_num;
        
        v_total_sal := (v_sal * 12) + v_comm;
        DBMS_OUTPUT.PUT_LINE('Employee number: ' || emp_num || ' Employee name: ' || v_ename || ' Department: ' || v_dept || ' Total Salary: ' || v_total_sal);
        
        EXCEPTION
                WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('Employee number ' || emp_num || ' does not exist my friend');
    END;
    /
    
    -- TEST
    exec p3_q1(7839);
    

-- Question 2 (connect to : des02)
CREATE OR REPLACE PROCEDURE p3_q2(p_inv_id IN NUMBER) AS
    v_desc VARCHAR2(40);    -- ITEM TABLE
    v_price NUMBER;         -- INVENTORY TABLE
    v_color VARCHAR2(40);   -- INVENTORY TABLE
    v_quantity NUMBER;      -- INVENTORY TABLE
    v_inv_value NUMBER;     -- v_price * v_quantity
    
    BEGIN
        SELECT I.item_desc, INV.inv_price, INV.color, INV.inv_qoh
        INTO v_desc, v_price, v_color, v_quantity
        FROM INVENTORY INV
        JOIN ITEM I ON INV.item_id = I.item_id
        WHERE INV.inv_id = p_inv_id;
        
        v_inv_value := v_price * v_quantity;
        DBMS_OUTPUT.PUT_LINE('Inventory ID: ' || p_inv_id || ' Product Description: ' || v_desc || ' Color: ' || v_color || ' Quantity in Inventory: ' || v_quantity || ' Total Inventory Value: ' || v_inv_value);
        
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Inventory ID ' || p_inv_id || ' does not exist my friend');
    END;
    /

    exec p3_q2(1);
    
-- Question 3 (connect to : des03)
CREATE OR REPLACE FUNCTION find_age(p_date_in IN DATE)
RETURN NUMBER AS
    age NUMBER;
    BEGIN
        age := ROUND((MONTHS_BETWEEN(sysdate, p_date_in)) / 12, 2);
        RETURN age;
    END;
    /
    
    -- TEST
    SELECT find_age('1996-October-15') from dual;
    
CREATE OR REPLACE PROCEDURE p3_q3(student_num NUMBER) AS
    stud_name VARCHAR2(40);
    stud_bdate DATE;
    stud_age NUMBER;
    BEGIN
        SELECT s_first, s_dob
        INTO stud_name, stud_bdate
        FROM STUDENT
        WHERE s_id = student_num;
        
        stud_age := find_age(stud_bdate);
        DBMS_OUTPUT.PUT_LINE('Student first name: ' || stud_name || ' Student Birthdate: ' || stud_bdate || ' Student Age: ' || stud_age);
        
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Student with ID ' || student_num || ' does not exist my friend');
    END;
    /

    -- TEST
    exec p3_q3(1);

-- Question 4 (connect to : des04)
-- function to validate con_id
CREATE OR REPLACE FUNCTION check_con_id(p_id NUMBER) 
RETURN BOOLEAN AS
    BEGIN
        IF p_id = 100 OR p_id = 101 OR p_id = 102 OR p_id = 103 OR p_id = 104 OR p_id = 104 THEN
            RETURN TRUE;
        ELSE 
            RETURN FALSE;
        END IF;
    END;
    /
    
-- function to validate s_id
CREATE OR REPLACE FUNCTION check_s_id(p_id NUMBER)
RETURN BOOLEAN AS
    BEGIN
        IF p_id = 1 OR p_id = 2 OR p_id = 3 OR p_id = 4 OR p_id = 5 OR p_id = 6 OR p_id = 7 OR p_id = 8 OR p_id = 9 THEN
            RETURN TRUE;
        ELSE 
            RETURN FALSE;
        END IF;
    END;
    /
    
-- function to validate certifaction input
CREATE OR REPLACE FUNCTION check_cert(p_cert VARCHAR)
RETURN BOOLEAN AS
    BEGIN
        IF p_cert = 'Y' OR p_cert = 'N' THEN
            RETURN TRUE;
        ELSE 
            RETURN FALSE;
        END IF;
    END;
    /
    
-- MAIN PROCEDURE
CREATE OR REPLACE PROCEDURE p3_q4(con_id NUMBER, s_id NUMBER, cert VARCHAR) AS
    v_s_id NUMBER;
    v_first_name VARCHAR2(40);
    v_last_name VARCHAR2(40);
    v_skill_desc VARCHAR2(40);
    BEGIN
        -- VALIDATION OF ENTERED PARAMETERS
        IF check_con_id(con_id) = FALSE THEN
            DBMS_OUTPUT.PUT_LINE('Consultant with ID ' || con_id || ' does not exist my friend. Please enter it in DB first');
        ELSIF check_s_id(s_id) = FALSE THEN
            DBMS_OUTPUT.PUT_LINE('Skill with ID ' || s_id || ' does not exist my friend. Please enter it in DB first');
        ELSIF check_cert(cert) = FALSE THEN
            DBMS_OUTPUT.PUT_LINE('Please enter either Y or N for the certification.');
        END IF;
        
        IF check_con_id(con_id) = TRUE AND check_s_id(s_id) = TRUE AND check_cert(cert) = TRUE THEN
            -- EXACT MATCH
            SELECT COUNT(SKILL_ID)
            INTO v_s_id 
            FROM CONSULTANT_SKILL 
            WHERE C_ID = CON_ID AND SKILL_ID = s_id;
            
            IF v_s_id = 1 THEN
                UPDATE CONSULTANT_SKILL SET CERTIFICATION = cert WHERE C_ID = CON_ID AND SKILL_ID = s_id;
                COMMIT;
                SELECT CON.C_LAST, CON.C_FIRST, S.SKILL_DESCRIPTION
                INTO v_last_name, v_first_name, v_skill_desc
                FROM CONSULTANT CON
                JOIN CONSULTANT_SKILL CONSK ON CONSK.C_ID = CON.C_ID
                JOIN SKILL S ON CONSK.SKILL_ID = S.SKILL_ID
                WHERE CONSK.C_ID = con_id AND CONSK.SKILL_ID = v_s_id;
                DBMS_OUTPUT.PUT_LINE('Consultant Last Name: ' || v_last_name || ' Consultant First Name: ' || v_first_name || ' Skill description: ' || v_skill_desc);      
            ELSE 
                INSERT INTO CONSULTANT_SKILL VALUES (con_id, s_id, cert);
                COMMIT; 
                SELECT CON.C_LAST, CON.C_FIRST, S.SKILL_DESCRIPTION
                INTO v_last_name, v_first_name, v_skill_desc
                FROM CONSULTANT CON
                JOIN CONSULTANT_SKILL CONSK ON CONSK.C_ID = CON.C_ID
                JOIN SKILL S ON CONSK.SKILL_ID = S.SKILL_ID
                WHERE CONSK.C_ID = con_id AND CONSK.SKILL_ID = v_s_id;
                DBMS_OUTPUT.PUT_LINE('Row has been ADDED.');
                DBMS_OUTPUT.PUT_LINE('Consultant Last Name: ' || v_last_name || ' Consultant First Name: ' || v_first_name || ' Skill description: ' || v_skill_desc);
            END IF;
        END IF;
    END;
    /
    
    -- TEST
    exec p3_q4(100, 5, 'N');
    exec p3_q4(100, 1, 'Y');
    exec p3_q4(103, 6, 'Y');

-- TEACHER SOLUTION FOR QUESTION 4














