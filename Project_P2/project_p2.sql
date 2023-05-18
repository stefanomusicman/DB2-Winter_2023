show user
SPOOL C:\DB2\Project_P2\j17_spool.txt;
SELECT to_char(sysdate, 'DD Month YYYY Day HH:MI:SS Am') FROM dual;

SET SERVEROUTPUT ON

-- Question 1
CREATE OR REPLACE FUNCTION P2_Q1(p_num1_in IN NUMBER, p_num2_in IN NUMBER)
RETURN NUMBER AS
    BEGIN
        RETURN p_num1_in * p_num2_in;
    END;
    /
    
    -- TEST
    SELECT P2_Q1(2,2) FROM dual;
    SELECT P2_Q1(2,3) FROM dual;
    
-- Question 2
CREATE OR REPLACE PROCEDURE P2_Q2(p_num1_in IN NUMBER, p_num2_in IN NUMBER) AS
    v_result NUMBER;
    BEGIN
        v_result := P2_Q1(p_num1_in, p_num2_in);
        DBMS_OUTPUT.PUT_LINE('For a rectangle of size ' || p_num1_in || ' by ' || p_num2_in || ' the area is ' || v_result );
    END;
    /
    
    -- TEST
    exec P2_Q2(2,2);
    exec P2_Q2(2,3);
    
-- Question 3
CREATE OR REPLACE PROCEDURE P2_Q3(p_num1_in IN NUMBER, p_num2_in IN NUMBER) AS
    v_result NUMBER;
    BEGIN
        v_result := P2_Q1(p_num1_in, p_num2_in);
        IF p_num1_in = p_num2_in THEN
            DBMS_OUTPUT.PUT_LINE('For a square of size ' || p_num1_in || ' by ' || p_num2_in || ' the area is ' || v_result );
        ELSE 
            DBMS_OUTPUT.PUT_LINE('For a rectangle of size ' || p_num1_in || ' by ' || p_num2_in || ' the area is ' || v_result );
        END IF;
    END;
    /
    
    -- TEST
    exec P2_Q3(2,2);
    exec P2_Q3(2,3);
    
-- Question 4
-- INPUT CURRENCY IS IN ***CANADIAN***
-- INPUT CHAR REPRESENTS CURRENCY TO CONVERT TO
CREATE OR REPLACE PROCEDURE P2_Q3(p_currency_in IN NUMBER, p_newCurrency_in IN VARCHAR2) AS
    v_result NUMBER;
    BEGIN
        IF p_newCurrency_in = 'E' OR p_newCurrency_in = 'e' THEN
            v_result := p_currency_in * 1.5;
            DBMS_OUTPUT.PUT_LINE('For ' || p_currency_in || ' Canadian, you will have ' || v_result || ' EUROS.');
        ELSIF p_newCurrency_in = 'Y' OR p_newCurrency_in = 'y' THEN
            v_result := p_currency_in * 100;
            DBMS_OUTPUT.PUT_LINE('For ' || p_currency_in || ' Canadian, you will have ' || v_result || ' YEN.');
        ELSIF p_newCurrency_in = 'V' OR p_newCurrency_in = 'v' THEN
            v_result := p_currency_in * 10000;
            DBMS_OUTPUT.PUT_LINE('For ' || p_currency_in || ' Canadian, you will have ' || v_result || ' DONG.');
        ELSIF p_newCurrency_in = 'Z' OR p_newCurrency_in = 'z' THEN
            v_result := p_currency_in * 1000000;
            DBMS_OUTPUT.PUT_LINE('For ' || p_currency_in || ' Canadian, you will have ' || v_result || ' ZIP.');
        ELSE 
            DBMS_OUTPUT.PUT_LINE('Invalid input, cannot convert!');
        END IF;
    END;
    /
    
    -- TEST
    exec P2_Q3(1, 'y');
    exec P2_Q3(1, 'e');
    exec P2_Q3(10, 'Z');
    exec P2_Q3(100, 'v');

-- Question 5
CREATE OR REPLACE FUNCTION YES_EVEN(p_num_in IN NUMBER) 
RETURN BOOLEAN AS
    BEGIN
        IF MOD(p_num_in, 2) = 0 THEN
            RETURN TRUE;
        ELSE
            RETURN FALSE;
        END IF;
    END;
    /
    
