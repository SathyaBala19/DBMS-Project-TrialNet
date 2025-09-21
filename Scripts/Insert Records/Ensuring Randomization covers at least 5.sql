INSERT INTO Randomization (participant_id, trial_id, arm, stratification_factor, randomization_date)
SELECT participant_id, trial_id, 'ArmB', 'Female', GETDATE()
FROM Participants WHERE participant_code IN ('P006','P007','P008','P009','P010');