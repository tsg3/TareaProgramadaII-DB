USE JOECv2;

-- Vista Materializada

CREATE VIEW dbo.VistaVentas
WITH SCHEMABINDING
AS 
	SELECT S.Codigo AS CodigoSucursal,
		P.Nombre AS Producto,
		COUNT_BIG(*) AS Cantidad
	FROM dbo.ReporteCaja AS RC
	INNER JOIN dbo.ReporteVenta AS RV ON RV.IdReporteCaja = RC.IdReporteCaja
	INNER JOIN dbo.Sucursal AS S ON S.IdSucursal = RC.IdSucursal
	INNER JOIN dbo.Articulo AS A ON A.IdArticulo = RV.IdArticulo
	INNER JOIN dbo.Producto AS P ON P.IdProducto = A.IdProducto
	GROUP BY S.Codigo, P.Nombre;

CREATE UNIQUE CLUSTERED INDEX VistaVentasInfo
ON dbo.VistaVentas
(
     Producto ASC, CodigoSucursal ASC
);

SELECT * from dbo.VistaVentas;
DROP VIEW dbo.VistaVentas;

--Falta Trigger de Puntos INSERT INTO ReporteVenta (IdReporteCaja, IdArticulo, NumeroVenta) VALUES (6, 25, 109);





-- Stored Procedure Transaccional

CREATE TYPE ListaArticulos AS TABLE( 
	IdListaArticulos INT IDENTITY,
	Id INT
);
DROP TYPE ListaArticulos;



CREATE PROCEDURE InsertarPais(
	@nombre VARCHAR(50))
AS
BEGIN
	INSERT INTO Pais (Nombre) VALUES (@nombre);
	RETURN 1;
END;
DROP PROCEDURE InsertarPais;



CREATE PROCEDURE InsertarProvincia(
	@id INT,
	@nombre VARCHAR(50))
AS
BEGIN
	INSERT INTO Provincia (IdPais, Nombre) VALUES (@id, @nombre);
	RETURN 1;
END;
DROP PROCEDURE InsertarProvincia;



CREATE PROCEDURE InsertarCanton(
	@id INT,
	@nombre VARCHAR(50))
AS
BEGIN
	INSERT INTO Canton (IdProvincia, Nombre) VALUES (@id, @nombre);
	RETURN 1;
END;
DROP PROCEDURE InsertarCanton;



CREATE PROCEDURE InsertarCiudad(
	@id INT,
	@nombre VARCHAR(50))
AS
BEGIN
	INSERT INTO Ciudad (IdCanton, Nombre) VALUES (@id, @nombre);
	RETURN 1;
END;
DROP PROCEDURE InsertarCiudad;



CREATE PROCEDURE InsertarDireccion(
	@id INT,
	@nombre VARCHAR(50))
AS
BEGIN
	INSERT INTO Direccion (IdCiudad, Nombre) VALUES (@id, @nombre);
	RETURN 1;
END;
DROP PROCEDURE InsertarDireccion;



CREATE PROCEDURE InsertarLugar(
	@Direccion VARCHAR(50),
	@Ciudad VARCHAR(50),
	@Canton VARCHAR(50),
	@Provincia VARCHAR(50),
	@Pais VARCHAR(50),
	@idDi INT OUTPUT)
