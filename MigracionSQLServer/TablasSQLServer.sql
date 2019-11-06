CREATE DATABASE JOEC;
USE JOEC;

CREATE TABLE Pais (
	IdPais INT NOT NULL IDENTITY PRIMARY KEY,
	Nombre VARCHAR(50) NOT NULL
);

CREATE TABLE Provincia (
	IdProvincia INT NOT NULL IDENTITY PRIMARY KEY,
	IdPais INT NOT NULL,
	Nombre VARCHAR(50) NOT NULL,
	FOREIGN KEY(IdPais) REFERENCES Pais(IdPais)
);

CREATE TABLE Canton (
	IdCanton INT NOT NULL IDENTITY PRIMARY KEY,
	IdProvincia INT NOT NULL,
	Nombre VARCHAR(50) NOT NULL,
	FOREIGN KEY(IdProvincia) REFERENCES Provincia(IdProvincia)
);

CREATE TABLE Ciudad (
	IdCiudad INT NOT NULL IDENTITY PRIMARY KEY,
	IdCanton INT NOT NULL,
	Nombre VARCHAR(50) NOT NULL,
	FOREIGN KEY(IdCanton) REFERENCES Canton(IdCanton)
);

CREATE TABLE Direccion (
	IdDireccion INT NOT NULL IDENTITY PRIMARY KEY,
	IdCiudad INT NOT NULL,
	Nombre VARCHAR(50) NOT NULL,
	FOREIGN KEY(IdCiudad) REFERENCES Ciudad(IdCiudad)
);

CREATE TABLE Usuario (
	IdUsuario INT NOT NULL IDENTITY PRIMARY KEY,
	IdDireccion INT NOT NULL,
	Identificacion VARCHAR(20) NOT NULL,
	Nombre VARCHAR(20) NOT NULL,
	ApellidoPat VARCHAR(20) NOT NULL,
	ApellidoMat VARCHAR(20) NOT NULL,
	FechaNacimiento DATE NOT NULL, 
	NumeroTelefonico VARCHAR(10) NOT NULL,
	FOREIGN KEY (IdDireccion) REFERENCES Direccion(IdDireccion)
);

CREATE TABLE Empleado (
	IdEmpleado INT NOT NULL IDENTITY PRIMARY KEY,
	IdUsuario INT NOT NULL,
	FechaIngreso DATE NOT NULL,
	CuentaBancaria VARCHAR(20) NOT NULL,
	Estado BIT NOT NULL,
	FOREIGN KEY (IdUsuario) REFERENCES Usuario(IdUsuario)
);

CREATE TABLE Cliente (
	IdCliente INT NOT NULL IDENTITY PRIMARY KEY,
	IdUsuario INT NOT NULL,
	Puntos INT NOT NULL,
	FOREIGN KEY (IdUsuario) REFERENCES Usuario(IdUsuario)
);

CREATE TABLE Sucursal (
	IdSucursal INT NOT NULL IDENTITY PRIMARY KEY,
	IdDireccion INT NOT NULL,
	NumeroTelefonico VARCHAR(10) NOT NULL,
	Codigo VARCHAR(50) NOT NULL,
	Estado BIT NOT NULL,
	FOREIGN KEY (IdDireccion) REFERENCES Direccion(IdDireccion)
);

CREATE TABLE SucursalEmpleado (
	IdSucursal INT NOT NULL,
	IdEmpleado INT NOT NULL,
	FechaInicio DATE NOT NULL,
	FOREIGN KEY (IdSucursal) REFERENCES Sucursal(IdSucursal),
	FOREIGN KEY (IdEmpleado) REFERENCES Empleado(IdEmpleado)
);

CREATE TABLE AdministradorSucursal (
	IdSucursal INT NOT NULL,
	IdEmpleado INT NOT NULL,
	Fecha DATE NOT NULL,
	FOREIGN KEY (IdSucursal) REFERENCES Sucursal(IdSucursal),
	FOREIGN KEY (IdEmpleado) REFERENCES Empleado(IdEmpleado)
);

