USE Sk84TEC_SQL;

BEGIN TRAN DeadlockScript

UPDATE Puesto
	SET SalarioBase = 
		SalarioBase + 20000;

SELECT FechaInicio
	FROM PuestoEmpleado;

COMMIT TRAN DeadlockScript

ROLLBACK TRAN DeadlockScript