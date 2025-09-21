-- Average Glucose values per site (only for participants with completed visits)
SELECT s.site_name,
       AVG(l.result_value) AS avg_glucose,
       MIN(l.result_value) AS min_glucose,
       MAX(l.result_value) AS max_glucose,
       COUNT(*) AS total_tests
FROM Labs l
JOIN Visits v ON l.visit_id = v.visit_id
JOIN Participants p ON v.participant_id = p.participant_id
JOIN Sites s ON p.site_id = s.site_id
WHERE l.test_name = 'Glucose'
  AND v.status = 'COMPLETED'
  AND p.participant_id IN (
      -- Subquery: only include participants who have at least 1 protocol deviation
      SELECT DISTINCT participant_id
      FROM ProtocolDeviations
  )
GROUP BY s.site_name
ORDER BY avg_glucose DESC;

-- Variation 1: Aggregate + Joins (No Subquery)
-- Completed visits and average Hemoglobin per site
SELECT s.site_name,
       COUNT(v.visit_id) AS total_completed_visits,
       AVG(l.result_value) AS avg_hemoglobin
FROM Visits v
JOIN Participants p ON v.participant_id = p.participant_id
JOIN Sites s ON p.site_id = s.site_id
JOIN Labs l ON v.visit_id = l.visit_id
WHERE v.status = 'COMPLETED'
  AND l.test_name = 'Hemoglobin'
GROUP BY s.site_name
ORDER BY total_completed_visits DESC;


-- Variation 2: Subquery with Aggregates
-- Participants with above-average Glucose levels
SELECT p.participant_code,
       AVG(l.result_value) AS avg_glucose
FROM Participants p
JOIN Visits v ON p.participant_id = v.participant_id
JOIN Labs l ON v.visit_id = l.visit_id
WHERE l.test_name = 'Glucose'
GROUP BY p.participant_code
HAVING AVG(l.result_value) > (
    -- Subquery: overall average glucose across all participants
    SELECT AVG(result_value)
    FROM Labs
    WHERE test_name = 'Glucose'
);
