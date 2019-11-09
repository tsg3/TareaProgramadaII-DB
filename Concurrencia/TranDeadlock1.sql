USE Sk84TEC_SQL;

BEGIN TRAN UpdateTran
	UPDATE Pais
	SET Pais.Nombre = 'Argelia'
	WHERE Pais.IdPais = 2010;

	SELECT * FROM Producto
	WHERE Producto.IdProducto = 2;

COMMIT TRAN UpdateTran;  
