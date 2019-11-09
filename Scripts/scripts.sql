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
			PRINT 'ERROR: La identificación proporcionada no coincide con la demás información del usuario!';
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
			PRINT 'ERROR: Los articulos no pertenecen a la misma sucursal!';
			ROLLBACK TRAN
			RETURN 1;
		END
		IF(@IdEx != 'En sucursal')
		BEGIN
			PRINT 'ERROR: Los articulos tienen que estar disponibles!';
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
	PRINT 'ÉXITO: Transacción realizada!';
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



-- Consulta ineficiente


CREATE FUNCTION dbo.CalcularPuntos(
	@Dinero INT)
	RETURNS INT AS
	BEGIN
		RETURN @Dinero / 10000;
	END
DROP FUNCTION CalcularPuntos;


SELECT SQ2.Nombre, 
		SQ2.ApellidoPat, 
		SQ2.ApellidoMat, 
	(SELECT DATEDIFF(hour, FechaNacimiento, GETDATE()) / 8766
		FROM Usuario AS U
		INNER JOIN Cliente AS C ON C.IdUsuario = U.IdUsuario
		WHERE C.IdCliente = A.IdCliente) AS Edad,
	(SELECT COUNT(IdArticulo)
		FROM ReporteVenta
		WHERE IdCliente = A.IdCliente) AS ArticulosComprados,
	(SELECT COUNT(DISTINCT NumeroVenta)
		FROM ReporteVenta
		WHERE IdCliente = A.IdCliente) AS NumeroFacturas,
	SQ1.UltimaCompra,
	SQ1.FechaUltimaCompra,
	SQ.DineroGastado,
	SQ.PuntosObtenidos,
	SQ.Ganador,
	SQ.Premio
FROM Cliente AS A
LEFT JOIN (
    SELECT RV.IdCliente, 
		SUM(Ar.Costo) AS DineroGastado,
		(CASE
			WHEN (SUM(Ar.Costo) > 1000000) THEN 'Si'
			ELSE 'No'
		END) AS Ganador, 
		(SELECT dbo.CalcularPuntos(SUM(Ar.Costo))) AS PuntosObtenidos,
		(SELECT TOP 1 Nombre 
			FROM Producto
			WHERE SUM(Ar.Costo) > 1000000 AND (IdProducto = 23 OR IdProducto = 24)
			ORDER BY NEWID()) AS Premio
	FROM ReporteVenta AS RV
	INNER JOIN Articulo AS Ar ON Ar.IdArticulo = RV.IdArticulo
	GROUP BY RV.IdCliente) AS SQ ON SQ.IdCliente = A.IdCliente
LEFT JOIN (SELECT Cl.IdCliente, Us.Nombre, Us.ApellidoPat, Us.ApellidoMat
	FROM Usuario Us
	INNER JOIN Cliente AS Cl ON Cl.IdUsuario = Us.IdUsuario
	GROUP BY Cl.IdCliente, Us.Nombre, Us.ApellidoPat, Us.ApellidoMat) AS SQ2 ON SQ2.IdCliente = A.IdCliente
OUTER APPLY (
	SELECT TOP 1 RV.NumeroVenta AS UltimaCompra, 
		RV.IdCliente,
		CONVERT(DATE, RC.FechaReporte, 23) AS FechaUltimaCompra
	FROM ReporteVenta AS RV
	INNER JOIN ReporteCaja AS RC ON RC.IdReporteCaja = RV.IdReporteCaja
	WHERE RV.IdCliente = A.IdCliente
	GROUP BY RV.NumeroVenta, RC.FechaReporte, RV.IdCliente
	ORDER BY RC.FechaReporte DESC) AS SQ1
ORDER BY DineroGastado DESC;


-- Optimizacion


