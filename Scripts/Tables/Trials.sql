CREATE TABLE Trials (
  trial_id INT IDENTITY(1,1) PRIMARY KEY,
  trial_name NVARCHAR(200) NOT NULL,
  phase NVARCHAR(10) CHECK (phase IN('I','II','III')),
  start_date DATE,
  end_date DATE
);

INSERT INTO Trials (trial_name, phase, start_date, end_date)
VALUES
('TrialNet Diabetes Study', 'II', '2025-01-01', '2026-12-31'),
('TrialNet Immunotherapy Study', 'III', '2025-03-01', '2027-06-30'),
('TrialNet Early Screening Study', 'I', '2024-09-01', '2025-09-01');

-- SELECT * FROM Trials;

-- DELETE FROM Trials;
-- DBCC CHECKIDENT ('Trials', RESEED, 0);