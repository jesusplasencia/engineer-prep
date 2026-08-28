-- ==============================================================================
-- 03-seed-data.sql
-- Seed Data for PostgreSQL Practice
-- ==============================================================================

-- 1. Populate Departments
INSERT INTO departments (id, name, budget) VALUES
(1, 'Engineering', 500000.00),
(2, 'Data Platform', 350000.00),
(3, 'Security & SRE', 400000.00),
(4, 'Product & Design', 200000.00)
ON CONFLICT (id) DO NOTHING;

-- 2. Populate Employees (Hierarchy: VP -> Directors -> Staff -> Senior)
INSERT INTO employees (id, name, department_id, manager_id, salary, hire_date) VALUES
(1, 'Alice Walker (VP)', 1, NULL, 220000.00, '2020-01-15'),
(2, 'Bob Miller (Eng Director)', 1, 1, 180000.00, '2020-03-01'),
(3, 'Charlie Davis (Data Director)', 2, 1, 175000.00, '2020-06-15'),
(4, 'Diana Evans (Staff SRE)', 3, 2, 160000.00, '2021-02-10'),
(5, 'Evan Wright (Senior Backend)', 1, 2, 140000.00, '2021-05-20'),
(6, 'Fiona Clark (Data Engineer)', 2, 3, 135000.00, '2021-08-01'),
(7, 'George King (DevOps Engineer)', 3, 4, 125000.00, '2022-01-10'),
(8, 'Hannah Scott (Junior Dev)', 1, 5, 95000.00, '2023-03-15')
ON CONFLICT (id) DO NOTHING;

-- 3. Populate User Activity for Gaps and Islands (Streaks)
-- User 101 has logins on Aug 1, 2, 3 (streak 1) and Aug 6, 7 (streak 2)
INSERT INTO user_activity (user_id, activity_date, action_type) VALUES
(101, '2026-08-01', 'login'),
(101, '2026-08-02', 'login'),
(101, '2026-08-03', 'login'),
(101, '2026-08-06', 'login'),
(101, '2026-08-07', 'login'),
(102, '2026-08-01', 'login'),
(102, '2026-08-04', 'login'),
(102, '2026-08-05', 'login'),
(102, '2026-08-06', 'login');

-- 4. Populate Sales
INSERT INTO sales (employee_id, sale_amount, sale_date, region) VALUES
(5, 1200.00, '2026-08-01 10:00:00', 'North America'),
(5, 3400.00, '2026-08-02 14:30:00', 'North America'),
(6, 2100.00, '2026-08-02 16:00:00', 'EMEA'),
(5, 5000.00, '2026-08-03 09:15:00', 'North America'),
(6, 1800.00, '2026-08-04 11:45:00', 'EMEA'),
(7, 4200.00, '2026-08-05 13:20:00', 'APAC'),
(8, 800.00,  '2026-08-05 15:00:00', 'North America');

-- 5. Populate Audit Events (JSONB)
INSERT INTO audit_events (service_name, payload) VALUES
('auth-service', '{"user": "alice", "action": "login", "ip": "10.0.0.5", "status": "success", "duration_ms": 12}'),
('payment-service', '{"user": "bob", "action": "checkout", "amount": 150.00, "currency": "USD", "items": ["sku-1", "sku-2"]}'),
('auth-service', '{"user": "eve", "action": "login", "ip": "192.168.1.50", "status": "failed", "attempt": 3}');

