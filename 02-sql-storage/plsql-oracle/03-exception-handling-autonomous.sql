-- ==============================================================================
-- 03-exception-handling-autonomous.sql
-- Autonomous Transaction Logging & Robust Error Handling
-- Preserves error audit trails even when the main transaction executes a ROLLBACK
-- ==============================================================================

-- Stored Procedure to log errors independently of main transaction
CREATE OR REPLACE PROCEDURE log_error_autonomous(
    p_err_code IN NUMBER,
    p_err_msg  IN VARCHAR2,
    p_backtrace IN VARCHAR2
) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    INSERT INTO error_audit_log (error_code, error_message, error_backtrace)
    VALUES (p_err_code, p_err_msg, p_backtrace);
    
    COMMIT; -- Commits ONLY this autonomous logging transaction
END;
/

-- Test transaction that encounters an error, rolls back main work, but persists the log
DECLARE
    l_dummy NUMBER;
BEGIN
    -- Main business logic starts
    SAVEPOINT sp_before_critical_op;
    
    -- Intentionally trigger division by zero error
    l_dummy := 100 / 0;
    
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        -- Log failure autonomously
        log_error_autonomous(
            p_err_code   => SQLCODE,
            p_err_msg    => SQLERRM,
            p_backtrace  => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
        );
        
        -- Rollback main business transaction
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Main transaction rolled back safely; error logged autonomously.');
END;
/

