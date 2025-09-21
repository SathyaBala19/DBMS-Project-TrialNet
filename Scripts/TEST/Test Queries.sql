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

-- Lab value trends for any participant (e.g., P005)
SELECT v.visit_date, l.test_name, l.result_value
FROM Labs l
JOIN Visits v ON l.visit_id = v.visit_id
JOIN Participants p ON v.participant_id = p.participant_id
WHERE p.participant_code = 'P005'
ORDER BY v.visit_date;

-- 5. Randomization balance check by baseline covariates
-- (a) By gender
SELECT r.arm, p.gender, COUNT(*) AS participant_count
FROM Randomization r
JOIN Participants p ON r.participant_id = p.participant_id
GROUP BY r.arm, p.gender;
-- (b) By age group
SELECT r.arm,
       CASE 
           WHEN DATEDIFF(YEAR, p.dob, GETDATE()) < 30 THEN 'Under 30'
           WHEN DATEDIFF(YEAR, p.dob, GETDATE()) BETWEEN 30 AND 50 THEN '30-50'
           ELSE '50+' 
       END AS age_group,
       COUNT(*) AS participant_count
FROM Randomization r
JOIN Participants p ON r.participant_id = p.participant_id
GROUP BY r.arm,
         CASE 
             WHEN DATEDIFF(YEAR, p.dob, GETDATE()) < 30 THEN 'Under 30'
             WHEN DATEDIFF(YEAR, p.dob, GETDATE()) BETWEEN 30 AND 50 THEN '30-50'
             ELSE '50+' 
         END;

-- 6. Participants unblinded accidentally (from Audit Log)
SELECT *
FROM AuditLog
WHERE action = 'UNBLIND'
  AND table_name = 'Randomization';
  -- or
SELECT a.audit_id, a.log_timestamp, a.user_name, 
       p.participant_code, r.arm,
       a.old_value, a.new_value
FROM AuditLog a
JOIN Randomization r ON a.record_id = r.rand_id
JOIN Participants p ON r.participant_id = p.participant_id
WHERE a.action = 'UNBLIND'
  AND a.table_name = 'Randomization'
ORDER BY a.log_timestamp DESC;

-- 7. Generate dataset extract for DSMB per trial arm
SELECT p.participant_code, r.arm, v.visit_date,
       l.test_name, l.result_value,
       ae.description AS adverse_event
FROM Participants p
JOIN Randomization r ON p.participant_id = r.participant_id
LEFT JOIN Visits v ON p.participant_id = v.participant_id
LEFT JOIN Labs l ON v.visit_id = l.visit_id
LEFT JOIN AdverseEvents ae ON v.visit_id = ae.visit_id
ORDER BY r.arm, p.participant_code, v.visit_date;

-- 8. View: Participant, LatestVisitDate, Arm, CompliancePercent
GO
CREATE VIEW vw_ParticipantCompliance AS
SELECT p.participant_code, r.arm,
       MAX(v.visit_date) AS LatestVisitDate,
       (CAST(SUM(CASE WHEN v.status = 'COMPLETED' THEN 1 ELSE 0 END) AS DECIMAL(5,2)) 
        / COUNT(*)) * 100 AS CompliancePercent
FROM Participants p
JOIN Randomization r ON p.participant_id = r.participant_id
JOIN Visits v ON p.participant_id = v.participant_id
GROUP BY p.participant_code, r.arm;
GO
-- Use the view
SELECT * FROM vw_ParticipantCompliance;

-- 9. Retention Rate – Method 1
SELECT s.site_name,
       COUNT(DISTINCT v.participant_id) * 1.0 / COUNT(DISTINCT p.participant_id) AS retention
FROM Sites s
JOIN Participants p ON s.site_id = p.site_id
LEFT JOIN Visits v ON p.participant_id = v.participant_id AND v.status = 'COMPLETED'
GROUP BY s.site_name;

-- 10. Retention Rate – Method 2 (Subquery)
SELECT s.site_name,
       (SELECT COUNT(DISTINCT v.participant_id)
        FROM Visits v JOIN Participants p2 ON v.participant_id = p2.participant_id
        WHERE v.status = 'COMPLETED' AND p2.site_id = s.site_id) * 1.0 /
       COUNT(DISTINCT p.participant_id) AS retention
FROM Sites s
JOIN Participants p ON s.site_id = p.site_id
GROUP BY s.site_id, s.site_name;

-- 11. Aggregate functions on Lab Results
SELECT test_name,
       AVG(result_value) AS avg_val,
       MIN(result_value) AS min_val,
       MAX(result_value) AS max_val
FROM Labs
GROUP BY test_name;

-- 12. Participants with both missed visits AND deviations
SELECT DISTINCT p.participant_code
FROM Participants p
WHERE p.participant_id IN (SELECT participant_id FROM Visits WHERE status='MISSED')
  AND p.participant_id IN (SELECT participant_id FROM ProtocolDeviations);