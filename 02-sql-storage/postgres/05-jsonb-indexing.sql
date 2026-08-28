-- ==============================================================================
-- 05-jsonb-indexing.sql
-- Semi-structured data query optimization with PostgreSQL JSONB and GIN indexes
-- ==============================================================================

-- 1. Create Generalized Inverted Index (GIN) on JSONB payload
CREATE INDEX IF NOT EXISTS idx_audit_payload_gin ON audit_events USING gin (payload);

-- 2. JSONB containment query (@>) uses the GIN index efficiently
EXPLAIN ANALYZE
SELECT id, event_timestamp, service_name, payload
FROM audit_events
WHERE payload @> '{"status": "failed"}';

-- 3. Path extraction and filtering
SELECT 
    id,
    service_name,
    payload ->> 'user' AS username,
    payload ->> 'ip' AS client_ip,
    (payload ->> 'duration_ms')::int AS duration_ms
FROM audit_events
WHERE service_name = 'auth-service';

-- 4. Expression index for deeply nested hot keys
CREATE INDEX IF NOT EXISTS idx_audit_user_field ON audit_events ((payload ->> 'user'));

