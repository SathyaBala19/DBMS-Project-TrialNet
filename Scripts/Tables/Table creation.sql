-- Trials
CREATE TABLE Trials (
    trial_id INT IDENTITY PRIMARY KEY,
    trial_name NVARCHAR(100) NOT NULL,
    phase NVARCHAR(10),
    start_date DATE,
    end_date DATE
);

-- Sites
CREATE TABLE Sites (
    site_id INT IDENTITY PRIMARY KEY,
    site_name NVARCHAR(100) NOT NULL,
    location NVARCHAR(100),
    trial_id INT NOT NULL FOREIGN KEY REFERENCES Trials(trial_id)
);

-- Participants
CREATE TABLE Participants (
    participant_id INT IDENTITY PRIMARY KEY,
    trial_id INT NOT NULL FOREIGN KEY REFERENCES Trials(trial_id),
    site_id INT NOT NULL FOREIGN KEY REFERENCES Sites(site_id),
    participant_code NVARCHAR(50) NOT NULL,
    dob DATE,
    gender CHAR(1) CHECK (gender IN ('M','F')),
    enrollment_date DATE,
    CONSTRAINT uq_participant UNIQUE (trial_id, participant_code)
);

-- Consents
CREATE TABLE Consents (
    consent_id INT IDENTITY PRIMARY KEY,
    participant_id INT NOT NULL FOREIGN KEY REFERENCES Participants(participant_id),
    consent_date DATE,
    consent_version NVARCHAR(20),
    document_url NVARCHAR(200)
);

-- Randomization
CREATE TABLE Randomization (
    rand_id INT IDENTITY PRIMARY KEY,
    participant_id INT NOT NULL FOREIGN KEY REFERENCES Participants(participant_id),
    trial_id INT NOT NULL FOREIGN KEY REFERENCES Trials(trial_id),
    arm NVARCHAR(20),
    stratification_factor NVARCHAR(50),
    randomization_date DATE
);

-- Visits
CREATE TABLE Visits (
    visit_id INT IDENTITY PRIMARY KEY,
    participant_id INT NOT NULL FOREIGN KEY REFERENCES Participants(participant_id),
    trial_id INT NOT NULL FOREIGN KEY REFERENCES Trials(trial_id),
    visit_date DATE NOT NULL,
    visit_type NVARCHAR(50),
    window_start DATE,
    window_end DATE,
    status NVARCHAR(20) CHECK (status IN ('COMPLETED','MISSED','PLANNED')),
    CONSTRAINT chk_visit_date CHECK (visit_date BETWEEN window_start AND window_end)
);

-- Labs
CREATE TABLE Labs (
    lab_id INT IDENTITY PRIMARY KEY,
    visit_id INT NOT NULL FOREIGN KEY REFERENCES Visits(visit_id),
    test_code NVARCHAR(20),
    test_name NVARCHAR(50),
    result_value DECIMAL(10,2),
    unit NVARCHAR(10),
    result_date DATE
);

-- Medications
CREATE TABLE Medications (
    med_id INT IDENTITY PRIMARY KEY,
    participant_id INT NOT NULL FOREIGN KEY REFERENCES Participants(participant_id),
    drug_name NVARCHAR(100),
    dose NVARCHAR(20),
    start_date DATE,
    end_date DATE
);

-- Adverse Events
CREATE TABLE AdverseEvents (
    ae_id INT IDENTITY PRIMARY KEY,
    participant_id INT NOT NULL FOREIGN KEY REFERENCES Participants(participant_id),
    visit_id INT FOREIGN KEY REFERENCES Visits(visit_id),
    severity INT CHECK (severity BETWEEN 1 AND 5),
    description NVARCHAR(200),
    onset_date DATE,
    resolution_date DATE
);

-- Protocol Deviations
CREATE TABLE ProtocolDeviations (
    dev_id INT IDENTITY PRIMARY KEY,
    participant_id INT NOT NULL FOREIGN KEY REFERENCES Participants(participant_id),
    visit_id INT FOREIGN KEY REFERENCES Visits(visit_id),
    deviation_type NVARCHAR(100),
    description NVARCHAR(200),
    deviation_date DATE
);

-- Audit Log
CREATE TABLE AuditLog (
    audit_id INT IDENTITY PRIMARY KEY,
    table_name NVARCHAR(50),
    record_id INT,
    action NVARCHAR(20),
    user_name NVARCHAR(100),
    log_timestamp DATETIME DEFAULT GETDATE(),
    old_value NVARCHAR(MAX),
    new_value NVARCHAR(MAX)
);