SELECT SQ2.Nombre, 
		SQ2.ApellidoPat, 
		SQ2.ApellidoMat, 
	(SELECT DATEDIFF(hour, FechaNacimiento, GETDATE()) / 8766
		FROM Usuario AS U
		INNER JOIN Cliente AS C ON C.IdUsuario = U.IdUsuario
		WHERE C.IdCliente = A.IdCliente) AS Edad,
	(SELECT COUNT(IdArticulo)
		FROM ReporteVenta
		WHERE IdCliente = A.IdCliente) AS ArticulosComprados,
	(SELECT COUNT(DISTINCT NumeroVenta)
		FROM ReporteVenta
		WHERE IdCliente = A.IdCliente) AS NumeroFacturas,
	SQ1.UltimaCompra,
	SQ1.FechaUltimaCompra,
	SQ.DineroGastado,
	SQ.PuntosObtenidos,
	SQ.Ganador,
	SQ.Premio
FROM Cliente AS A
LEFT JOIN (
    SELECT RV.IdCliente, 
		SUM(Ar.Costo) AS DineroGastado,
		(CASE
			WHEN (SUM(Ar.Costo) > 1000000) THEN 'Si'
			ELSE 'No'
		END) AS Ganador, 
		(SELECT dbo.CalcularPuntos(SUM(Ar.Costo))) AS PuntosObtenidos, 
		(SELECT TOP 1 Nombre 
			FROM Producto
			WHERE SUM(Ar.Costo) > 1000000 AND IdProducto = FLOOR(RAND()*(25-23)+23)) AS Premio
	FROM ReporteVenta AS RV
	INNER JOIN Articulo AS Ar ON Ar.IdArticulo = RV.IdArticulo
	GROUP BY RV.IdCliente) AS SQ ON SQ.IdCliente = A.IdCliente
LEFT JOIN (SELECT Cl.IdCliente, Us.Nombre, Us.ApellidoPat, Us.ApellidoMat
	FROM Usuario Us
	INNER JOIN Cliente AS Cl ON Cl.IdUsuario = Us.IdUsuario
	GROUP BY Cl.IdCliente, Us.Nombre, Us.ApellidoPat, Us.ApellidoMat) AS SQ2 ON SQ2.IdCliente = A.IdCliente
OUTER APPLY (
	SELECT MAX(RV.NumeroVenta) AS UltimaCompra,
		CONVERT(DATE, RC.FechaReporte, 23) AS FechaUltimaCompra
	FROM ReporteVenta AS RV
	INNER JOIN ReporteCaja AS RC ON RC.IdReporteCaja = RV.IdReporteCaja
	WHERE RV.IdCliente = A.IdCliente
	GROUP BY RC.FechaReporte) AS SQ1
ORDER BY DineroGastado DESC;


-- SP transaccional de dos niveles


CREATE PROCEDURE InsertarReporteDev (
	@Articulo INT,
	@Cliente INT,
	@ReporteOld INT OUTPUT,
	@Reporte INT OUTPUT,
	@NumeroVenta INT OUTPUT, 
	@Sucursal INT OUTPUT)
	AS
	BEGIN
		BEGIN TRAN

		DECLARE @exA INT;
		SELECT @exA = IdArticulo, @Sucursal = IdSucursal
			FROM Articulo
			WHERE IdArticulo = @Articulo AND EstadoArticulo = 'Periodo garantia';
		IF (@Sucursal IS NULL OR @exA IS NULL)
		BEGIN
			PRINT 'ERROR: El artículo que se quiere devolver no está en periodo de garantía!';
			ROLLBACK TRAN
			RETURN 1;
		END

		DECLARE @relAC INT;
		SELECT @relAC = IdCliente, @NumeroVenta = NumeroVenta, @ReporteOld = IdReporteCaja
			FROM ReporteVenta
			WHERE IdArticulo = @Articulo AND IdCliente = @Cliente;
		IF (@relAC IS NULL)
		BEGIN
			PRINT 'ERROR: La devolución del artículo la debe realizar el cliente a la cuál la compra está registrada!';
			ROLLBACK TRAN
			RETURN 1;
		END

		DECLARE @fec DATETIME;
		SELECT @fec = GETDATE();
		SELECT @Reporte = IdReporteCaja
			FROM ReporteCaja
			WHERE CAST(FechaReporte AS DATE) = CAST(@fec AS DATE) AND IdSucursal = @Sucursal;
		IF (@Reporte IS NULL)
		BEGIN
			INSERT INTO ReporteCaja (IdSucursal, FechaReporte) VALUES (@Sucursal, CAST(@fec AS DATETIME));
			SELECT @Reporte = SCOPE_IDENTITY();
		END

		INSERT INTO ReporteDevolucion (IdReporteCaja, IdArticulo, IdCliente) VALUES (@Reporte, @Articulo, @Cliente);
		COMMIT TRAN
		RETURN 1;
	END;
