CREATE TABLE Sites (
    site_id INT IDENTITY(1,1) PRIMARY KEY,
    trial_id INT FOREIGN KEY REFERENCES Trials(trial_id),
    site_name NVARCHAR(200) NOT NULL,
    location NVARCHAR(200),
    investigator NVARCHAR(100)
);

INSERT INTO Sites (trial_id, site_name, location, investigator)
VALUES
(1, 'Site A', 'New York, USA', 'Dr. Smith'),
(1, 'Site B', 'London, UK', 'Dr. Adams'),
(2, 'Site C', 'Chicago, USA', 'Dr. Lee'),
(2, 'Site D', 'Berlin, Germany', 'Dr. Muller'),
(3, 'Site E', 'Tokyo, Japan', 'Dr. Tanaka');

SELECT * FROM Sites;

-- DELETE FROM Sites;
-- DBCC CHECKIDENT ('Sites', RESEED, 0);