CREATE TABLE Trials (
    trial_id INT IDENTITY PRIMARY KEY,
    trial_name NVARCHAR(100) NOT NULL,
    phase NVARCHAR(10),
    start_date DATE,
    end_date DATE
);

-- SELECT * FROM Trials;