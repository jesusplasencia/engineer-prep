-- ==============================================================================
-- 01-window-functions.sql
-- PostgreSQL Window Functions: ROW_NUMBER, RANK, DENSE_RANK, NTILE
-- ==============================================================================

-- Problem 1: Rank employees by salary within each department without skipping numbers
SELECT 
    d.name AS department_name,
    e.name AS employee_name,
    e.salary,
    ROW_NUMBER() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC) AS row_num,
    RANK() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC) AS standard_rank,
    DENSE_RANK() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC) AS dense_rank
FROM employees e
JOIN departments d ON e.department_id = d.id
ORDER BY department_name, dense_rank;

-- Problem 2: Top N employees per department (Top 2 highest paid)
WITH ranked_employees AS (
    SELECT 
        department_id,
        name,
        salary,
        DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) as rank_pos
    FROM employees
)
SELECT department_id, name, salary, rank_pos
FROM ranked_employees
WHERE rank_pos <= 2;

-- Problem 3: Salary Quartiles / Bucketing with NTILE(4)
SELECT 
    name,
    salary,
    NTILE(4) OVER (ORDER BY salary DESC) AS salary_quartile
FROM employees;

