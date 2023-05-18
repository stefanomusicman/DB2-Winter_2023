SPOOL C:\DB2\final_exam\final_q2_spool.txt;
SELECT to_char(sysdate, 'DD Month YYYY Day HH:MI:SS Am') FROM dual;

-- Question 2
-- connect to scott
CREATE OR REPLACE PACKAGE area_package IS
    FUNCTION calc_area(p_num1 NUMBER) RETURN NUMBER;
    FUNCTION calc_area(p_num1 NUMBER, p_num2 NUMBER) RETURN NUMBER;
END;
/

CREATE OR REPLACE PACKAGE BODY area_package IS
    FUNCTION calc_area(p_num1 NUMBER) RETURN NUMBER AS
        BEGIN
            RETURN p_num1 * p_num1;
        END;
    
    FUNCTION calc_area(p_num1 NUMBER, p_num2 NUMBER) RETURN NUMBER AS
        BEGIN
            RETURN p_num1 * p_num2;
        END;
END;
/

CREATE OR REPLACE PROCEDURE stefano_p1(p_length NUMBER, p_width NUMBER) AS
    v_area NUMBER := area_package.calc_area(p_length, p_width);
    v_perimeter NUMBER := (2 * p_length) + (2 * p_width);
    v_negative EXCEPTION;
    v_shape VARCHAR2(20);
    BEGIN
        IF p_length < 0 OR p_width < 0 THEN
            RAISE v_negative;
        END IF;
        
        IF p_length = p_width THEN
            v_shape := 'square';
        ELSE    
            v_shape := 'rectangle';
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('For the ' || v_shape || ' of side ' || p_length || ' by ' || p_width || ' , The area is ' || v_area || 
                                ', and its perimeter is ' || v_perimeter);
        
        EXCEPTION
            WHEN v_negative THEN
                DBMS_OUTPUT.PUT_LINE('Invalid input, both length and width must be positive numbers!');
    END;
    /
  
-- TEST 
SET SERVEROUTPUT ON 
exec stefano_p1(2,2);
exec stefano_p1(2,3);
exec stefano_p1(-2,3);
    
    
    
    
    
    
    