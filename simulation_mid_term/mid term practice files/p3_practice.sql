SET SERVEROUTPUT ON

-- Question 1 (user: scott)
CREATE OR REPLACE PROCEDURE p3_q1(p_empno NUMBER) AS
    v_total_salary NUMBER;
    v_dept_name dept.dname%TYPE;
    v_emp_name emp.ename%TYPE;
    v_monthly_sal NUMBER;
    v_commission NUMBER;
    BEGIN
        SELECT e.ename, e.sal, NVL(e.comm,0), d.dname
        INTO v_emp_name, v_monthly_sal, v_commission, v_dept_name
        FROM emp e
        JOIN dept d ON d.deptno = e.deptno
        WHERE e.empno = p_empno;
        
        v_total_salary := (v_monthly_sal * 12) + v_commission;
        
        DBMS_OUTPUT.PUT_LINE('Employee Name: ' || v_emp_name || ' Dept Name: ' || v_dept_name || ' Total Yearly Salary: ' || v_total_salary);
        
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('This employee number does not exist');
    END;
    /
    
    -- TEST
    exec p3_q1(7698);

-- Question 2 (user des02)
CREATE OR REPLACE PROCEDURE p3_q2(p_inv_id NUMBER) AS
    v_item_desc item.item_desc%TYPE;
    v_item_price inventory.inv_price%TYPE;
    v_item_color inventory.color%TYPE;
    v_qoh inventory.inv_qoh%TYPE;
    v_total_inv_value NUMBER;
    BEGIN
        SELECT inv.inv_price, inv.color, inv.inv_qoh, i.item_desc
        INTO v_item_price, v_item_color, v_qoh, v_item_desc
        FROM inventory inv
        JOIN item i ON inv.item_id = i.item_id
        WHERE inv.inv_id = p_inv_id;
        
        v_total_inv_value := v_item_price * v_qoh;
        
        DBMS_OUTPUT.PUT_LINE('Item Description: ' || v_item_desc || ' Price: ' || v_item_price || ' Color: ' || v_item_color || ' QOH: ' || v_qoh ||
        ' Total INV Value: ' || v_total_inv_value);
        
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('This inventory ID does not exist');
    END;
    /
    
    -- TEST
    exec p3_q2(1);
    
-- Question 3 (user des03)
CREATE OR REPLACE FUNCTION find_age(p_date DATE) RETURN NUMBER AS
    v_age NUMBER;
    BEGIN
        v_age := FLOOR(MONTHS_BETWEEN(sysdate, p_date) / 12);
        RETURN v_age;
    END;
    /
    
    -- TEST
    SELECT find_age('1996-October-15') from dual;
    
CREATE OR REPLACE PROCEDURE p3_q4(stud_id NUMBER) AS
    v_age NUMBER;
    v_fname student.s_first%TYPE;
    v_lname student.s_last%TYPE;
    v_dob student.s_dob%TYPE;
    BEGIN
        SELECT s_first, s_last, s_dob
        INTO v_fname, v_lname, v_dob
        FROM student
        WHERE s_id = stud_id;
        
        v_age := find_age(v_dob);
        
        DBMS_OUTPUT.PUT_LINE('Name: ' || v_fname || ' ' || v_lname || ' Bday: ' || v_dob || ' Age: ' || v_age);
        
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('This student ID does not exist');
    END;
    /
    
    -- TEST
    exec p3_q4(1);

-- Question 4 (user des04)
CREATE OR REPLACE PROCEDURE p3_q4(consultant_id NUMBER, s_id NUMBER, cert VARCHAR2) AS
    v_fname consultant.c_first%TYPE;
    v_lname consultant.c_last%TYPE;
    v_skill_desc skill.skill_description%TYPE;
    v_cert consultant_skill.certification%TYPE;
    v_counter NUMBER := 0;
    BEGIN
    IF cert = 'Y' OR cert = 'N' THEN
        SELECT c_first, c_last
        INTO v_fname, v_lname
        FROM consultant
        WHERE c_id = consultant_id;
        v_counter := 1;
        
        SELECT skill_description
        INTO v_skill_desc
        FROM skill
        WHERE skill_id = s_id;
        v_counter := 2;
        
        SELECT certification
        INTO v_cert
        FROM consultant_skill
        WHERE skill_id = s_id AND c_id = consultant_id;
        
        IF v_cert = cert THEN
            DBMS_OUTPUT.PUT_LINE('Row exists, no need to update');
        ELSE
            UPDATE consultant_skill SET certification = cert
            WHERE skill_id = s_id AND c_id = consultant_id;
            DBMS_OUTPUT.PUT_LINE('Row UPDATED');
            DBMS_OUTPUT.PUT_LINE('Consultant ID: ' || consultant_id || ' Skill id: ' || s_id || ' Certification: ' || cert);
        END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Please enter either Y or N');
    END IF;
        EXCEPTION 
            WHEN NO_DATA_FOUND THEN
                IF v_counter = 0 THEN
                    DBMS_OUTPUT.PUT_LINE('Invalid consultant id');
                ELSIF v_counter = 1 THEN
                    DBMS_OUTPUT.PUT_LINE('Invalid skill id');
                ELSIF v_counter = 2 THEN
                    DBMS_OUTPUT.PUT_LINE('Row does not exist, insert needed');
                    INSERT INTO consultant_skill 
                    VALUES (consultant_id, s_id, cert);
                    DBMS_OUTPUT.PUT_LINE('Row added');
                    DBMS_OUTPUT.PUT_LINE('Consultant ID: ' || consultant_id || ' Skill id: ' || s_id || ' Certification: ' || cert);
                END IF;
    END;
    /
    
    -- TEST
    exec p3_q4(100, 1, 'Y');
                
                
        
        
    
    
    
    
    
    
    
    
    
        










