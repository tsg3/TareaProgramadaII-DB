USE Sk84TEC_SQL;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

BEGIN TRAN UpdateCommitedTest;

	UPDATE Usuario
	SET Usuario.Nombre = 'Ricoberto'
	WHERE Usuario.Nombre = 'JuanGuerra';

COMMIT TRAN UpdateCommitedTest;
