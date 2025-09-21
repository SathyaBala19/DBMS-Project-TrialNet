------------------------------------------------------------
-- Report 1: Enrollment Counts by Site and Arm
------------------------------------------------------------
SELECT s.site_name, r.arm, COUNT(*) AS enrolled
FROM Participants p
JOIN Randomization r ON p.participant_id = r.participant_id
JOIN Sites s ON p.site_id = s.site_id
GROUP BY s.site_name, r.arm
ORDER BY s.site_name, r.arm;

------------------------------------------------------------
-- Report 2: Participants with Missed Visits or Protocol Deviations
------------------------------------------------------------
SELECT 
    p.participant_code, 
    v.visit_date, 
    v.status, 
    d.deviation_type, 
    d.deviation_date
FROM Participants p
LEFT JOIN Visits v 
    ON p.participant_id = v.participant_id 
   AND v.status = 'MISSED'
LEFT JOIN ProtocolDeviations d 
    ON p.participant_id = d.participant_id
WHERE v.visit_id IS NOT NULL 
   OR d.deviation_type IS NOT NULL
ORDER BY p.participant_code;

------------------------------------------------------------
-- Report 3: Severe Adverse Events (Grade ≥3, Last 30 Days)
------------------------------------------------------------
SELECT p.participant_code, ae.severity, ae.description, ae.onset_date
FROM AdverseEvents ae
JOIN Participants p ON ae.participant_id = p.participant_id
WHERE ae.severity >= 3
  AND ae.onset_date >= DATEADD(DAY, -30, GETDATE())
ORDER BY ae.onset_date DESC;

------------------------------------------------------------
-- Report 4: Lab Value Trends Across Visits (Glucose Example)
------------------------------------------------------------
SELECT p.participant_code, v.visit_date, l.test_name, l.result_value
FROM Labs l
JOIN Visits v ON l.visit_id = v.visit_id
JOIN Participants p ON v.participant_id = p.participant_id
WHERE l.test_name = 'Glucose'
ORDER BY p.participant_code, v.visit_date;

------------------------------------------------------------
-- Report 5: DSMB Dataset Extract (Per Arm)
------------------------------------------------------------
SELECT r.arm, p.participant_code, v.visit_date, l.test_name, l.result_value, ae.severity, ae.description
FROM Participants p
JOIN Randomization r ON p.participant_id = r.participant_id
LEFT JOIN Visits v ON p.participant_id = v.participant_id
LEFT JOIN Labs l ON v.visit_id = l.visit_id
LEFT JOIN AdverseEvents ae ON p.participant_id = ae.participant_id
ORDER BY r.arm, p.participant_code, v.visit_date;

------------------------------------------------------------
-- Report 6: Per-Site Retention Rate
------------------------------------------------------------
SELECT s.site_name,
       COUNT(DISTINCT v.participant_id) * 1.0 / COUNT(DISTINCT p.participant_id) AS retention_rate
FROM Sites s
JOIN Participants p ON s.site_id = p.site_id
LEFT JOIN Visits v ON p.participant_id = v.participant_id AND v.status = 'COMPLETED'
GROUP BY s.site_name;