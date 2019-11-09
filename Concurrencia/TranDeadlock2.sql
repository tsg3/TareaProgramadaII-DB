USE Sk84TEC_SQL;

BEGIN TRAN UpdateTran
	UPDATE Producto
	SET Producto.Peso = Producto.Peso
	WHERE Producto.IdProducto = 2;

	SELECT * FROM Pais
	WHERE Pais.IdPais = 2010;

COMMIT TRAN UpdateTran;