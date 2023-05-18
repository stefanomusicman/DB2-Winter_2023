-- Overloading PROCEDURES/FUNCTIONS

-- Sometimes we have the following:
    -- enmae, job
    -- ename, salary
    -- empno, ename, hiredate
    -- .....

-- We need an overloading PROCEDURE that accepts the above values to insert 
-- a new row in table emp. If the empno is not provided, use a number generated
-- by a sequence named emp_sequence that starts with number 8000.
-- ****(hint: overloading PROCEDURE must be inside of a package)****

-- CONNECT TO USER SCOTT
CREATE OR REPLACE PACKAGE employee_package IS
    PROCEDURE employee_insert(p_ename VARCHAR2, p_job VARCHAR2);
    PROCEDURE employee_insert(p_ename VARCHAR2, p_sal NUMBER);
    PROCEDURE employee_insert(p_empno NUMBER, p_ename VARCHAR2, p_hiredate DATE);
END;
/

CREATE SEQUENCE employee_sequence START WITH 8000;

CREATE OR REPLACE PACKAGE BODY employee_package IS
    PROCEDURE employee_insert(p_ename VARCHAR2, p_job VARCHAR2) AS
        BEGIN
            INSERT INTO emp(empno, ename, job)
            VALUES(employee_sequence.NEXTVAL, p_ename, p_job);
            commit;
        END;
    PROCEDURE employee_insert(p_ename VARCHAR2, p_sal NUMBER) AS
        BEGIN
            INSERT INTO emp(empno, ename, sal)
            VALUES(employee_sequence.NEXTVAL, p_ename, p_sal);
            commit;
        END;
    PROCEDURE employee_insert(p_empno NUMBER, p_ename VARCHAR2, p_hiredate DATE) AS
        BEGIN
            INSERT INTO emp(empno, ename, hiredate)
            VALUES(p_empno, p_ename, p_hiredate);
            commit;
        END;
END;
/

exec employee_package.employee_insert(7999, 'Ciro', sysdate - 1);
exec employee_package.employee_insert('Miwa', 'OBSERVER');
exec employee_package.employee_insert('Luis', 9999);

------------------------ RESTRICTION ----------------------------------------
-- Overloading PROCEDURE with the same number of parameter, cannot have the
-- parameter of the same family.

-- EX:
-- PROCEDURE customer_insert(p_custno NUMBER, p_salary NUMBER);
-- PROCEDURE customer_insert(p_custno NUMBER, p_rank NUMBER);

-- exec package_name.customer_insert(1,1);
-- this will not work since its not possible to determine which procedure you 
-- want to use

---------------------------------------
-- Overloading FUNCTION with the same number of parameter, cannot be different 
-- by only the RETURNING data type.

-- EX:
-- FUNCTION find_value(p_number NUMBER) RETURN DATE;
-- FUNCTION find_value(p_number NUMBER) RETURN NUMBER;

-- SELECT package_name.find_value(5) FROM dual;
-- wont work, parameters have same amount of same type



