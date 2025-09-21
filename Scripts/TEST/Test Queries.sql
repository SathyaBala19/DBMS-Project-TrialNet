-- 1.Missed visits
SELECT p.participant_code, v.visit_date, v.status
FROM Participants p
JOIN Visits v ON p.participant_id = v.participant_id
WHERE v.status = 'MISSED';

-- 2.Protocol deviations
SELECT p.participant_code, d.deviation_type, d.deviation_date
FROM Participants p
JOIN ProtocolDeviations d ON p.participant_id = d.participant_id;

-- 3.Severe AEs
SELECT p.participant_code, ae.severity, ae.description
FROM AdverseEvents ae
JOIN Participants p ON ae.participant_id = p.participant_id
WHERE ae.severity >= 3;

-- 4.Lab trends
SELECT v.visit_date, l.test_name, l.result_value
FROM Labs l
JOIN Visits v ON l.visit_id = v.visit_id
ORDER BY v.visit_date;

-- 5.Enrollment by site & arm
SELECT s.site_name, r.arm, COUNT(*) AS enrolled
FROM Participants p
JOIN Randomization r ON p.participant_id = r.participant_id
JOIN Sites s ON p.site_id = s.site_id
GROUP BY s.site_name, r.arm;