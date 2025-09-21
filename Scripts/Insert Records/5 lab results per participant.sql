-- Insert multiple lab results
INSERT INTO Labs (visit_id, test_code, test_name, result_value, unit, result_date)
SELECT v.visit_id, 'GLU', 'Glucose', 120 + v.visit_id, 'mg/dL', v.visit_date
FROM Visits v
WHERE v.visit_id <= 5;

INSERT INTO Labs (visit_id, test_code, test_name, result_value, unit, result_date)
SELECT v.visit_id, 'HB', 'Hemoglobin', 12 + v.visit_id * 0.2, 'g/dL', v.visit_date
FROM Visits v
WHERE v.visit_id <= 5;