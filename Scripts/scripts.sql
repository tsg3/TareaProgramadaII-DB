USE JOEC;

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