CREATE TABLE Trials (
    trial_id INT IDENTITY(1,1) PRIMARY KEY,
    trial_name NVARCHAR(200) NOT NULL,
    phase VARCHAR(10) CHECK (phase IN ('I','II','III')),
    start_date DATE,
    end_date DATE
);
