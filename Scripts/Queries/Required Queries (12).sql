/* =========================
   Required Queries (12)
   ========================= */

-- 1. Enrollment counts by site and arm [REPORT]
SELECT s.site_name, r.arm, COUNT(*) AS enrolled
FROM Participants p
JOIN Randomization r ON p.participant_id = r.participant_id
JOIN Sites s ON p.site_id = s.site_id
GROUP BY s.site_name, r.arm;

-- 2. Participants with missed visits
SELECT p.participant_code, v.visit_date, v.status
FROM Participants p
JOIN Visits v ON p.participant_id = v.participant_id
WHERE v.status = 'MISSED';

-- 3. Participants with protocol deviations
SELECT p.participant_code, d.deviation_type, d.deviation_date
FROM Participants p
JOIN ProtocolDeviations d ON p.participant_id = d.participant_id;

-- 4. Severe adverse events (≥3) in last 30 days [REPORT]
SELECT p.participant_code, ae.severity, ae.description, ae.onset_date
FROM AdverseEvents ae
JOIN Participants p ON ae.participant_id = p.participant_id
WHERE ae.severity >= 3
  AND ae.onset_date >= DATEADD(DAY, -30, GETDATE());

-- 5. Lab value trends for a participant (P001)
SELECT v.visit_date, l.test_name, l.result_value
FROM Labs l
JOIN Visits v ON l.visit_id = v.visit_id
JOIN Participants p ON v.participant_id = p.participant_id
WHERE p.participant_code = 'P001'
ORDER BY v.visit_date;

-- 6. Randomization balance check
SELECT r.arm, p.gender, COUNT(*) AS total
FROM Randomization r
JOIN Participants p ON r.participant_id = p.participant_id
GROUP BY r.arm, p.gender;

-- 7. Participants unblinded accidentally (Audit log)
SELECT * FROM AuditLog
WHERE action = 'UNBLIND'
AND table_name = 'Randomization';

-- 8. DSMB dataset extract [REPORT]
SELECT p.participant_code, r.arm, v.visit_date, l.test_name, l.result_value, ae.description
FROM Participants p
JOIN Randomization r ON p.participant_id = r.participant_id
LEFT JOIN Visits v ON p.participant_id = v.participant_id
LEFT JOIN Labs l ON v.visit_id = l.visit_id
LEFT JOIN AdverseEvents ae ON v.visit_id = ae.visit_id;

-- 9. View: Participant Compliance [REPORT]
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
SELECT * FROM vw_ParticipantCompliance;

-- 10. Per-site retention rate (Method 1)
SELECT s.site_name,
       COUNT(DISTINCT v.participant_id) * 1.0 / COUNT(DISTINCT p.participant_id) AS retention
FROM Sites s
JOIN Participants p ON s.site_id = p.site_id
LEFT JOIN Visits v ON p.participant_id = v.participant_id AND v.status = 'COMPLETED'
GROUP BY s.site_name;

-- 11. Per-site retention rate (Method 2 – subquery)
SELECT 
    s.site_name,
    (
        SELECT COUNT(DISTINCT v.participant_id)
        FROM Visits v
        JOIN Participants p2 ON v.participant_id = p2.participant_id
        WHERE v.status = 'COMPLETED'
          AND p2.site_id = s.site_id
    ) * 1.0 / COUNT(DISTINCT p.participant_id) AS retention
FROM Sites s
JOIN Participants p ON s.site_id = p.site_id
GROUP BY s.site_id, s.site_name;

-- 12. Aggregate functions on lab results
SELECT test_name, AVG(result_value) AS avg_val,
       MIN(result_value) AS min_val, MAX(result_value) AS max_val
FROM Labs
GROUP BY test_name;





SELECT * FROM Participants;
SELECT * FROM Randomization;