CREATE TABLE Puesto (
	IdPuesto INT NOT NULL IDENTITY PRIMARY KEY,
	SalarioBase INT NOT NULL, 
	Nombre VARCHAR(20) NOT NULL
);

CREATE TABLE PuestoEmpleado (
	IdPuesto INT NOT NULL,
	IdEmpleado INT NOT NULL,
	FechaInicio DATE NOT NULL,
	FOREIGN KEY (IdPuesto) REFERENCES Puesto (IdPuesto),
	FOREIGN KEY (IdEmpleado) REFERENCES Empleado (IdEmpleado)
);

CREATE TABLE Marca (
	IdMarca INT NOT NULL IDENTITY PRIMARY KEY,
	NombreMarca VARCHAR(20) NOT NULL,
	FechaAdicion DATE NOT NULL
);

CREATE TABLE TipoArticulo (
	IdTipoArticulo INT NOT NULL IDENTITY PRIMARY KEY,
	Nombre VARCHAR(20) NOT NULL
);

CREATE TABLE Producto (
	IdProducto INT NOT NULL IDENTITY PRIMARY KEY,
	IdMarca INT NOT NULL,
	IdTipoArticulo INT NOT NULL,
	Nombre VARCHAR(20) NOT NULL,
	Codigo VARCHAR(20) NOT NULL,
	Peso INT NOT NULL,
	TiempoGarantia INT NOT NULL,
	Sexo VARCHAR(1) NOT NULL,
	Medida VARCHAR(3) NOT NULL,
	FechaAdicion DATE NOT NULL,
	FOREIGN KEY (IdMarca) REFERENCES Marca(IdMarca),
	FOREIGN KEY (IdTipoArticulo) REFERENCES TipoArticulo(IdTipoArticulo)
);

CREATE TABLE DetalleProducto (
	IdProducto INT NOT NULL,
	Detalle VARCHAR(20) NOT NULL,
	Descripcion VARCHAR(20) NOT NULL,
	FOREIGN KEY (IdProducto) REFERENCES Producto(IdProducto)
);

CREATE TABLE Promocion (
	IdPromocion INT NOT NULL IDENTITY PRIMARY KEY,
	IdSucursal INT NOT NULL,
	FechaHoraInicio DATETIME NOT NULL,
	FechaHoraFin DATETIME NOT NULL,
	Porcentaje INT NOT NULL,
	FOREIGN KEY (IdSucursal) REFERENCES Sucursal (IdSucursal)
);

CREATE TABLE PromocionProducto (
	IdPromocion INT NOT NULL,
	IdProducto INT NOT NULL,
	FOREIGN KEY (IdPromocion) REFERENCES Promocion (IdPromocion),
	FOREIGN KEY (IdProducto) REFERENCES Producto (IdProducto)
);

CREATE TABLE Articulo (
	IdArticulo INT NOT NULL IDENTITY PRIMARY KEY,
	IdProducto INT NOT NULL,
	IdSucursal INT,
	Estado BIT NOT NULL,
	EstadoArticulo VARCHAR(20) NOT NULL,
	Costo INT,
	FOREIGN KEY (IdProducto) REFERENCES Producto(IdProducto),
	FOREIGN KEY (IdSucursal) REFERENCES Sucursal(IdSucursal)
);

CREATE TABLE ActualizacionArticuloPunto(
	IdActualizacionArticuloPunto INT NOT NULL IDENTITY PRIMARY KEY,
	FechaInicio DATE NOT NULL,
	FechaFinal DATE NOT NULL
);

CREATE TABLE ArticuloPunto(
	IdActualizacionArticuloPunto INT NOT NULL,
	IdProducto INT NOT NULL,
	Puntos INT NOT NULL,
	FOREIGN KEY (IdActualizacionArticuloPunto) REFERENCES ActualizacionArticuloPunto(IdActualizacionArticuloPunto),
	FOREIGN KEY (IdProducto) REFERENCES Producto(IdProducto)
);

CREATE TABLE Distribuidor (
	IdDistribuidor INT NOT NULL IDENTITY PRIMARY KEY,
	Nombre VARCHAR(20) NOT NULL,
	Telefono VARCHAR(10) NOT NULL
);

