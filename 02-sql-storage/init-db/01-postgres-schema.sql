-- ==============================================================================
-- 01-postgres-schema.sql
-- Base DDL Schema for PostgreSQL 16
-- ==============================================================================

-- 1. Departments & Employees (Hierarchical recursive CTE testing)
CREATE TABLE IF NOT EXISTS departments (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    budget NUMERIC(12, 2) NOT NULL DEFAULT 0.00
);

CREATE TABLE IF NOT EXISTS employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department_id INT REFERENCES departments(id),
    manager_id INT REFERENCES employees(id),
    salary NUMERIC(10, 2) NOT NULL,
    hire_date DATE NOT NULL
);

-- 2. User Logins & Activity (Gaps & Islands problem)
CREATE TABLE IF NOT EXISTS user_activity (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    activity_date DATE NOT NULL,
    action_type VARCHAR(50) NOT NULL
);

-- 3. Sales & Transactions (Window functions & Running Totals)
CREATE TABLE IF NOT EXISTS sales (
    id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(id),
    sale_amount NUMERIC(10, 2) NOT NULL,
    sale_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    region VARCHAR(50) NOT NULL
);

-- 4. Semi-structured Events (JSONB & GIN Indexes)
CREATE TABLE IF NOT EXISTS audit_events (
    id SERIAL PRIMARY KEY,
    event_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    service_name VARCHAR(50) NOT NULL,
    payload JSONB NOT NULL
);