DROP PROCEDURE InsertarReporteDev;



CREATE PROCEDURE CambiarArticulo (
	@Articulo INT,
	@Cliente INT)
	AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN

			DECLARE @idRepOld INT;
			DECLARE @idRep INT;
			DECLARE @numV INT;
			DECLARE @suc INT;
			EXEC InsertarReporteDev @Articulo, 
				@Cliente, 
				@ReporteOld = @idRepOld OUTPUT, 
				@Reporte = @idRep OUTPUT, 
				@NumeroVenta = @numV OUTPUT, 
				@Sucursal = @suc OUTPUT;

			UPDATE Articulo 
				SET EstadoArticulo = 'Devuelto'
				WHERE IdArticulo = @Articulo;

			DECLARE @prod INT;
			SELECT @prod = IdProducto
				FROM Articulo
				WHERE IdArticulo = @Articulo;

			DECLARE @reempl INT;
			SELECT @reempl = IdArticulo
				FROM Articulo
				WHERE IdProducto = @prod AND IdSucursal = @suc AND EstadoArticulo = 'En sucursal';

			UPDATE Articulo 
				SET EstadoArticulo = 'Periodo garantia'
				WHERE IdArticulo = @reempl;

			UPDATE ReporteVenta 
				SET IdArticulo = @reempl
				WHERE IdReporteCaja = @idRepOld AND IdArticulo = @Articulo AND NumeroVenta = @numV AND IdCliente = @Cliente;

			COMMIT TRAN
			RETURN 1;
		END TRY
		BEGIN CATCH
			IF(@@TRANCOUNT = 0)
			BEGIN
				RETURN 1;
			END
		END CATCH
	END;
DROP PROCEDURE CambiarArticulo;



CREATE PROCEDURE DevolverArticulo (
	@Articulo INT,
	@Cliente INT)
	AS
	BEGIN
		SET NOCOUNT ON;
		BEGIN TRY
			BEGIN TRAN

			EXEC CambiarArticulo @Articulo, @Cliente;

			DECLARE @dist INT;
			SELECT @dist = D.IdDistribuidor
				FROM Distribuidor AS D
				INNER JOIN DistribuidorProducto AS DP ON DP.IdDistribuidor = D.IdDistribuidor
				INNER JOIN DistribuidorArticulo AS DA ON DA.IdDistribuidorProducto = DP.IdDistribuidorProducto
				INNER JOIN Articulo AS A ON A.IdArticulo = DA.IdArticulo
				WHERE A.IdArticulo = @Articulo;

			DECLARE @dev INT;
			DECLARE @fec DATE;
			SELECT @fec = CAST(GETDATE() AS DATE);
			SELECT @dev = IdDevolucion
				FROM Devolucion
				WHERE IdDistribuidor = @dist AND Fecha = @fec;
			IF(@dev IS NULL)
			BEGIN
				INSERT INTO Devolucion (IdDistribuidor, Fecha) VALUES (@dist, @fec);
				SELECT @dev = SCOPE_IDENTITY();
			END

			INSERT INTO DevolucionArticulo (IdDevolucion, IdArticulo) VALUES (@dev, @Articulo);

			COMMIT TRAN
			SET NOCOUNT OFF;
			RETURN 1;
		END TRY
		BEGIN CATCH
			IF(@@TRANCOUNT = 0)
			BEGIN
				SET NOCOUNT OFF;
				RETURN 1;
			END
		END CATCH
	END;
