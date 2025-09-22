-- Insert 5 missed visits across different participants/sites
INSERT INTO Visits (participant_id, trial_id, visit_date, visit_type, window_start, window_end, status)
SELECT participant_id, trial_id, '2025-02-10', 'Follow-up', '2025-02-05', '2025-02-15', 'MISSED'
FROM Participants WHERE participant_code IN ('P003','P004','P006','P007','P009');