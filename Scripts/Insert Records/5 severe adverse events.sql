-- Insert grade ≥3 AEs
INSERT INTO AdverseEvents (participant_id, visit_id, severity, description, onset_date, resolution_date)
SELECT p.participant_id, v.visit_id, 3, 'Severe Headache', '2025-02-15', NULL
FROM Participants p
JOIN Visits v ON p.participant_id = v.participant_id
WHERE p.participant_code IN ('P001','P002','P003','P006','P007');