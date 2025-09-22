-- Insert grade ≥3 AEs
INSERT INTO AdverseEvents (participant_id, visit_id, severity, description, onset_date, resolution_date)
SELECT p.participant_id, v.visit_id, 3, 'Severe Headache', '2025-02-15', NULL
FROM Participants p
JOIN Visits v ON p.participant_id = v.participant_id
WHERE p.participant_code IN ('P001','P002','P003','P006','P007');

-- Insert one adverse event per participant (P002–P010)
INSERT INTO AdverseEvents (participant_id, visit_id, severity, description, onset_date, resolution_date)
SELECT v.participant_id, v.visit_id,
       CASE WHEN v.visit_id % 2 = 0 THEN 3 ELSE 4 END, -- alternate severity
       'Severe AE for ' + p.participant_code,
       DATEADD(DAY, v.visit_id, v.visit_date), -- onset after visit
       NULL
FROM Participants p
JOIN Visits v ON p.participant_id = v.participant_id
WHERE p.participant_code BETWEEN 'P002' AND 'P010'
  AND p.participant_id NOT IN (SELECT participant_id FROM AdverseEvents);

-- Add 1 Severe Adverse Event per participant
INSERT INTO AdverseEvents (participant_id, visit_id, severity, description, onset_date, resolution_date)
SELECT v.participant_id, v.visit_id,
       CASE WHEN v.visit_id % 2 = 0 THEN 3 ELSE 4 END,
       'Severe AE for ' + p.participant_code,
       DATEADD(DAY, v.visit_id, v.visit_date),
       NULL
FROM Participants p
JOIN Visits v ON p.participant_id = v.participant_id
WHERE p.participant_code BETWEEN 'P001' AND 'P010'
  AND p.participant_id NOT IN (SELECT participant_id FROM AdverseEvents);


-- Keep query as-is, but insert new AEs within last 30 days
INSERT INTO AdverseEvents (participant_id, visit_id, severity, description, onset_date, resolution_date)
SELECT v.participant_id, v.visit_id,
       CASE WHEN v.visit_id % 2 = 0 THEN 3 ELSE 4 END,
       'Recent Severe AE for ' + p.participant_code,
       DATEADD(DAY, -ABS(CHECKSUM(NEWID())) % 20, CAST(GETDATE() AS DATE)), -- random in last 20 days
       NULL
FROM Participants p
JOIN Visits v ON p.participant_id = v.participant_id
WHERE p.participant_id NOT IN (
    SELECT participant_id
    FROM AdverseEvents
    WHERE onset_date >= DATEADD(DAY, -30, GETDATE())
);
