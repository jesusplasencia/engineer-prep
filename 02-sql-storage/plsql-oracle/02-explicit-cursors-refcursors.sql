-- ==============================================================================
-- 02-explicit-cursors-refcursors.sql
-- Parameterized Explicit Cursors and Dynamic SYS_REFCURSOR passing
-- ==============================================================================

-- 1. Parameterized Explicit Cursor with %NOTFOUND and %ROWCOUNT
DECLARE
    CURSOR c_dept_emps (p_dept_id NUMBER, p_min_salary NUMBER) IS
        SELECT name, salary, hire_date
        FROM employees
        WHERE department_id = p_dept_id
          AND salary >= p_min_salary
        ORDER BY salary DESC;
        
    r_emp c_dept_emps%ROWTYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- High Earners in Department 1 ---');
    OPEN c_dept_emps(p_dept_id => 1, p_min_salary => 120000);
    LOOP
        FETCH c_dept_emps INTO r_emp;
        EXIT WHEN c_dept_emps%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Employee: ' || r_emp.name || ' | Salary: $' || r_emp.salary);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Total rows processed: ' || c_dept_emps%ROWCOUNT);
    CLOSE c_dept_emps;
END;
/

-- 2. Dynamic SYS_REFCURSOR Function for Client APIs
CREATE OR REPLACE FUNCTION get_employees_refcursor(p_department_id IN NUMBER DEFAULT NULL)
RETURN SYS_REFCURSOR
IS
    l_cursor SYS_REFCURSOR;
BEGIN
    IF p_department_id IS NULL THEN
        OPEN l_cursor FOR
            SELECT id, name, salary FROM employees ORDER BY id;
    ELSE
        OPEN l_cursor FOR
            SELECT id, name, salary FROM employees WHERE department_id = p_department_id ORDER BY salary DESC;
    END IF;
    RETURN l_cursor;
END;
/

