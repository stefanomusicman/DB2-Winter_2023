show user
SPOOL C:\DB2\Project_P1\projectP1_spool.txt;
SELECT to_char(sysdate, 'DD Month YYYY Day HH:MI:SS Am') FROM dual;

SET SERVEROUTPUT ON

-- Question 1
CREATE OR REPLACE PROCEDURE L1q1 (p_num_in IN NUMBER) AS
    v_num_in NUMBER; 
    v_result NUMBER;
    BEGIN
        v_num_in := p_num_in;
        v_result := v_num_in * 3;
        DBMS_OUTPUT.PUT_LINE('The triple of ' || v_num_in || ' is ' || v_result || ' !' );
    END;
    /
    
exec L1q1(2);
exec L1q1(3);

-- Question 2
CREATE OR REPLACE PROCEDURE L1q2 (p_num_in IN NUMBER) AS
    v_num_in NUMBER;
    v_result NUMBER;
    BEGIN
        v_num_in := p_num_in;
        v_result := (9/5) * v_num_in + 32;
        DBMS_OUTPUT.PUT_LINE(v_num_in || ' degree in C is equivalent to ' || v_result || ' in F' );
    END;
    /
    
exec L1q2(0);
exec L1q2(10);
exec L1q2(20);

-- Question 3
CREATE OR REPLACE PROCEDURE L1q3 (p_num_in IN NUMBER) AS
    v_num_in NUMBER;
    v_result NUMBER;
    BEGIN
        v_num_in := p_num_in;
        v_result := (5/9) * (v_num_in - 32);
        DBMS_OUTPUT.PUT_LINE(v_num_in || ' degree in F is equivalent to ' || v_result || ' in C' );
    END;
    /
    
exec L1q3(32);
exec L1q3(50);
exec L1q3(68);

-- Question 4
CREATE OR REPLACE PROCEDURE L1q4 (p_num_in IN NUMBER) AS
    v_num_in NUMBER;
    v_gst FLOAT;
    v_qst FLOAT;
    v_total FLOAT;
    BEGIN
        v_num_in := p_num_in;
        v_gst := v_num_in * 0.05;
        v_qst := v_num_in * 0.0998;
        v_total := v_num_in + v_gst + v_qst;
        DBMS_OUTPUT.PUT_LINE('For the price of $' || v_num_in);
        DBMS_OUTPUT.PUT_LINE('You will have to pay $' || v_gst || ' GST');
        DBMS_OUTPUT.PUT_LINE('You will have to pay $' || v_qst || ' QST');
        DBMS_OUTPUT.PUT_LINE('The GRAND TOTAL IS $' || v_total);
    END;
    /
    
exec L1q4(100);

-- Question 5
CREATE OR REPLACE PROCEDURE L1q5 (p_num_one IN NUMBER, p_num_two IN NUMBER) AS
    v_width NUMBER;
    v_height NUMBER;
    v_area NUMBER;
    v_perimeter NUMBER;
    BEGIN
        v_width := p_num_one;
        v_height := p_num_two;
        v_area := v_width * v_height;
        v_perimeter := (2 * v_width) + (2 * v_height);
        DBMS_OUTPUT.PUT_LINE('The area of a ' || v_width || ' by ' || v_height || ' rectangle is ' || v_area || '.' || ' Its perimeter is ' || v_perimeter);
    END;
    /
    
exec L1q5(2,2);
exec L1q5(2,4);

-- Question 6
CREATE OR REPLACE FUNCTION L1q6 (p_num_in IN NUMBER)
RETURN NUMBER AS 
    v_num_in NUMBER;
    v_result NUMBER;
    BEGIN
        v_num_in := p_num_in;
        v_result := (9/5) * v_num_in + 32;
        DBMS_OUTPUT.PUT_LINE(v_num_in || ' degree in C is equivalent to ' || v_result || ' in F' );
        RETURN v_result;
    END;
    /

SELECT L1q6(0) FROM dual;
SELECT L1q6(10) FROM dual;
SELECT L1q6(20) FROM dual;

-- Question 7
CREATE OR REPLACE FUNCTION L1q7 (p_num_in IN NUMBER)
RETURN NUMBER AS 
    v_num_in NUMBER;
    v_result NUMBER;
    BEGIN
        v_num_in := p_num_in;
        v_result := (5/9) * (v_num_in - 32);
        DBMS_OUTPUT.PUT_LINE(v_num_in || ' degree in F is equivalent to ' || v_result || ' in C' );
        RETURN v_result;
    END;
    /

SELECT L1q7(32) FROM dual;
SELECT L1q7(50) FROM dual;
SELECT L1q7(68) FROM dual;

SPOOL OFF;


