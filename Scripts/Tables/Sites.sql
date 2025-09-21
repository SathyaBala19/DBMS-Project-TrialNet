CREATE TABLE Sites (
    site_id INT IDENTITY PRIMARY KEY,
    site_name NVARCHAR(100) NOT NULL,
    location NVARCHAR(100),
    trial_id INT NOT NULL FOREIGN KEY REFERENCES Trials(trial_id)
);

SELECT * FROM Sites;