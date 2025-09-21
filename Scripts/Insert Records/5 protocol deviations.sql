-- Insert deviations linked to visits
INSERT INTO ProtocolDeviations (participant_id, visit_id, deviation_type, description, deviation_date)
SELECT p.participant_id, v.visit_id, 'Late Visit', 'Participant came 2 days late', '2025-02-12'
FROM Participants p
JOIN Visits v ON p.participant_id = v.participant_id
WHERE p.participant_code IN ('P001','P002','P005','P008','P010');