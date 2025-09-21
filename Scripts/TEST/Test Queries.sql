-- 1.Enrollment counts by site and arm
SELECT s.site_name, r.arm, COUNT(*) AS enrolled
FROM Participants p
JOIN Randomization r ON p.participant_id = r.participant_id
JOIN Sites s ON p.site_id = s.site_id
GROUP BY s.site_name, r.arm;

-- 2.Participants with missed visits or protocol deviations
SELECT p.participant_code, 'Missed Visit' AS issue, v.visit_date
FROM Participants p
JOIN Visits v ON p.participant_id = v.participant_id
WHERE v.status = 'MISSED'
UNION
SELECT p.participant_code, 'Protocol Deviation' AS issue, d.deviation_date
FROM Participants p
JOIN ProtocolDeviations d ON p.participant_id = d.participant_id;

-- Severe adverse events (grade ≥3) in last 30 days
SELECT p.participant_code, ae.severity, ae.description, ae.onset_date
FROM AdverseEvents ae
JOIN Participants p ON ae.participant_id = p.participant_id
WHERE ae.severity >= 3
  AND ae.onset_date >= CAST(DATEADD(DAY, -30, GETDATE()) AS DATE);

 -- 4.Lab value trends for a participant across visits (P001 example)
SELECT v.visit_date, l.test_name, l.result_value
FROM Labs l
JOIN Visits v ON l.visit_id = v.visit_id
JOIN Participants p ON v.participant_id = p.participant_id
WHERE p.participant_code = 'P001'
ORDER BY v.visit_date;

SELECT p.participant_code, COUNT(l.lab_id) AS lab_count
FROM Participants p
JOIN Visits v ON p.participant_id = v.participant_id
LEFT JOIN Labs l ON v.visit_id = l.visit_id
WHERE p.participant_code BETWEEN 'P001' AND 'P010'
GROUP BY p.participant_code
ORDER BY p.participant_code;
