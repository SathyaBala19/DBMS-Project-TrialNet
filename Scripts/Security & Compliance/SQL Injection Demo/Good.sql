DECLARE @input NVARCHAR(MAX) = NULL;
EXEC sp_executesql 
    N'SELECT * FROM Participants WHERE participant_code = @code',
    N'@code NVARCHAR(50)',
    @input;