---------------------------------------------------------
-- Transactions & Recovery Demonstration (All in One)
---------------------------------------------------------
BEGIN TRAN;

---------------------------------------------------------
-- 1. Enroll Participant (Consent + Randomization + Visit)
---------------------------------------------------------
INSERT INTO Consents (participant_code, consent_date, consent_version, document_url)
VALUES ('P007', GETDATE(), 'v2', 'consent_P007.pdf');

SAVE TRAN consent_step;  -- savepoint after consent

INSERT INTO Randomization (participant_code, trial_id, arm, stratification_factor, randomization_date)
VALUES ('P007', 1, 'ArmB', 'Age>=40', GETDATE());

INSERT INTO Visits (participant_code, trial_id, visit_date, visit_type, window_start, window_end, visit_status)
VALUES ('P007', 1, GETDATE(), 'Baseline', GETDATE(), DATEADD(DAY,7,GETDATE()), 'SCHEDULED');

---------------------------------------------------------
-- 2. SAVEPOINT / ROLLBACK (simulate consent doc failure)
---------------------------------------------------------
INSERT INTO Consents (participant_code, consent_date, consent_version, document_url)
VALUES ('P008', GETDATE(), 'v1', 'consent_P008.pdf');

SAVE TRAN sp1;  -- mark savepoint

INSERT INTO Randomization (participant_code, trial_id, arm, stratification_factor, randomization_date)
VALUES ('P008', 1, 'ArmC', 'Gender=Male', GETDATE());

-- Simulate failure → rollback to savepoint (keeps consent, removes randomization)
ROLLBACK TRAN sp1;

INSERT INTO Visits (participant_code, trial_id, visit_date, visit_type, window_start, window_end, visit_status)
VALUES ('P008', 1, GETDATE(), 'Baseline', GETDATE(), DATEADD(DAY,7,GETDATE()), 'PENDING');

---------------------------------------------------------
-- 3. Concurrency Control (limited slots per site)
---------------------------------------------------------
-- Example: lock site row while counting participants
SELECT COUNT(*) 
FROM Participants WITH (UPDLOCK, HOLDLOCK)
WHERE site_id = 2;

-- Insert only if slots available
INSERT INTO Participants (participant_code, site_id, trial_id, enrollment_date)
VALUES ('P009', 2, 1, GETDATE());

---------------------------------------------------------
-- 4. Recovery: Partial Failure during Lab Import
---------------------------------------------------------
INSERT INTO Labs (participant_code, test_code, result_value, result_date)
VALUES ('P010', 'HB', 13.2, GETDATE()),
       ('P010', 'GLU', 95, GETDATE());

SAVE TRAN import_point;

-- Simulated invalid record
INSERT INTO Labs (participant_code, test_code, result_value, result_date)
VALUES ('P010', 'INVALIDCODE', 50, GETDATE());

-- Rollback only invalid row
ROLLBACK TRAN import_point;

-- Reconcile valid records
UPDATE Labs
SET lab_status = 'RECONCILED'
WHERE participant_code = 'P010';

---------------------------------------------------------
COMMIT TRAN;
---------------------------------------------------------
