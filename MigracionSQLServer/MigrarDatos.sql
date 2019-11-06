USE JOEC;

DBCC CHECKIDENT ('Articulo', RESEED, 1)  

SET IDENTITY_INSERT dbo.ActualizacionArticuloPunto ON;
SET IDENTITY_INSERT dbo.Articulo ON;
SET IDENTITY_INSERT dbo.Canton ON;
SET IDENTITY_INSERT dbo.Ciudad ON;
SET IDENTITY_INSERT dbo.Cliente ON;
SET IDENTITY_INSERT dbo.Devolucion ON;
SET IDENTITY_INSERT dbo.Direccion ON;
SET IDENTITY_INSERT dbo.Distribuidor ON;
SET IDENTITY_INSERT dbo.DistribuidorProducto ON;
SET IDENTITY_INSERT dbo.Empleado ON;
SET IDENTITY_INSERT dbo.Envio ON;
SET IDENTITY_INSERT dbo.Marca ON;
SET IDENTITY_INSERT dbo.Pais ON;
SET IDENTITY_INSERT dbo.Producto ON;
SET IDENTITY_INSERT dbo.Promocion ON;
SET IDENTITY_INSERT dbo.Provincia ON;
SET IDENTITY_INSERT dbo.Puesto ON;
SET IDENTITY_INSERT dbo.ReporteCaja ON;
SET IDENTITY_INSERT dbo.Sucursal ON;
SET IDENTITY_INSERT dbo.TipoArticulo ON;
SET IDENTITY_INSERT dbo.Transporte ON;
SET IDENTITY_INSERT dbo.Usuario ON;

BULK INSERT Pais
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\Pais.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
KEEPIDENTITY
);

BULK INSERT Provincia
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\Provincia.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
KEEPIDENTITY
);

BULK INSERT Canton
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\Canton.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
KEEPIDENTITY
);

BULK INSERT Ciudad
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\Ciudad.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
KEEPIDENTITY
);

BULK INSERT Direccion
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\Direccion.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
KEEPIDENTITY
);

BULK INSERT Usuario
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\Usuario.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
KEEPIDENTITY
);

BULK INSERT Empleado
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\Empleado.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
KEEPIDENTITY
);

BULK INSERT Cliente
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\Cliente.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
KEEPIDENTITY
);

BULK INSERT Sucursal
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\Sucursal.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
KEEPIDENTITY
);

BULK INSERT SucursalEmpleado
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\SucursalEmpleado.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
KEEPIDENTITY
);

BULK INSERT AdministradorSucursal
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\AdministradorSucursal.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
KEEPIDENTITY
);

BULK INSERT Puesto
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\Puesto.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
KEEPIDENTITY
);

BULK INSERT PuestoEmpleado
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\PuestoEmpleado.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
KEEPIDENTITY
);

BULK INSERT Marca
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\Marca.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
KEEPIDENTITY
);

BULK INSERT TipoArticulo
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\TipoArticulo.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
KEEPIDENTITY
);

BULK INSERT Producto
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\Producto.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
KEEPIDENTITY
);

BULK INSERT DetalleProducto
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\DetalleProducto.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
KEEPIDENTITY
);

BULK INSERT Promocion
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\Promocion.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
KEEPIDENTITY
);

BULK INSERT PromocionProducto
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\PromocionProducto.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
KEEPIDENTITY
);

BULK INSERT Articulo
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\Articulo.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
KEEPIDENTITY
);

BULK INSERT ActualizacionArticuloPunto
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\ActualizacionArticuloPunto.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
KEEPIDENTITY
);

BULK INSERT ArticuloPunto
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\ArticuloPunto.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
KEEPIDENTITY
);

BULK INSERT Distribuidor
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\Distribuidor.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
KEEPIDENTITY
);

BULK INSERT DistribuidorProducto
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\DistribuidorProducto.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
KEEPIDENTITY
);

BULK INSERT DistribuidorArticulo
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\DistribuidorArticulo.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
KEEPIDENTITY
);

BULK INSERT Devolucion
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\Devolucion.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
KEEPIDENTITY
);

BULK INSERT DevolucionArticulo
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\DevolucionArticulo.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
KEEPIDENTITY
);

BULK INSERT ReporteCaja
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\ReporteCaja.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
KEEPIDENTITY
);

BULK INSERT ReporteVenta
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\ReporteVenta.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
KEEPIDENTITY
);

BULK INSERT ReporteDevolucion
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\ReporteDevolucion.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
KEEPIDENTITY
);

BULK INSERT Transporte
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\Transporte.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
KEEPIDENTITY
);

BULK INSERT Envio
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\Envio.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
KEEPIDENTITY
);

BULK INSERT EnvioTransporte
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\EnvioTransporte.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
KEEPIDENTITY
);

BULK INSERT EnvioArticulo
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\EnvioArticulo.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
KEEPIDENTITY
);

SET IDENTITY_INSERT dbo.ActualizacionArticuloPunto OFF;
SET IDENTITY_INSERT dbo.Articulo OFF;
SET IDENTITY_INSERT dbo.Canton OFF;
SET IDENTITY_INSERT dbo.Ciudad OFF;
SET IDENTITY_INSERT dbo.Cliente OFF;
SET IDENTITY_INSERT dbo.Devolucion OFF;
SET IDENTITY_INSERT dbo.Direccion OFF;
SET IDENTITY_INSERT dbo.Distribuidor OFF;
SET IDENTITY_INSERT dbo.DistribuidorProducto OFF;
SET IDENTITY_INSERT dbo.Empleado OFF;
SET IDENTITY_INSERT dbo.Envio OFF;
SET IDENTITY_INSERT dbo.Marca OFF;
SET IDENTITY_INSERT dbo.Pais OFF;
SET IDENTITY_INSERT dbo.Producto OFF;
SET IDENTITY_INSERT dbo.Promocion OFF;
SET IDENTITY_INSERT dbo.Provincia OFF;
SET IDENTITY_INSERT dbo.Puesto OFF;
SET IDENTITY_INSERT dbo.ReporteCaja OFF;
SET IDENTITY_INSERT dbo.Sucursal OFF;
SET IDENTITY_INSERT dbo.TipoArticulo OFF;
SET IDENTITY_INSERT dbo.Transporte OFF;
SET IDENTITY_INSERT dbo.Usuario OFF;