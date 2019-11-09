USE Sk84TEC_SQL;

SET TRANSACTION 
ISOLATION LEVEL SERIALIZABLE;

BEGIN TRAN SerializableTest;

	SELECT * FROM Puesto;

	----------------------

	SELECT * FROM Puesto;


COMMIT TRAN SerializableTest;