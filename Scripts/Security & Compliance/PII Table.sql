CREATE TABLE ParticipantPII (
    pii_id INT IDENTITY PRIMARY KEY,
    participant_id INT FOREIGN KEY REFERENCES Participants(participant_id),
    full_name NVARCHAR(100),
    address NVARCHAR(200),
    phone NVARCHAR(20)
);