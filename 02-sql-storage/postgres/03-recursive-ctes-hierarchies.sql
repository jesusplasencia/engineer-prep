-- ==============================================================================
-- 03-recursive-ctes-hierarchies.sql
-- Recursive CTEs: Hierarchical tree traversal, organizational reporting chains
-- ==============================================================================

-- Problem 1: Build the complete reporting hierarchy from CEO/VP down with Level & Path
WITH RECURSIVE org_tree AS (
    -- Anchor member: Root nodes (no manager)
    SELECT 
        id,
        name,
        manager_id,
        1 AS level,
        CAST(name AS VARCHAR(1000)) AS reporting_path
    FROM employees
    WHERE manager_id IS NULL

    UNION ALL

    -- Recursive member: Find direct reports
    SELECT 
        e.id,
        e.name,
        e.manager_id,
        ot.level + 1 AS level,
        CAST(ot.reporting_path || ' -> ' || e.name AS VARCHAR(1000)) AS reporting_path
    FROM employees e
    INNER JOIN org_tree ot ON e.manager_id = ot.id
)
SELECT level, reporting_path
FROM org_tree
ORDER BY reporting_path;

-- Problem 2: Rollup Total Team Salaries under each Manager
WITH RECURSIVE subordinate_tree AS (
    SELECT id AS manager_id, id AS subordinate_id, salary
    FROM employees

    UNION ALL

    SELECT st.manager_id, e.id AS subordinate_id, e.salary
    FROM subordinate_tree st
    JOIN employees e ON e.manager_id = st.subordinate_id
)
SELECT 
    m.id AS manager_id,
    m.name AS manager_name,
    COUNT(st.subordinate_id) AS total_headcount,
    SUM(st.salary) AS total_org_payroll
FROM subordinate_tree st
JOIN employees m ON st.manager_id = m.id
GROUP BY m.id, m.name
ORDER BY total_org_payroll DESC;

