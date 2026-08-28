-- ==============================================================================
-- 04-gaps-and-islands.sql
-- Solving the classic Gaps & Islands problem: Finding consecutive active streaks
-- ==============================================================================

-- Technique: (activity_date - ROW_NUMBER() days) remains CONSTANT during continuous streaks!
WITH ordered_logins AS (
    SELECT DISTINCT 
        user_id,
        activity_date
    FROM user_activity
),
streak_groups AS (
    SELECT 
        user_id,
        activity_date,
        activity_date - CAST(ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY activity_date) || ' days' AS INTERVAL) AS streak_group_id
    FROM ordered_logins
)
SELECT 
    user_id,
    MIN(activity_date) AS streak_start_date,
    MAX(activity_date) AS streak_end_date,
    COUNT(*) AS consecutive_days_count
FROM streak_groups
GROUP BY user_id, streak_group_id
ORDER BY user_id, streak_start_date;

