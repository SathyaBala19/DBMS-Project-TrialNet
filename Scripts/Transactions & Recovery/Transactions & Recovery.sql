BEGIN TRAN;

-- Consent insert
INSERT INTO Consents (participant_id, consent_date, consent_version, document_url)
VALUES (6, GETDATE(), 'v1', 'consent_P006.pdf');

SAVE TRAN sp1;

-- Randomization insert
INSERT INTO Randomization (participant_id, trial_id, arm, stratification_factor, randomization_date)
VALUES (6, 1, 'ArmA', 'Age<40', GETDATE());

-- simulate failure
ROLLBACK TRAN sp1;   -- keeps consent, removes randomization

-- Baseline Visit
INSERT INTO Visits (participant_id, trial_id, visit_date, visit_type, window_start, window_end, status)
VALUES (6, 1, GETDATE(), 'Baseline', GETDATE(), DATEADD(DAY,7,GETDATE()), 'COMPLETED');

COMMIT TRAN;