USE Sk84TEC_SQL;

BEGIN TRAN FailRepeatable;

	INSERT INTO Puesto (SalarioBase, Nombre) 
	VALUES (100000, 'Agente');

COMMIT TRAN FailRepeatable;