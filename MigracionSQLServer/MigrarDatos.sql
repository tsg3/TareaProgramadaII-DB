BULK INSERT Pais
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\Pais.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
);

BULK INSERT Provincia
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\Provincia.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
);

BULK INSERT Canton
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\Canton.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
);

BULK INSERT Ciudad
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\Ciudad.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
);

BULK INSERT Direccion
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\Direccion.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
);

BULK INSERT Usuario
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\Usuario.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
);

BULK INSERT Empleado
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\Empleado.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
);

BULK INSERT Cliente
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\Cliente.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
);

BULK INSERT Sucursal
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\Sucursal.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
);

BULK INSERT SucursalEmpleado
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\SucursalEmpleado.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
);

BULK INSERT AdministradorSucursal
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\AdministradorSucursal.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
);

BULK INSERT Puesto
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\Puesto.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
);

BULK INSERT PuestoEmpleado
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\PuestoEmpleado.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
);

BULK INSERT Marca
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\Marca.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
);

BULK INSERT TipoArticulo
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\TipoArticulo.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
);

BULK INSERT Producto
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\Producto.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
);

BULK INSERT DetalleProducto
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\DetalleProducto.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
);

BULK INSERT Promocion
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\Promocion.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
);

BULK INSERT PromocionProducto
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\PromocionProducto.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
);

BULK INSERT Articulo
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\Articulo.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
);

BULK INSERT ActualizacionArticuloPunto
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\ActualizacionArticuloPunto.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
);

BULK INSERT ArticuloPunto
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\ArticuloPunto.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
);

BULK INSERT Distribuidor
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\Distribuidor.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
);

BULK INSERT DistribuidorProducto
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\DistribuidorProducto.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
);

BULK INSERT DistribuidorArticulo
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\DistribuidorArticulo.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
);

BULK INSERT Devolucion
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\Devolucion.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
);

BULK INSERT DevolucionArticulo
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\DevolucionArticulo.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
);

BULK INSERT ReporteCaja
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\ReporteCaja.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
);

BULK INSERT ReporteVenta
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\ReporteVenta.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
);

BULK INSERT ReporteDevolucion
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\ReporteDevolucion.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
);

BULK INSERT Transporte
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\Transporte.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
);

BULK INSERT Envio
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\Envio.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
);

BULK INSERT EnvioTransporte
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\EnvioTransporte.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
);

BULK INSERT EnvioArticulo
FROM 'C:\Users\este0\Desktop\Esteban\TEC\2019 - II Semestre\Bases de Datos\Progra 2\MigracionSQLServer\Datos\EnvioArticulo.csv'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
);