AS
BEGIN
	DECLARE @exPa INT;
	DECLARE @exPr INT;
	DECLARE @exCa INT;
	DECLARE @exCi INT;
	DECLARE @exDi INT;
	DECLARE @idPa INT;
	DECLARE @idPr INT;
	DECLARE @idCa INT;
	DECLARE @idCi INT;

	SELECT @exPa = 1 
		FROM Pais 
		WHERE Nombre = @Pais;
	IF(@exPa IS NULL)
	BEGIN
		EXEC InsertarPais @Pais;
	END
	SELECT @idPa = IdPais 
		FROM Pais 
		WHERE Nombre = @Pais;

	SELECT @exPr = 1 
		FROM Provincia AS Pr 
		INNER JOIN Pais AS Pa ON Pa.IdPais = Pr.IdPais
		WHERE Pr.Nombre = @Provincia AND Pa.Nombre = @Pais;
	IF(@exPr IS NULL)
	BEGIN
		EXEC InsertarProvincia @idPa, @Provincia;
	END
	SELECT @idPr = Pr.IdProvincia 
		FROM Provincia AS Pr 
		INNER JOIN Pais AS Pa ON Pa.IdPais = Pr.IdPais
		WHERE Pr.Nombre = @Provincia AND Pa.Nombre = @Pais;

	SELECT @exCa = 1 
		FROM Canton AS Ca 
		INNER JOIN Provincia AS Pr ON Pr.IdProvincia = Ca.IdProvincia
		INNER JOIN Pais AS Pa ON Pa.IdPais = Pr.IdPais
		WHERE Ca.Nombre = @Canton AND Pr.Nombre = @Provincia AND Pa.Nombre = @Pais;
	IF(@exCa IS NULL)
	BEGIN
		EXEC InsertarCanton @idPr, @Canton;
	END
	SELECT @idCa = Ca.IdCanton 
		FROM Canton AS Ca 
		INNER JOIN Provincia AS Pr ON Pr.IdProvincia = Ca.IdProvincia
		INNER JOIN Pais AS Pa ON Pa.IdPais = Pr.IdPais
		WHERE Ca.Nombre = @Canton AND Pr.Nombre = @Provincia AND Pa.Nombre = @Pais;

	SELECT @exCi = 1 
		FROM Ciudad AS Ci 
		INNER JOIN Canton AS Ca ON Ca.IdCanton = Ci.IdCanton
		INNER JOIN Provincia AS Pr ON Pr.IdProvincia = Ca.IdProvincia
		INNER JOIN Pais AS Pa ON Pa.IdPais = Pr.IdPais
		WHERE Ci.Nombre = @Ciudad AND Ca.Nombre = @Canton AND Pr.Nombre = @Provincia AND Pa.Nombre = @Pais;
	IF(@exCi IS NULL)
	BEGIN
		EXEC InsertarCiudad @idCa, @Ciudad;
	END
	SELECT @idCi = Ci.IdCiudad 
		FROM Ciudad AS Ci 
		INNER JOIN Canton AS Ca ON Ca.IdCanton = Ci.IdCanton
		INNER JOIN Provincia AS Pr ON Pr.IdProvincia = Ca.IdProvincia
		INNER JOIN Pais AS Pa ON Pa.IdPais = Pr.IdPais
		WHERE Ci.Nombre = @Ciudad AND Ca.Nombre = @Canton AND Pr.Nombre = @Provincia AND Pa.Nombre = @Pais;

	SELECT @exDi = 1 
		FROM Direccion AS D
		INNER JOIN Ciudad AS Ci ON Ci.IdCiudad = D.IdCiudad
		INNER JOIN Canton AS Ca ON Ca.IdCanton = Ci.IdCanton
		INNER JOIN Provincia AS Pr ON Pr.IdProvincia = Ca.IdProvincia
		INNER JOIN Pais AS Pa ON Pa.IdPais = Pr.IdPais
		WHERE D.Nombre = @Direccion AND Ci.Nombre = @Ciudad AND Ca.Nombre = @Canton AND Pr.Nombre = @Provincia AND Pa.Nombre = @Pais;
	IF(@exDi IS NULL)
	BEGIN
		EXEC InsertarDireccion @idCi, @Direccion;
	END
	SELECT @idDi = D.IdDireccion 
		FROM Direccion AS D
		INNER JOIN Ciudad AS Ci ON Ci.IdCiudad = D.IdCiudad
		INNER JOIN Canton AS Ca ON Ca.IdCanton = Ci.IdCanton
		INNER JOIN Provincia AS Pr ON Pr.IdProvincia = Ca.IdProvincia
		INNER JOIN Pais AS Pa ON Pa.IdPais = Pr.IdPais
		WHERE D.Nombre = @Direccion AND Ci.Nombre = @Ciudad AND Ca.Nombre = @Canton AND Pr.Nombre = @Provincia AND Pa.Nombre = @Pais;
END;
DROP PROCEDURE InsertarLugar;



CREATE PROCEDURE RealizarCompra(
	@Identificacion VARCHAR(20),
	@Nombre VARCHAR(20),
	@ApellidoPat VARCHAR(20),
	@ApellidoMat VARCHAR(20),
	@FechaNacimiento DATE,
	@NumeroTelefonico VARCHAR(10),
	@Direccion VARCHAR(50),
	@Ciudad VARCHAR(50),
	@Canton VARCHAR(50),
	@Provincia VARCHAR(50),
	@Pais VARCHAR(50),
	@Articulos AS dbo.ListaArticulos READONLY)
