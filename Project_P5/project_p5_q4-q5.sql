-- CONNECT TO USER scott
show user
SPOOL C:\DB2\Project_P5\project_p5_q4-q5__spool.txt;
SELECT to_char(sysdate, 'DD Month YYYY Day HH:MI:SS Am') FROM dual;

SET SERVEROUTPUT ON

-- Question 4
CREATE OR REPLACE PROCEDURE p5_q4(num_sals NUMBER) AS
    CURSOR high_sals IS
    SELECT ename, sal
    FROM emp
    ORDER BY sal DESC
    FETCH NEXT num_sals ROWS ONLY;
    
    v_name emp.ename%TYPE;
    v_sal  emp.sal%TYPE;
    
    BEGIN
        OPEN high_sals;
        
        FETCH high_sals INTO v_name, v_sal;
        DBMS_OUTPUT.PUT_LINE('The top ' || num_sals || ' employees are: ');
        WHILE high_sals%FOUND LOOP
            DBMS_OUTPUT.PUT_LINE('Employee Name: ' || v_name || ' Salary: ' || v_sal);
            
            FETCH high_sals INTO v_name, v_sal;
        END LOOP;
        CLOSE high_sals;
    END;
    /
    
    exec p5_q4(2);
            
-- Question 5
CREATE OR REPLACE PROCEDURE p5_q5(num_sals NUMBER) AS
    CURSOR top_sals IS  
    SELECT ename, sal FROM emp where sal IN (SELECT sal 
    FROM emp
    GROUP BY sal
    ORDER BY sal DESC
    FETCH NEXT num_sals ROWS ONLY);
    
    v_name emp.ename%TYPE;
    v_sal  emp.sal%TYPE;
    
    BEGIN
        OPEN top_sals;
        
        FETCH top_sals INTO v_name, v_sal;
        DBMS_OUTPUT.PUT_LINE('Employees with the top ' || num_sals || ' salaries are: ');
        WHILE top_sals%FOUND LOOP
            DBMS_OUTPUT.PUT_LINE('Employee Name: ' || v_name || ' Salary: ' || v_sal);
            
            FETCH top_sals INTO v_name, v_sal;
        END LOOP;
        CLOSE top_sals;
    END;
    /
    
    exec p5_q5(2);
    
    
    
    
    
    