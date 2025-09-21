DECLARE @sql NVARCHAR(MAX) =
'SELECT * FROM Participants WHERE participant_code = ''' + @input + '''';
EXEC (@sql);
