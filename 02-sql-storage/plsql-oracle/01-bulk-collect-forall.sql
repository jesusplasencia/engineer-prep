-- ==============================================================================
-- 01-bulk-collect-forall.sql
-- High Performance Batch Data Processing with BULK COLLECT LIMIT & FORALL
-- Eliminates Context Switching between PL/SQL Engine and SQL Engine
-- ==============================================================================

DECLARE
    -- Define collection types
    TYPE t_emp_ids IS TABLE OF employees.id%TYPE;
    TYPE t_salaries IS TABLE OF employees.salary%TYPE;
    
    l_emp_ids   t_emp_ids;
    l_salaries  t_salaries;
    
    CURSOR c_eligible_emps IS
        SELECT id, salary 
        FROM employees 
        WHERE status = 'ACTIVE';
        
    c_batch_size CONSTANT PLS_INTEGER := 500;
BEGIN
    OPEN c_eligible_emps;
    LOOP
        -- Fetch in chunks to prevent PGA memory exhaustion
        FETCH c_eligible_emps BULK COLLECT INTO l_emp_ids, l_salaries LIMIT c_batch_size;
        EXIT WHEN l_emp_ids.COUNT = 0;
        
        -- Apply batch update using FORALL
        FORALL i IN 1 .. l_emp_ids.COUNT
            UPDATE employees 
            SET salary = salary * 1.05
            WHERE id = l_emp_ids(i);
            
        DBMS_OUTPUT.PUT_LINE('Batch processed: ' || l_emp_ids.COUNT || ' employees updated.');
    END LOOP;
    
    CLOSE c_eligible_emps;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        IF c_eligible_emps%ISOPEN THEN
            CLOSE c_eligible_emps;
        END IF;
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error in batch update: ' || SQLERRM);
        RAISE;
END;
/

