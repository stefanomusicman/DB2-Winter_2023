SPOOL C:\DB2\simulation_final\simulation_final_q3_q4_spool.txt;
SELECT to_char(sysdate, 'DD Month YYYY Day HH:MI:SS Am') FROM dual;

SET SERVEROUTPUT ON

-- connect to user scott
-- Question 3
CREATE OR REPLACE PROCEDURE sim_final_q3 AS
    CURSOR dept_curr IS
    SELECT deptno, dname, loc
    FROM dept;
    
    CURSOR emp_curr(dept_id NUMBER) IS
    SELECT ename, job, hiredate
    FROM emp
    WHERE deptno = dept_id;
    
    v_exp NUMBER;
    
    BEGIN
        FOR dept IN dept_curr LOOP
            DBMS_OUTPUT.PUT_LINE('-----------------------------------------');
            DBMS_OUTPUT.PUT_LINE('Department ID: ' || dept.deptno || ' Department Name: ' || dept.dname || ' Department Location: ' || dept.loc);
            
            FOR emp IN emp_curr(dept.deptno) LOOP
                v_exp := FLOOR((sysdate - emp.hiredate)/365.5);
                DBMS_OUTPUT.PUT_LINE('Employee Name: ' || emp.ename || ' Job: ' || emp.job || ' Hire Date: ' || emp.hiredate  || 
                ' Years of Experience: ' || v_exp);
            END LOOP;
        END LOOP;
    END;
    /
    
    -- test
    exec sim_final_q3;
    
-- Question 4
DROP TABLE audit_emp;
CREATE TABLE audit_emp(audit_id NUMBER, old_empno NUMBER, old_ename VARCHAR2(40), old_hiredate DATE, old_salary NUMBER, 
                        old_job VARCHAR2(40), updating_user VARCHAR2(30), date_updated DATE);
DROP SEQUENCE audit_emp_seq;
CREATE SEQUENCE audit_emp_seq;
                        
CREATE OR REPLACE TRIGGER emp_trigger
AFTER UPDATE ON emp
FOR EACH ROW
    BEGIN
        INSERT INTO audit_emp
        VALUES(audit_emp_seq.NEXTVAL, :OLD.empno, :OLD.ename, :OLD.hiredate, :OLD.sal, :OLD.job, user, sysdate);
    END;
    /
    
    
    

    
    
    
    
    
    
    