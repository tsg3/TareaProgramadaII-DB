USE Sk84TEC_SQL;


BEGIN TRAN ReadRepeatableTest;

	UPDATE Usuario
	SET Usuario.ApellidoMat = 'Ramirez'
	WHERE Usuario.IdUsuario = 56;

	SELECT * FROM Usuario
	WHERE Usuario.IdUsuario = 56;

COMMIT TRAN ReadRepeatableTest;