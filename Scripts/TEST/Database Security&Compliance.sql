-------------------------------------------------------------
-- 1. Vulnerable Stored Procedure (SQL Injection Demo)
-------------------------------------------------------------
IF OBJECT_ID('sp_GetReport_Vulnerable', 'P') IS NOT NULL
    DROP PROCEDURE sp_GetReport_Vulnerable;
GO

CREATE PROCEDURE sp_GetReport_Vulnerable
    @participantCode NVARCHAR(50)
AS
BEGIN
    -- ❌ Vulnerable: builds SQL string directly
    DECLARE @sql NVARCHAR(MAX) =
        'SELECT participant_code, trial_id FROM Participants WHERE participant_code = ''' + @participantCode + '''';

    PRINT 'Executing: ' + @sql;
    EXEC(@sql); -- Unsafe
END;
GO

-------------------------------------------------------------
-- 2. Secure Stored Procedure (Fix with Parameterization)
-------------------------------------------------------------
IF OBJECT_ID('sp_GetReport_Secure', 'P') IS NOT NULL
    DROP PROCEDURE sp_GetReport_Secure;
GO

CREATE PROCEDURE sp_GetReport_Secure
    @participantCode NVARCHAR(50)
AS
BEGIN
    -- ✅ Safe: uses parameterized query
    DECLARE @sql NVARCHAR(MAX) =
        'SELECT participant_code, trial_id FROM Participants WHERE participant_code = @pc';

    EXEC sp_executesql @sql, N'@pc NVARCHAR(50)', @pc = @participantCode;
END;
GO

-------------------------------------------------------------
-- 3. Audit Log Table (if not exists)
-------------------------------------------------------------
IF OBJECT_ID('AuditLog', 'U') IS NULL
BEGIN
    CREATE TABLE AuditLog (
        audit_id INT IDENTITY PRIMARY KEY,
        table_name NVARCHAR(100),
        record_id NVARCHAR(50),
        action NVARCHAR(20),
        user_name NVARCHAR(100),
        log_timestamp DATETIME,
        old_value NVARCHAR(MAX),
        new_value NVARCHAR(MAX)
    );
END;
GO

-------------------------------------------------------------
-- 4. Audit Trigger for INSERT/UPDATE/DELETE on Participants
-------------------------------------------------------------
IF OBJECT_ID('trg_Participants_Audit', 'TR') IS NOT NULL
    DROP TRIGGER trg_Participants_Audit;
GO

CREATE TRIGGER trg_Participants_Audit
ON Participants
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Capture INSERTS
    INSERT INTO AuditLog (table_name, record_id, action, user_name, log_timestamp, new_value)
    SELECT 'Participants', CAST(i.participant_id AS NVARCHAR), 'INSERT',
           SYSTEM_USER, GETDATE(),
           CONCAT('Code=', i.participant_code, ', Trial=', i.trial_id)
    FROM inserted i;

    -- Capture DELETES
    INSERT INTO AuditLog (table_name, record_id, action, user_name, log_timestamp, old_value)
    SELECT 'Participants', CAST(d.participant_id AS NVARCHAR), 'DELETE',
           SYSTEM_USER, GETDATE(),
           CONCAT('Code=', d.participant_code, ', Trial=', d.trial_id)
    FROM deleted d;

    -- Capture UPDATES
    INSERT INTO AuditLog (table_name, record_id, action, user_name, log_timestamp, old_value, new_value)
    SELECT 'Participants', CAST(i.participant_id AS NVARCHAR), 'UPDATE',
           SYSTEM_USER, GETDATE(),
           CONCAT('OldCode=', d.participant_code, ', OldTrial=', d.trial_id),
           CONCAT('NewCode=', i.participant_code, ', NewTrial=', i.trial_id)
    FROM inserted i
    JOIN deleted d ON i.participant_id = d.participant_id;
END;
GO

-------------------------------------------------------------
-- 5. Stored Procedure to Log SELECT Actions
-------------------------------------------------------------
IF OBJECT_ID('sp_LogSelectAudit', 'P') IS NOT NULL
    DROP PROCEDURE sp_LogSelectAudit;
GO

CREATE PROCEDURE sp_LogSelectAudit
    @tableName NVARCHAR(100),
    @recordId NVARCHAR(50) = NULL
AS
BEGIN
    INSERT INTO AuditLog (table_name, record_id, action, user_name, log_timestamp)
    VALUES (@tableName, @recordId, 'SELECT', SYSTEM_USER, GETDATE());
END;
GO

-------------------------------------------------------------
-- 6. DEMONSTRATION
-------------------------------------------------------------
-- Vulnerable run (Injection succeeds)
EXEC sp_GetReport_Vulnerable @participantCode = 'P001'' OR 1=1--';

-- Secure run (Injection blocked)
EXEC sp_GetReport_Secure @participantCode = 'P001'' OR 1=1--';

-- Insert participant (fires trigger)
INSERT INTO Participants (participant_code, trial_id, site_id)
VALUES ('PX01', 1, 1);

-- Update participant (fires trigger)
UPDATE Participants SET participant_code = 'PX01_NEW' WHERE participant_code = 'PX01';

-- Delete participant (fires trigger)
DELETE FROM Participants WHERE participant_code = 'PX01_NEW';

-- Log a SELECT explicitly
EXEC sp_LogSelectAudit @tableName = 'Participants', @recordId = 'P001';

-- View audit results
SELECT * FROM AuditLog ORDER BY log_timestamp DESC;
