-- ==============================================================================
-- 04-pipelined-table-functions.sql
-- High-throughput streaming data transformation using Pipelined Table Functions
-- Returns rows iteratively with PIPE ROW without caching large arrays in memory
-- ==============================================================================

-- 1. Define Object and Nested Table types
CREATE OR REPLACE TYPE t_emp_bonus_obj AS OBJECT (
    emp_id       NUMBER,
    emp_name     VARCHAR2(100),
    base_salary  NUMBER(10, 2),
    bonus_amount NUMBER(10, 2),
    total_comp   NUMBER(10, 2)
);
/

CREATE OR REPLACE TYPE t_emp_bonus_tab IS TABLE OF t_emp_bonus_obj;
/

-- 2. Create Pipelined Transformation Function
CREATE OR REPLACE FUNCTION calculate_team_bonuses(p_bonus_pct IN NUMBER)
RETURN t_emp_bonus_tab PIPELINED
IS
    CURSOR c_emp IS
        SELECT id, name, salary FROM employees;
        
    l_bonus NUMBER(10, 2);
BEGIN
    FOR r IN c_emp LOOP
        l_bonus := ROUND(r.salary * (p_bonus_pct / 100), 2);
        
        -- Emit row immediately to client/consumer stream
        PIPE ROW(t_emp_bonus_obj(
            r.id,
            r.name,
            r.salary,
            l_bonus,
            r.salary + l_bonus
        ));
    END LOOP;
    
    RETURN;
END;
/

-- 3. Query the pipelined function using standard SQL TABLE() operator
SELECT * 
FROM TABLE(calculate_team_bonuses(15))
WHERE total_comp > 150000
ORDER BY total_comp DESC;

