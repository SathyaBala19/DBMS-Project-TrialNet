-- Insert multiple lab results
INSERT INTO Labs (visit_id, test_code, test_name, result_value, unit, result_date)
SELECT v.visit_id, 'GLU', 'Glucose', 120 + v.visit_id, 'mg/dL', v.visit_date
FROM Visits v
WHERE v.visit_id <= 5;

INSERT INTO Labs (visit_id, test_code, test_name, result_value, unit, result_date)
SELECT v.visit_id, 'HB', 'Hemoglobin', 12 + v.visit_id * 0.2, 'g/dL', v.visit_date
FROM Visits v
WHERE v.visit_id <= 5;


-- 1. Ensure visits for P001–P010
INSERT INTO Visits (participant_id, trial_id, visit_date, visit_type, window_start, window_end, status)
SELECT p.participant_id, p.trial_id,
       DATEADD(DAY, p.participant_id, '2025-02-05') AS visit_date, -- staggered dates
       'Baseline',
       '2025-02-01', '2025-02-15',
       CASE WHEN p.participant_id % 3 = 0 THEN 'MISSED' ELSE 'COMPLETED' END
FROM Participants p
WHERE p.participant_code BETWEEN 'P001' AND 'P010'
  AND p.participant_id NOT IN (SELECT participant_id FROM Visits);

-- 2. Insert Glucose lab for each visit if missing
INSERT INTO Labs (visit_id, test_code, test_name, result_value, unit, result_date)
SELECT v.visit_id, 'GLU', 'Glucose',
       100 + v.visit_id * 2, 'mg/dL', v.visit_date
FROM Visits v
JOIN Participants p ON v.participant_id = p.participant_id
WHERE p.participant_code BETWEEN 'P001' AND 'P010'
  AND v.visit_id NOT IN (SELECT visit_id FROM Labs WHERE test_code = 'GLU');

-- 3. Insert Hemoglobin lab for each visit if missing
INSERT INTO Labs (visit_id, test_code, test_name, result_value, unit, result_date)
SELECT v.visit_id, 'HB', 'Hemoglobin',
       12 + v.visit_id * 0.5, 'g/dL', v.visit_date
FROM Visits v
JOIN Participants p ON v.participant_id = p.participant_id
WHERE p.participant_code BETWEEN 'P001' AND 'P010'
  AND v.visit_id NOT IN (SELECT visit_id FROM Labs WHERE test_code = 'HB');