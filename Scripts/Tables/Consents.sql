CREATE TABLE Consents (
    consent_id INT IDENTITY(1,1) PRIMARY KEY,
    version NVARCHAR(20),
    date_signed DATE,
    signed_by NVARCHAR(100),
    investigator_signature NVARCHAR(100)
);

INSERT INTO Consents (version, date_signed, signed_by, investigator_signature)
VALUES
('v1.0', '2025-02-01', 'John Doe', 'Dr. Smith'),
('v1.0', '2025-02-02', 'Alice Brown', 'Dr. Adams'),
('v1.0', '2025-03-05', 'Michael Chen', 'Dr. Lee'),
('v1.1', '2025-03-10', 'Sara Khan', 'Dr. Muller'),
('v1.0', '2025-01-20', 'Kenji Sato', 'Dr. Tanaka');

-- SELECT * FROM Consents;