AS
BEGIN
	BEGIN TRAN
	SET NOCOUNT ON;
	DECLARE @ex1 INT;
	SELECT @ex1 = 1
		FROM Usuario
		WHERE Identificacion = @Identificacion;
	IF(@ex1 IS NOT NULL)
	BEGIN
		DECLARE @ex2 INT;
		SELECT @ex2 = 1 
			FROM Usuario
			WHERE Identificacion = @Identificacion AND 
				Nombre = @Nombre AND 
				ApellidoPat = @ApellidoPat AND
				ApellidoMat = @ApellidoMat AND 
				FechaNacimiento = @FechaNacimiento;
		IF(@ex2 IS NULL)
		BEGIN
			PRINT 'Informacion del usuario no coincide';
			ROLLBACK TRAN
			RETURN 1;
		END
	END
	IF (@ex1 IS NULL)
	BEGIN
		DECLARE @idD INT;
		EXEC InsertarLugar @Direccion, @Ciudad, @Canton, @Provincia, @Pais, @idDi = @idD OUTPUT; 
		INSERT INTO Usuario (IdDireccion, Identificacion, Nombre, ApellidoPat, ApellidoMat, FechaNacimiento, NumeroTelefonico) VALUES
			(@idD, @Identificacion, @Nombre, @ApellidoPat, @ApellidoMat, @FechaNacimiento, @NumeroTelefonico);
	END
	DECLARE @idC INT;
	SELECT @idC = Cl.IdCliente
		FROM Cliente AS Cl
		INNER JOIN Usuario AS Us ON Us.IdUsuario = Cl.IdUsuario
		WHERE Us.Identificacion = @Identificacion;
	IF (@idC IS NULL)
	BEGIN
		DECLARE @idUs INT;
		SELECT @idUs = IdUsuario
			FROM Usuario
			WHERE Identificacion = @Identificacion;
		INSERT INTO Cliente (IdUsuario, Puntos) VALUES
			(@idUs, 0);
	END
	SELECT @idC = Cl.IdCliente
		FROM Cliente AS Cl
		INNER JOIN Usuario AS Us ON Us.IdUsuario = Cl.IdUsuario
		WHERE Us.Identificacion = @Identificacion;
	DECLARE @i INT = 2;
	DECLARE @n INT;
	SELECT @n = MAX(IdListaArticulos) FROM @Articulos;
	DECLARE @Id1 INT;
	DECLARE @IdS1 INT;
	SELECT @Id1 = Id 
		FROM @Articulos 
		WHERE IdListaArticulos = 1;
	SELECT @IdS1 = IdSucursal
		FROM Articulo
		WHERE IdArticulo = @Id1;
	WHILE (@i <= @n)
	BEGIN
		DECLARE @Idx INT;
		DECLARE @IdSx INT;
		DECLARE @IdEx VARCHAR(20);
		SELECT @Idx = Id 
			FROM @Articulos 
			WHERE IdListaArticulos = @i;
		SELECT @IdSx = IdSucursal
			FROM Articulo
			WHERE IdArticulo = @Idx;
		SELECT @IdEx = EstadoArticulo
			FROM Articulo
			WHERE IdArticulo = @Idx;
		IF(@IdS1 != @IdSx)
		BEGIN
			PRINT 'Los articulos no pertenecen a la misma sucursal';
			ROLLBACK TRAN
			RETURN 1;
		END
		IF(@IdEx != 'En sucursal')
		BEGIN
			PRINT 'Los articulos tienen que estar disponibles';
			ROLLBACK TRAN
			RETURN 1;
		END
		SET @i = @i + 1;
	END
	DECLARE @idRep INT;
	DECLARE @fec DATETIME;
	SELECT @fec = GETDATE();
	SELECT @idRep = IdReporteCaja
		FROM ReporteCaja
		WHERE CAST(FechaReporte AS DATE) = CAST(@fec AS DATE);
	IF (@idRep IS NULL)
	BEGIN
		INSERT INTO ReporteCaja (IdSucursal, FechaReporte) VALUES (@IdS1, CAST(@fec AS DATETIME));
	END
	SELECT @idRep = IdReporteCaja
		FROM ReporteCaja
		WHERE CAST(FechaReporte AS DATE) = CAST(@fec AS DATE);
	DECLARE @num INT;
	SELECT @num = MAX(NumeroVenta)+1 
		FROM ReporteVenta;
	DECLARE @CostoT INT = 0;
	SELECT @i = 1;
	WHILE (@i <= @n)
	BEGIN
		DECLARE @CostoA INT;
		DECLARE @IdA INT;
		SELECT @IdA = Id 
			FROM @Articulos 
			WHERE IdListaArticulos = @i;
		SELECT @CostoA = Costo
			From Articulo
			WHERE IdArticulo = @IdA;
		SELECT @CostoT = @CostoT + @CostoA;
		INSERT INTO ReporteVenta (IdReporteCaja, IdArticulo, NumeroVenta, IdCliente) VALUES 
			(@idRep, @IdA, @num, @idC);
		UPDATE Articulo
			SET EstadoArticulo = 'Periodo garantia'
			WHERE IdArticulo = @IdA;
		SET @i = @i + 1;
	END
	UPDATE Cliente
		SET Puntos = Puntos + @CostoT / 10000
		WHERE IdCliente = @idC;
	PRINT 'SUCCESS';
	COMMIT TRAN
	SET NOCOUNT OFF;
	RETURN 1;
END;
DROP PROCEDURE RealizarCompra;



DECLARE @ListaArticulos AS ListaArticulos;
INSERT @ListaArticulos(Id) VALUES(1), (100), (800);
EXEC RealizarCompra 'g6d4df642ve96s4r9tr0', 'Micail', 
					'Brown', 'Moore', 
					'1978-11-04', '84916071', 
					'300m del Parque', 'San Josecito', 
					'San Rafael', 'Heredia', 
					'Costa Rica', @ListaArticulos;