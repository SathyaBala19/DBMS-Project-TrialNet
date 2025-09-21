CREATE INDEX idx_participant_trial_code ON Participants(trial_id, participant_code);
CREATE INDEX idx_visit_date ON Visits(visit_date);
CREATE INDEX idx_lab_test_code ON Labs(test_code);