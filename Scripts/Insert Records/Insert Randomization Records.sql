-- Insert Randomization with correct participant_ids
INSERT INTO Randomization (participant_id, trial_id, arm, stratification_factor, randomization_date)
SELECT participant_id, trial_id, 'ArmA', 'Age<40', GETDATE()
FROM Participants WHERE participant_code = 'P001';

INSERT INTO Randomization (participant_id, trial_id, arm, stratification_factor, randomization_date)
SELECT participant_id, trial_id, 'ArmB', 'Age>40', GETDATE()
FROM Participants WHERE participant_code = 'P002';

INSERT INTO Randomization (participant_id, trial_id, arm, stratification_factor, randomization_date)
SELECT participant_id, trial_id, 'ArmA', 'Male', GETDATE()
FROM Participants WHERE participant_code = 'P003';

INSERT INTO Randomization (participant_id, trial_id, arm, stratification_factor, randomization_date)
SELECT participant_id, trial_id, 'ArmB', 'Female', GETDATE()
FROM Participants WHERE participant_code = 'P004';

INSERT INTO Randomization (participant_id, trial_id, arm, stratification_factor, randomization_date)
SELECT participant_id, trial_id, 'ArmA', 'Male', GETDATE()
FROM Participants WHERE participant_code = 'P005';
