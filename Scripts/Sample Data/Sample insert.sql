-- Trial
INSERT INTO Trials (trial_name, phase, start_date, end_date)
VALUES ('Diabetes Control Trial', 'Phase II', '2025-01-01', '2026-12-31');

-- Sites
INSERT INTO Sites (site_name, location, trial_id) VALUES
('Site A', 'New York', 1),
('Site B', 'Chicago', 1),
('Site C', 'Los Angeles', 1);

-- Participants (10)
INSERT INTO Participants (trial_id, site_id, participant_code, dob, gender, enrollment_date) VALUES
(1, 1, 'P001', '1980-05-12', 'M', '2025-01-15'),
(1, 1, 'P002', '1975-11-23', 'F', '2025-01-16'),
(1, 2, 'P003', '1990-04-10', 'M', '2025-01-17'),
(1, 2, 'P004', '1982-08-19', 'F', '2025-01-18'),
(1, 2, 'P005', '1995-02-28', 'M', '2025-01-19'),
(1, 3, 'P006', '1988-09-05', 'F', '2025-01-20'),
(1, 3, 'P007', '1977-01-14', 'M', '2025-01-21'),
(1, 3, 'P008', '1985-03-29', 'F', '2025-01-22'),
(1, 3, 'P009', '1992-07-07', 'M', '2025-01-23'),
(1, 3, 'P010', '1981-12-02', 'F', '2025-01-24');

-- Consents
INSERT INTO Consents (participant_id, consent_date, consent_version, document_url) VALUES
(1, '2025-01-15', 'v1', 'consent_P001.pdf'),
(2, '2025-01-16', 'v1', 'consent_P002.pdf'),
(3, '2025-01-17', 'v1', 'consent_P003.pdf'),
(4, '2025-01-18', 'v1', 'consent_P004.pdf'),
(5, '2025-01-19', 'v1', 'consent_P005.pdf');

-- SELECT * FROM Trials;
-- SELECT * FROM Sites;
-- SELECT * FROM Participants;
-- SELECT * FROM Consents;