CREATE TABLE DistribuidorProducto (
	IdDistribuidorProducto INT NOT NULL IDENTITY PRIMARY KEY,
	IdDistribuidor INT NOT NULL,
	Costo INT NOT NULL,
	IdProducto INT NOT NULL,
	FOREIGN KEY (IdDistribuidor) REFERENCES Distribuidor(IdDistribuidor),
	FOREIGN KEY (IdProducto) REFERENCES Producto(IdProducto)
);


CREATE TABLE DistribuidorArticulo (
	IdDistribuidorProducto INT NOT NULL,
	IdArticulo INT NOT NULL,
	Fecha DATE NOT NULL,
	FOREIGN KEY (IdDistribuidorProducto) REFERENCES DistribuidorProducto(IdDistribuidorProducto),
	FOREIGN KEY (IdArticulo) REFERENCES Articulo(IdArticulo)
);

CREATE TABLE Devolucion (
	IdDevolucion INT NOT NULL IDENTITY PRIMARY KEY,
	IdDistribuidor INT NOT NULL,
	Fecha DATE NOT NULL,
	FOREIGN KEY (IdDistribuidor) REFERENCES Distribuidor(IdDistribuidor)
);

CREATE TABLE DevolucionArticulo (
	IdDevolucion INT NOT NULL,
	IdArticulo INT NOT NULL,
	FOREIGN KEY (IdDevolucion) REFERENCES Devolucion(IdDevolucion),
	FOREIGN KEY (IdArticulo) REFERENCES Articulo(IdArticulo)
);

CREATE TABLE ReporteCaja (
	IdReporteCaja INT NOT NULL IDENTITY PRIMARY KEY,
	IdSucursal INT NOT NULL,
	FechaReporte DATETIME NOT NULL,
	FOREIGN KEY (IdSucursal) REFERENCES Sucursal(IdSucursal)
);

CREATE TABLE ReporteVenta (
	IdReporteCaja INT NOT NULL,
	IdArticulo INT NOT NULL,
	NumeroVenta INT NOT NULL,
	IdCliente INT NOT NULL,
	FOREIGN KEY (IdReporteCaja) REFERENCES ReporteCaja(IdReporteCaja),
	FOREIGN KEY (IdArticulo) REFERENCES Articulo(IdArticulo),
	FOREIGN KEY (IdCliente) REFERENCES Cliente(IdCliente)
);

CREATE TABLE ReporteDevolucion (
	IdReporteCaja INT NOT NULL,
	IdArticulo INT NOT NULL,
	IdCliente INT NOT NULL,
	FOREIGN KEY (IdReporteCaja) REFERENCES ReporteCaja(IdReporteCaja),
	FOREIGN KEY (IdArticulo) REFERENCES Articulo(IdArticulo),
	FOREIGN KEY (IdCliente) REFERENCES Cliente(IdCliente)
);

CREATE TABLE Transporte (
	IdTransporte INT NOT NULL IDENTITY PRIMARY KEY,
	Nombre VARCHAR(20) NOT NULL,
	Telefono VARCHAR(10) NOT NULL
);

CREATE TABLE Envio (
	IdEnvio INT NOT NULL IDENTITY PRIMARY KEY,
	IdSucursal INT NOT NULL,
	FechaHoraLlegada DATETIME NOT NULL,
	FechaHoraSalida DATETIME NOT NULL,
	FOREIGN KEY (IdSucursal) REFERENCES Sucursal(IdSucursal)
);

CREATE TABLE EnvioTransporte (
	IdEnvio INT NOT NULL,
	IdTransporte INT NOT NULL,
	FOREIGN KEY (IdEnvio) REFERENCES Envio(IdEnvio),
	FOREIGN KEY (IdTransporte) REFERENCES Transporte(IdTransporte)
);

CREATE TABLE EnvioArticulo (
	IdEnvio INT NOT NULL,
	IdArticulo INT NOT NULL,
	FOREIGN KEY (IdEnvio) REFERENCES Envio(IdEnvio),
	FOREIGN KEY (IdArticulo) REFERENCES Articulo(IdArticulo)
);

EXEC sp_MSforeachtable @command1 = "DROP TABLE ?";