-- Participants → Visits → Labs query
SELECT 
    p.participant_code,
    v.visit_date,
    l.test_name,
    l.result_value
FROM Participants p
JOIN Visits v ON p.participant_id = v.participant_id
JOIN Labs l ON v.visit_id = l.visit_id
WHERE l.test_code = 'GLU'
  AND v.visit_date BETWEEN '2025-01-01' AND '2025-12-31'
ORDER BY v.visit_date;
