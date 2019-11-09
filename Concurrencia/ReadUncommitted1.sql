USE Sk84TEC_SQL;

BEGIN TRAN UpdateUncommittedTest

	UPDATE Usuario 
	SET Usuario.Nombre = 'Ricoberto'
	WHERE Usuario.IdDireccion = 20;

COMMIT TRAN UpdateUncommittedTest;