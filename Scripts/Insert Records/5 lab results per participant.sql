-- Insert multiple lab results
INSERT INTO Labs (visit_id, test_code, test_name, result_value, unit, result_date)
SELECT v.visit_id, 'GLU', 'Glucose', 120 + v.visit_id, 'mg/dL', v.visit_date
FROM Visits v
WHERE v.visit_id <= 5;

INSERT INTO Labs (visit_id, test_code, test_name, result_value, unit, result_date)
SELECT v.visit_id, 'HB', 'Hemoglobin', 12 + v.visit_id * 0.2, 'g/dL', v.visit_date
FROM Visits v
WHERE v.visit_id <= 5;

-- Insert at least 2 lab results for P001
INSERT INTO Labs (visit_id, test_code, test_name, result_value, unit, result_date)
SELECT v.visit_id, 'GLU', 'Glucose', 110, 'mg/dL', v.visit_date
FROM Visits v
JOIN Participants p ON v.participant_id = p.participant_id
WHERE p.participant_code = 'P001';

INSERT INTO Labs (visit_id, test_code, test_name, result_value, unit, result_date)
SELECT v.visit_id, 'HB', 'Hemoglobin', 13.5, 'g/dL', v.visit_date
FROM Visits v
JOIN Participants p ON v.participant_id = p.participant_id
WHERE p.participant_code = 'P001';

-- Insert Glucose result for all participants
INSERT INTO Labs (visit_id, test_code, test_name, result_value, unit, result_date)
SELECT v.visit_id, 'GLU', 'Glucose', 100 + v.visit_id * 2, 'mg/dL', v.visit_date
FROM Visits v
WHERE v.visit_id NOT IN (
    SELECT visit_id FROM Labs WHERE test_code = 'GLU'
);

-- Insert Hemoglobin result for all participants
INSERT INTO Labs (visit_id, test_code, test_name, result_value, unit, result_date)
SELECT v.visit_id, 'HB', 'Hemoglobin', 12 + v.visit_id * 0.5, 'g/dL', v.visit_date
FROM Visits v
WHERE v.visit_id NOT IN (
    SELECT visit_id FROM Labs WHERE test_code = 'HB'
);

-- Insert visit for P001
INSERT INTO Visits (participant_id, trial_id, visit_date, visit_type, window_start, window_end, status)
SELECT p.participant_id, p.trial_id, '2025-02-05', 'Baseline', '2025-02-01', '2025-02-10', 'COMPLETED'
FROM Participants p
WHERE p.participant_code = 'P001'
  AND p.participant_id NOT IN (SELECT participant_id FROM Visits);


-- Ensure visits for P002–P010
-- Add baseline visits for P002–P010 if missing
INSERT INTO Visits (participant_id, trial_id, visit_date, visit_type, window_start, window_end, status)
SELECT p.participant_id, p.trial_id,
       DATEADD(DAY, p.participant_id, '2025-02-05') AS visit_date, -- staggered dates
       'Baseline',
       '2025-02-01', '2025-02-15',
       CASE WHEN p.participant_id % 3 = 0 THEN 'MISSED' ELSE 'COMPLETED' END
FROM Participants p
WHERE p.participant_code BETWEEN 'P002' AND 'P010'
  AND p.participant_id NOT IN (SELECT participant_id FROM Visits);


-- Insert labs (Glucose + Hemoglobin) for each visit
-- Glucose for all new visits
INSERT INTO Labs (visit_id, test_code, test_name, result_value, unit, result_date)
SELECT v.visit_id, 'GLU', 'Glucose', 100 + v.visit_id * 2, 'mg/dL', v.visit_date
FROM Visits v
JOIN Participants p ON v.participant_id = p.participant_id
WHERE p.participant_code BETWEEN 'P002' AND 'P010'
  AND v.visit_id NOT IN (SELECT visit_id FROM Labs WHERE test_code = 'GLU');

-- Hemoglobin for all new visits
INSERT INTO Labs (visit_id, test_code, test_name, result_value, unit, result_date)
SELECT v.visit_id, 'HB', 'Hemoglobin', 12 + v.visit_id * 0.3, 'g/dL', v.visit_date
FROM Visits v
JOIN Participants p ON v.participant_id = p.participant_id
WHERE p.participant_code BETWEEN 'P002' AND 'P010'
  AND v.visit_id NOT IN (SELECT visit_id FROM Labs WHERE test_code = 'HB');
