USE Sk84TEC_SQL;

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

BEGIN TRAN FailRepeatable;

	SELECT * FROM Puesto
	WHERE Puesto.SalarioBase = 100000;

	--------------------------

	SELECT * FROM Puesto
	WHERE Puesto.SalarioBase = 100000;

COMMIT TRAN FailRepeatable;