CREATE TRIGGER trg_audit_participants
ON Participants
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @action NVARCHAR(20);
    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
        SET @action = 'UPDATE';
    ELSE IF EXISTS (SELECT * FROM inserted)
        SET @action = 'INSERT';
    ELSE
        SET @action = 'DELETE';

    INSERT INTO AuditLog (table_name, record_id, action, user_name, old_value, new_value)
    SELECT 'Participants',
           COALESCE(i.participant_id, d.participant_id),
           @action,
           SUSER_SNAME(),
           (SELECT * FROM deleted d FOR JSON AUTO),
           (SELECT * FROM inserted i FOR JSON AUTO)
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.participant_id = d.participant_id;
END;