DROP PROCEDURE DevolverArticulo;

EXEC DevolverArticulo 2, 149;





-- SP con XML


CREATE PROCEDURE CargarPromocionesXML (
	@Archivo AS XML)
	AS
	BEGIN
		BEGIN TRAN

		SET NOCOUNT ON;
		SET IDENTITY_INSERT dbo.Promocion ON;
		DECLARE @Temp TABLE ( 
			IdTemp INT,
			Sucursal INT,
			Fin DATETIME,
			Porcentaje INT,
			Producto INT
		);
		INSERT INTO @Temp (IdTemp, Sucursal, Fin, Porcentaje, Producto)
		SELECT x.v.value('@id', 'INT'),
			x.v.value('@sucursal', 'INT'),
			x.v.value('@fin', 'DATETIME'),
			x.v.value('@porcentaje', 'INT'),
			y.v.value('@id', 'INT')
		FROM @Archivo.nodes('lista/promocion') AS x(v)
		CROSS APPLY x.v.nodes('producto') AS y(v);
		DECLARE @i INT;
		SET @i = 1;
		DECLARE @n INT;
		SELECT @n = MAX(IdTemp) FROM @Temp;
		DECLARE @offset INT;
		SELECT @offset = MAX(IdPromocion) FROM Promocion;
		DECLARE @fec DATETIME;
		SELECT @fec = GETDATE();
		WHILE (@i <= @n)
		BEGIN
			INSERT INTO Promocion (IdPromocion, IdSucursal, FechaHoraInicio, FechaHoraFin, Porcentaje)
				SELECT DISTINCT @offset + @i, Sucursal, @fec, Fin, Porcentaje
					FROM @Temp
					WHERE IdTemp = @i;
			INSERT INTO PromocionProducto (IdPromocion, IdProducto)
				SELECT @offset + @i, Producto
					FROM @Temp
					WHERE IdTemp = @i;
			SET @i = @i + 1;
		END
		SET	NOCOUNT OFF;
		SET IDENTITY_INSERT dbo.Promocion OFF;

		COMMIT TRAN
		RETURN 1;
	END;
DROP PROCEDURE CargarPromocionesXML;


DECLARE @XML AS XML;
SET @XML =	'<lista>
						<promocion id="1"
							sucursal="3" 
							fin="2019-12-15 23:59:59.599"
							porcentaje="25">
							<producto id="2"></producto>
							<producto id="13"></producto>
							<producto id="14"></producto>
						</promocion>
						<promocion id="2"
							sucursal="2" 
							fin="2019-11-27 23:59:59.599"
							porcentaje="15">
							<producto id="5"></producto>
							<producto id="11"></producto>
						</promocion>
					</lista>';
EXEC CargarPromocionesXML @XML;





-- SP con table-valued parameters


CREATE TYPE ListaPromociones AS TABLE(
	IdBase INT,
	Sucursal INT,
	Fin DATETIME,
	Porcentaje INT,
	Producto INT
);
DROP TYPE ListaPromociones;


