USE Sk84TEC_SQL;

BEGIN TRAN DeadlockCursor

	DECLARE @id INT;

	DECLARE Deadlocker CURSOR GLOBAL FOR
			SELECT IdPuesto
			FROM Puesto
		FOR UPDATE;
	OPEN Deadlocker;

	FETCH NEXT FROM Deadlocker INTO
		@id;

	--WHILE(@@FETCH_STATUS = 0)
	--BEGIN
		UPDATE PuestoEmpleado
			SET FechaInicio =
				CAST(GETDATE() AS DATE)
			WHERE IdPuesto = @id;
		DECLARE @id INT;
		FETCH NEXT FROM Deadlocker INTO
			@id;
	--END

	CLOSE Deadlocker;
	DEALLOCATE Deadlocker;

COMMIT TRAN DeadlockCursor

ROLLBACK TRAN DeadlockCursor