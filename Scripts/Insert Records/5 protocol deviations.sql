-- Insert deviations linked to visits
INSERT INTO ProtocolDeviations (participant_id, visit_id, deviation_type, description, deviation_date)
SELECT p.participant_id, v.visit_id, 'Late Visit', 'Participant came 2 days late', '2025-02-12'
FROM Participants p
JOIN Visits v ON p.participant_id = v.participant_id
WHERE p.participant_code IN ('P001','P002','P005','P008','P010');

-- Insert 5 fresh deviations for specific participants
INSERT INTO ProtocolDeviations (participant_id, visit_id, deviation_type, description, deviation_date)
SELECT v.participant_id, v.visit_id, 'Missed Procedure',
       'Deviation for ' + p.participant_code,
       DATEADD(DAY,2,v.visit_date)
FROM Participants p
JOIN Visits v ON p.participant_id = v.participant_id
WHERE p.participant_code IN ('P001','P002','P003','P004','P005');

-- Verification
SELECT p.participant_code, d.deviation_type, d.deviation_date
FROM Participants p
JOIN ProtocolDeviations d ON p.participant_id = d.participant_id;

-- Generate deviations for all participants with at least one visit
-- Add deviations for all participants that have visits
INSERT INTO ProtocolDeviations (participant_id, visit_id, deviation_type, description, deviation_date)
SELECT v.participant_id, v.visit_id,
       'Missed Procedure',
       'Deviation auto-added for ' + p.participant_code,
       DATEADD(DAY,2,v.visit_date)
FROM Participants p
JOIN Visits v ON p.participant_id = v.participant_id
WHERE p.participant_id NOT IN (SELECT participant_id FROM ProtocolDeviations);
