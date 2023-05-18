SET SERVEROUTPUT ON

-- Question 1
CREATE OR REPLACE FUNCTION p2_q1(num1 NUMBER, num2 NUMBER) RETURN NUMBER AS
    BEGIN
        return num1 * num2;
    END;
    /
    
    -- TEST
    SELECT p2_q1(2,2) FROM dual;
    
-- Question 2
CREATE OR REPLACE PROCEDURE p2_q2(num1 NUMBER, num2 NUMBER) AS
    v_area NUMBER := p2_q1(num1, num2);
    BEGIN
        DBMS_OUTPUT.PUT_LINE('For a rectangle of size ' || num1 || ' by ' || num2 || ' the area is ' || v_area || '.');
    END;
    /
    
    -- TEST
    exec p2_q2(3,2);
    
-- Question 3
CREATE OR REPLACE PROCEDURE p2_q3(num1 NUMBER, num2 NUMBER) AS
    v_area NUMBER := p2_q1(num1, num2);
    v_shape VARCHAR2(20);
    BEGIN
        IF num1 = num2 THEN
            v_shape := 'square';
        ELSE 
            v_shape := 'rectangle';
        END IF;
        DBMS_OUTPUT.PUT_LINE('For a ' || v_shape || ' of size ' || num1 || ' by ' || num2 || ' the area is ' || v_area || '.');
    END;
    /
    
    -- TEST
    exec p2_q3(3,3);
    
-- Question 4
CREATE OR REPLACE PROCEDURE p2_q4(cad_currency NUMBER, new_currency VARCHAR2) AS
    v_currency VARCHAR2(20);
    v_conversion NUMBER;
    BEGIN
        IF new_currency = 'E' THEN
            v_currency := 'Euro';
            v_conversion := cad_currency * 1.5;
        ELSIF new_currency = 'Y' THEN
            v_currency := 'Yen';
            v_conversion := cad_currency * 100;
        ELSIF new_currency = 'V' THEN
            v_currency := 'Dong';
            v_conversion := cad_currency * 10000;
        ELSIF new_currency = 'Z' THEN
            v_currency := 'Zendora';
            v_conversion := cad_currency * 1000000;
        END IF;
        DBMS_OUTPUT.PUT_LINE('For ' || cad_currency || ' dollars Canadian, you will have ' || v_conversion || ' ' || v_currency);
    END;
    /
    
    exec p2_q4(1, 'E');
    
-- Question 5
CREATE OR REPLACE FUNCTION p2_q5(p_num NUMBER) RETURN BOOLEAN AS 
    BEGIN
        IF MOD(p_num, 2) = 0 THEN
            RETURN TRUE;
        ELSE 
            RETURN FALSE;
        END IF;
    END;
    /
    
-- Question 6
CREATE OR REPLACE PROCEDURE p2_q6(p_num NUMBER) AS
    v_result BOOLEAN := p2_q5(p_num);
    BEGIN
        IF v_result = TRUE THEN
            DBMS_OUTPUT.PUT_LINE('Number ' || p_num || ' is EVEN');
        ELSE 
            DBMS_OUTPUT.PUT_LINE('Number ' || p_num || ' is ODD');
        END IF;
    END;
    /
    
    exec p2_q6(5);
    
-- Bonus Question
CREATE OR REPLACE FUNCTION convert_to_cad(dollar_amount NUMBER, currency VARCHAR2) RETURN NUMBER AS
    BEGIN
        IF currency = 'E' THEN
            RETURN ROUND(dollar_amount / 1.5, 2);
        ELSIF currency = 'Y' THEN
            RETURN ROUND(dollar_amount / 100, 2);
        ELSIF currency = 'V' THEN
            RETURN ROUND(dollar_amount / 10000, 2);
        ELSIF currency = 'Z' THEN
            RETURN ROUND(dollar_amount / 1000000, 2);
        END IF;
    END;
    /
    
    SELECT convert_to_cad(1, 'E') FROM dual;

CREATE OR REPLACE PROCEDURE bonus_v2(dollar_amount NUMBER, start_currency VARCHAR2, new_currency VARCHAR2) AS
    cad_currency NUMBER := convert_to_cad(dollar_amount, start_currency);
    v_new_currency VARCHAR2(20);
    v_original_currency VARCHAR2(20);
    v_conversion NUMBER;
    BEGIN
        IF start_currency = 'E' THEN
            v_original_currency := 'European EUROS';
        ELSIF start_currency = 'Y' THEN
            v_original_currency := 'Japanese YEN';
        ELSIF start_currency = 'V' THEN
            v_original_currency := 'Vietnam DONG';
        ELSIF start_currency = 'Z' THEN
            v_original_currency := 'Zendora ZIP';
        END IF;
    
        IF new_currency = 'E' THEN
            v_new_currency := 'Euro';
            v_conversion := cad_currency * 1.5;
        ELSIF new_currency = 'Y' THEN
            v_new_currency := 'Yen';
            v_conversion := cad_currency * 100;
        ELSIF new_currency = 'V' THEN
            v_new_currency := 'Dong';
            v_conversion := cad_currency * 10000;
        ELSIF new_currency = 'Z' THEN
            v_new_currency := 'Zendora';
            v_conversion := cad_currency * 1000000;
        END IF;
        DBMS_OUTPUT.PUT_LINE('For ' || dollar_amount || ' ' || v_original_currency || ', you will have ' ||  v_conversion || ' dollars ' || v_new_currency);
    END;
    /
    
    -- TEST
    exec bonus_v2(100, 'Y', 'E');








