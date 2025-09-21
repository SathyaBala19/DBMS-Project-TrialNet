CREATE TABLE Participants (
    participant_id INT IDENTITY(1,1) PRIMARY KEY,
    trial_id INT FOREIGN KEY REFERENCES Trials(trial_id),
    site_id INT FOREIGN KEY REFERENCES Sites(site_id),
    consent_id INT FOREIGN KEY REFERENCES Consents(consent_id),
    participant_code NVARCHAR(50) NOT NULL,
    dob DATE,
    gender NVARCHAR(10),
    enrollment_status NVARCHAR(20) CHECK (enrollment_status IN ('Screened','Enrolled','Withdrawn')),
    eligibility_flag BIT,
    UNIQUE(trial_id, participant_code)
);

INSERT INTO Participants (trial_id, site_id, consent_id, participant_code, dob, gender, enrollment_status, eligibility_flag)
VALUES
(1, 1, 1, 'P001', '1990-05-10', 'Male', 'Enrolled', 1),
(1, 2, 2, 'P002', '1985-07-20', 'Female', 'Enrolled', 1),
(2, 3, 3, 'P003', '1992-09-15', 'Male', 'Screened', 1),
(2, 4, 4, 'P004', '1978-11-30', 'Female', 'Enrolled', 1),
(3, 5, 5, 'P005', '2000-01-25', 'Male', 'Enrolled', 1),
(1, 1, 1, 'P006', '1995-12-10', 'Female', 'Withdrawn', 0),
(1, 2, 2, 'P007', '1988-04-17', 'Male', 'Enrolled', 1),
(2, 3, 3, 'P008', '1993-06-05', 'Female', 'Enrolled', 1),
(2, 4, 4, 'P009', '1982-02-12', 'Male', 'Screened', 1),
(3, 5, 5, 'P010', '1999-08-22', 'Female', 'Enrolled', 1);
