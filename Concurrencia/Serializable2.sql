USE Sk84TEC_SQL;


BEGIN TRAN SerializableTest;

	INSERT INTO Puesto(Nombre, SalarioBase)
	VALUES ('LimpiezaMayor', 90000);

	SELECT * FROM Puesto;

COMMIT TRAN SerializableTest;