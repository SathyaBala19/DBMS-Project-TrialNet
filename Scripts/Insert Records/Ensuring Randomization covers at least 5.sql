INSERT INTO Randomization (participant_id, trial_id, arm, stratification_factor, randomization_date)
SELECT participant_id, trial_id, 'ArmB', 'Female', GETDATE()
FROM Participants WHERE participant_code IN ('P006','P007','P008','P009','P010');

-- Insert demo unblind actions into AuditLog
INSERT INTO AuditLog (table_name, record_id, action, user_name, log_timestamp, old_value, new_value)
SELECT 'Randomization', r.rand_id, 'UNBLIND', 'monitor1', GETDATE(),
       'Blinded', 'Unblinded'
FROM Randomization r
JOIN Participants p ON r.participant_id = p.participant_id
WHERE p.participant_code IN ('P003','P007');