-- Question 6
CREATE OR REPLACE PROCEDURE P2_Q6(p_num_in IN NUMBER) AS
    BEGIN
        IF YES_EVEN(p_num_in) = TRUE THEN
            DBMS_OUTPUT.PUT_LINE('Number ' || p_num_in || ' is EVEN');
        ELSE 
            DBMS_OUTPUT.PUT_LINE('Number ' || p_num_in || ' is ODD');
        END IF;
    END;
    /
    
    -- TEST
    exec P2_Q6(2);
    exec P2_Q6(5);
    
---------------------------- BONUS QUESTION ----------------------------------------

-- I will first create a function to convert the input currency to canadian currency

CREATE OR REPLACE FUNCTION convertToCad(p_num_in IN NUMBER, p_currency_in IN VARCHAR2)
RETURN NUMBER AS
    BEGIN
        IF p_currency_in = 'E' OR p_currency_in = 'e' THEN
            RETURN p_num_in / 1.5;
        ELSIF p_currency_in = 'Y' OR p_currency_in = 'y' THEN
            RETURN p_num_in / 100;
        ELSIF p_currency_in = 'V' OR p_currency_in = 'v' THEN
            RETURN p_num_in / 10000;
        ELSIF p_currency_in = 'Z' OR p_currency_in = 'z' THEN
            RETURN p_num_in / 1000000;
        END IF;
    END;
    /
    
-- NOW I WILL CREATE THE FUNCTION TO CAD TO THE SPECIFIED CURRENCY
CREATE OR REPLACE PROCEDURE bonus_question(p_num_in IN NUMBER, p_starting_currency IN VARCHAR2, p_new_currency IN VARCHAR2) AS
    v_cad_conversion NUMBER := convertToCad(p_num_in, p_starting_currency);
    v_result NUMBER;
    v_old_currency VARCHAR2(20);
    BEGIN
        IF p_starting_currency = 'E' OR p_starting_currency = 'e' THEN
            v_old_currency := 'European EUROS';
        ELSIF p_starting_currency = 'Y' OR p_starting_currency = 'y' THEN
            v_old_currency := 'Japanese YEN';
        ELSIF p_starting_currency = 'V' OR p_starting_currency = 'v' THEN
            v_old_currency := 'Vietnam DONG';
        ELSIF p_starting_currency = 'Z' OR p_starting_currency = 'z' THEN
            v_old_currency := 'Zendora ZIP';
        END IF;
    
    
        IF p_new_currency = 'E' OR p_new_currency = 'e' THEN
            v_result := v_cad_conversion * 1.5;
            DBMS_OUTPUT.PUT_LINE('For ' || p_num_in || ' ' || v_old_currency || ', you will have ' || v_result || ' European EUROS.');
        ELSIF p_new_currency = 'Y' OR p_new_currency = 'y' THEN
            v_result := v_cad_conversion * 100;
            DBMS_OUTPUT.PUT_LINE('For ' || p_num_in || ' ' || v_old_currency || ', you will have ' || v_result || ' Japanese YEN.');
        ELSIF p_new_currency = 'V' OR p_new_currency = 'v' THEN
            v_result := v_cad_conversion * 10000;
            DBMS_OUTPUT.PUT_LINE('For ' || p_num_in || ' ' || v_old_currency || ', you will have ' || v_result || ' Vietnam DONG.');
        ELSIF p_new_currency = 'Z' OR p_new_currency = 'z' THEN
            v_result := v_cad_conversion * 1000000;
            DBMS_OUTPUT.PUT_LINE('For ' || p_num_in || ' ' || v_old_currency || ', you will have ' || v_result || ' Zendora ZIP.');
        ELSIF p_new_currency = 'C' OR p_new_currency = 'c' THEN
            DBMS_OUTPUT.PUT_LINE('For ' || p_num_in || ' ' || v_old_currency || ', you will have ' || v_cad_conversion || ' dollars Canadian.');
        END IF;
    END;
    /
    
    -- TEST
    exec bonus_question(100, 'y', 'e');
    exec bonus_question(100, 'Z', 'v');
    exec bonus_question(100, 'Z', 'c');
    
SPOOL OFF;