CREATE PROCEDURE CargarPromocionesTVP (
	@Archivo AS dbo.ListaPromociones READONLY)
	AS
	BEGIN
		BEGIN TRAN

		SET NOCOUNT ON;
		SET IDENTITY_INSERT dbo.Promocion ON;
		DECLARE @i INT;
		SET @i = 1;
		DECLARE @n INT;
		SELECT @n = MAX(IdBase) FROM @Archivo;
		DECLARE @offset INT;
		SELECT @offset = MAX(IdPromocion) FROM Promocion;
		DECLARE @fec DATETIME;
		SELECT @fec = GETDATE();
		WHILE (@i <= @n)
		BEGIN
			INSERT INTO Promocion (IdPromocion, IdSucursal, FechaHoraInicio, FechaHoraFin, Porcentaje)
				SELECT DISTINCT @offset + @i, Sucursal, @fec, Fin, Porcentaje
					FROM @Archivo
					WHERE IdBase = @i;
			INSERT INTO PromocionProducto (IdPromocion, IdProducto)
				SELECT @offset + @i, Producto
					FROM @Archivo
					WHERE IdBase = @i;
			SET @i = @i + 1;
		END
		SET	NOCOUNT OFF;
		SET IDENTITY_INSERT dbo.Promocion OFF;

		COMMIT TRAN
		RETURN 1;
	END;
DROP PROCEDURE CargarPromocionesTVP;


DECLARE @TVP AS ListaPromociones;
INSERT @TVP (IdBase, Sucursal, Fin, Porcentaje, Producto) VALUES
(1, 3, CAST('2019-12-15 23:59:59.599' AS DATETIME), 25, 2),
(1, 3, CAST('2019-12-15 23:59:59.599' AS DATETIME), 25, 13),
(1, 3, CAST('2019-12-15 23:59:59.599' AS DATETIME), 25, 14),
(2, 2, CAST('2019-11-27 23:59:59.599' AS DATETIME), 15, 5),
(2, 2, CAST('2019-11-27 23:59:59.599' AS DATETIME), 15, 11);
EXEC CargarPromocionesTVP @TVP;

SELECT * FROM Promocion;
SELECT * FROM PromocionProducto;





-- SP con cursores


CREATE PROCEDURE AnalizarInventario
	AS BEGIN
		SET NOCOUNT ON;
		DECLARE SucursalCursor CURSOR 
				LOCAL 
				SCROLL
			FOR SELECT IdSucursal
					FROM Sucursal;
		DECLARE @producto INT;
		DECLARE @sucursal INT;
		DECLARE @i INT;
		DECLARE @cantidad INT;
		SET @i = 1;
		OPEN ProductosCursor;
		OPEN SucursalCursor;
		FETCH NEXT FROM ProductosCursor INTO 
			@producto;
		FETCH NEXT FROM SucursalCursor INTO 
			@sucursal;
		WHILE (@@FETCH_STATUS = 0)
		BEGIN
			WHILE (@@FETCH_STATUS = 0)
			BEGIN
				SELECT @cantidad = COUNT(1)
					FROM Articulo
					WHERE IdSucursal = @sucursal AND IdProducto = @producto AND EstadoArticulo = 'En sucursal';
				PRINT CAST(@i AS VARCHAR) + 
					' : En la sucursal ' + 
					CAST(@sucursal AS VARCHAR) + 
					' hay ' + 
					CAST(@cantidad AS VARCHAR) +
					' articulos del producto ' + 
					CAST(@producto AS VARCHAR);
				FETCH NEXT FROM SucursalCursor INTO 
					@sucursal;
				SET @i = @i + 1;
			END
			FETCH FIRST FROM SucursalCursor INTO 
				@sucursal;
			FETCH NEXT FROM ProductosCursor INTO 
				@producto;
		END
		CLOSE ProductosCursor;
		CLOSE SucursalCursor;
		DEALLOCATE ProductosCursor;
		DEALLOCATE SucursalCursor;
		SET NOCOUNT OFF;
		RETURN 1;
	END;
DROP PROCEDURE AnalizarInventario;


DECLARE ProductosCursor CURSOR 
		GLOBAL 
		FORWARD_ONLY 
		FAST_FORWARD 
		READ_ONLY
	FOR SELECT IdProducto
			FROM Producto;
EXEC AnalizarInventario;