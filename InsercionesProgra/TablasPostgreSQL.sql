CREATE TABLE Pais (
	IdPais SERIAL PRIMARY KEY,
	Nombre VARCHAR(50) NOT NULL
);

CREATE TABLE Provincia (
	IdProvincia SERIAL PRIMARY KEY,
	IdPais INTEGER,
	Nombre VARCHAR(50) NOT NULL,
	FOREIGN KEY(IdPais) REFERENCES Pais(IdPais)
);

CREATE TABLE Canton (
	IdCanton SERIAL PRIMARY KEY,
	IdProvincia INTEGER,
	Nombre VARCHAR(50) NOT NULL,
	FOREIGN KEY(IdProvincia) REFERENCES Provincia(IdProvincia)
);

CREATE TABLE Ciudad (
	IdCiudad SERIAL PRIMARY KEY,
	IdCanton INTEGER,
	Nombre VARCHAR(50) NOT NULL,
	FOREIGN KEY(IdCanton) REFERENCES Canton(IdCanton)
);

CREATE TABLE Direccion (
	IdDireccion SERIAL PRIMARY KEY,
	IdCiudad INTEGER,
	Nombre VARCHAR(50) NOT NULL,
	FOREIGN KEY(IdCiudad) REFERENCES Ciudad(IdCiudad)
);

CREATE TABLE Usuario (
	IdUsuario SERIAL PRIMARY KEY,
	IdDireccion INTEGER,
	Identificacion VARCHAR(20)  NOT NULL,
	Nombre VARCHAR(20) NOT NULL,
	ApellidoPat VARCHAR(20) NOT NULL,
	ApellidoMat VARCHAR(20) NOT NULL,
	FechaNacimiento DATE NOT NULL, 
	NumeroTelefonico VARCHAR(10) NOT NULL,
	FOREIGN KEY (IdDireccion) REFERENCES Direccion(IdDireccion)
);

CREATE TABLE Empleado (
	IdEmpleado SERIAL PRIMARY KEY,
	IdUsuario INTEGER,
	FechaIngreso DATE NOT NULL,
	CuentaBancaria VARCHAR(20) NOT NULL,
	Estado BOOLEAN NOT NULL,
	FOREIGN KEY (IdUsuario) REFERENCES Usuario(IdUsuario)
);

CREATE TABLE Cliente (
	IdCliente SERIAL PRIMARY KEY,
	IdUsuario INTEGER,
	Puntos INTEGER NOT NULL,
	FOREIGN KEY (IdUsuario) REFERENCES Usuario(IdUsuario)
);

CREATE TABLE Sucursal (
	IdSucursal SERIAL PRIMARY KEY,
	IdDireccion INTEGER,
	NumeroTelefonico VARCHAR(10) NOT NULL,
	Codigo VARCHAR(50) NOT NULL,
	Estado BOOLEAN NOT NULL,
	FOREIGN KEY (IdDireccion) REFERENCES Direccion(IdDireccion)
);

CREATE TABLE SucursalEmpleado (
	IdSucursal INTEGER,
	IdEmpleado INTEGER,
	FechaInicio DATE NOT NULL,
	FOREIGN KEY (IdSucursal) REFERENCES Sucursal(IdSucursal),
	FOREIGN KEY (IdEmpleado) REFERENCES Empleado(IdEmpleado)
);

CREATE TABLE AdministradorSucursal (
	IdSucursal INTEGER,
	IdEmpleado INTEGER,
	Fecha DATE NOT NULL,
	FOREIGN KEY (IdSucursal) REFERENCES Sucursal(IdSucursal),
	FOREIGN KEY (IdEmpleado) REFERENCES Empleado(IdEmpleado)
);

CREATE TABLE Puesto (
	IdPuesto SERIAL PRIMARY KEY,
	SalarioBase INTEGER NOT NULL, 
	Nombre VARCHAR(20) NOT NULL
);

CREATE TABLE PuestoEmpleado (
	IdPuesto INTEGER,
	IdEmpleado INTEGER,
	FechaInicio DATE NOT NULL,
	FOREIGN KEY (IdPuesto) REFERENCES Puesto (IdPuesto),
	FOREIGN KEY (IdEmpleado) REFERENCES Empleado (IdEmpleado)
);

CREATE TABLE Marca (
	IdMarca SERIAL PRIMARY KEY,
	NombreMarca VARCHAR(20) NOT NULL,
	FechaAdicion DATE NOT NULL
);

CREATE TABLE TipoArticulo (
	IdTipoArticulo SERIAL PRIMARY KEY,
	Nombre VARCHAR(20) NOT NULL
);

CREATE TABLE Producto (
	IdProducto SERIAL PRIMARY KEY,
	IdMarca INTEGER,
	IdTipoArticulo INTEGER,
	Nombre VARCHAR(20) NOT NULL,
	Codigo VARCHAR(20) NOT NULL,
	Peso INTEGER NOT NULL,
	TiempoGarantia INTEGER NOT NULL,
	Sexo VARCHAR(1) NOT NULL,
	Medida VARCHAR(3) NOT NULL,
	FechaAdicion DATE NOT NULL,
	FOREIGN KEY (IdMarca) REFERENCES Marca(IdMarca),
	FOREIGN KEY (IdTipoArticulo) REFERENCES TipoArticulo(IdTipoArticulo)
);

CREATE TABLE DetalleProducto (
	IdProducto INTEGER,
	Detalle VARCHAR(20) NOT NULL,
	Descripcion VARCHAR(20) NOT NULL,
	FOREIGN KEY (IdProducto) REFERENCES Producto(IdProducto)
);

CREATE TABLE Promocion (
	IdPromocion SERIAL PRIMARY KEY,
	IdSucursal INTEGER,
	FechaHoraInicio TIMESTAMP NOT NULL,
	FechaHoraFin TIMESTAMP NOT NULL,
	Porcentaje INTEGER NOT NULL,
	FOREIGN KEY (IdSucursal) REFERENCES Sucursal (IdSucursal)
);

CREATE TABLE PromocionProducto (
	IdPromocion INTEGER,
	IdProducto INTEGER,
	FOREIGN KEY (IdPromocion) REFERENCES Promocion (IdPromocion),
	FOREIGN KEY (IdProducto) REFERENCES Producto (IdProducto)
);

CREATE TABLE Articulo (
	IdArticulo SERIAL PRIMARY KEY,
	IdProducto INTEGER,
	IdSucursal INTEGER,
	Estado BOOLEAN NOT NULL,
	EstadoArticulo VARCHAR(20) NOT NULL,
	Costo INTEGER,
	FOREIGN KEY (IdProducto) REFERENCES Producto(IdProducto),
	FOREIGN KEY (IdSucursal) REFERENCES Sucursal(IdSucursal)
);

CREATE TABLE ActualizacionArticuloPunto(
	IdActualizacionArticuloPunto SERIAL PRIMARY KEY,
	FechaInicio DATE NOT NULL,
	FechaFinal DATE NOT NULL
);

CREATE TABLE ArticuloPunto(
	IdActualizacionArticuloPunto INTEGER,
	IdProducto INTEGER,
	Puntos INTEGER NOT NULL,
	FOREIGN KEY (IdActualizacionArticuloPunto) REFERENCES ActualizacionArticuloPunto(IdActualizacionArticuloPunto),
	FOREIGN KEY (IdProducto) REFERENCES Producto(IdProducto)
);

CREATE TABLE Distribuidor (
	IdDistribuidor SERIAL PRIMARY KEY,
	Nombre VARCHAR(20) NOT NULL,
	Telefono VARCHAR(10) NOT NULL
);

CREATE TABLE DistribuidorProducto (
	IdDistribuidorProducto SERIAL PRIMARY KEY,
	IdDistribuidor INTEGER,
	Costo INTEGER NOT NULL,
	IdProducto INTEGER,
	FOREIGN KEY (IdDistribuidor) REFERENCES Distribuidor(IdDistribuidor),
	FOREIGN KEY (IdProducto) REFERENCES Producto(IdProducto)
);


CREATE TABLE DistribuidorArticulo (
	IdDistribuidorProducto INTEGER,
	IdArticulo INTEGER,
	Fecha DATE NOT NULL,
	FOREIGN KEY (IdDistribuidorProducto) REFERENCES DistribuidorProducto(IdDistribuidorProducto),
	FOREIGN KEY (IdArticulo) REFERENCES Articulo(IdArticulo)
);

CREATE TABLE Devolucion (
	IdDevolucion SERIAL PRIMARY KEY,
	IdDistribuidor INTEGER,
	Fecha DATE NOT NULL,
	FOREIGN KEY (IdDistribuidor) REFERENCES Distribuidor(IdDistribuidor)
);

CREATE TABLE DevolucionArticulo (
	IdDevolucion INTEGER,
	IdArticulo INTEGER,
	FOREIGN KEY (IdDevolucion) REFERENCES Devolucion(IdDevolucion),
	FOREIGN KEY (IdArticulo) REFERENCES Articulo(IdArticulo)
);

CREATE TABLE ReporteCaja (
	IdReporteCaja SERIAL PRIMARY KEY,
	IdSucursal INTEGER,
	FechaReporte TIMESTAMP NOT NULL,
	FOREIGN KEY (IdSucursal) REFERENCES Sucursal(IdSucursal)
);

CREATE TABLE ReporteVenta (
	IdReporteCaja INTEGER,
	IdArticulo INTEGER,
	NumeroVenta INTEGER NOT NULL,
	FOREIGN KEY (IdReporteCaja) REFERENCES ReporteCaja(IdReporteCaja),
	FOREIGN KEY (IdArticulo) REFERENCES Articulo(IdArticulo)
);

CREATE TABLE ReporteDevolucion (
	IdReporteCaja INTEGER,
	IdArticulo INTEGER,
	FOREIGN KEY (IdReporteCaja) REFERENCES ReporteCaja(IdReporteCaja),
	FOREIGN KEY (IdArticulo) REFERENCES Articulo(IdArticulo)
);

CREATE TABLE Transporte (
	IdTransporte SERIAL PRIMARY KEY,
	Nombre VARCHAR(20) NOT NULL,
	Telefono VARCHAR(10) NOT NULL
);

CREATE TABLE Envio (
	IdEnvio SERIAL PRIMARY KEY,
	IdSucursal INTEGER,
	FechaHoraLlegada TIMESTAMP NOT NULL,
	FechaHoraSalida TIMESTAMP NOT NULL,
	FOREIGN KEY (IdSucursal) REFERENCES Sucursal(IdSucursal)
);

CREATE TABLE EnvioTransporte (
	IdEnvio INTEGER,
	IdTransporte INTEGER,
	FOREIGN KEY (IdEnvio) REFERENCES Envio(IdEnvio),
	FOREIGN KEY (IdTransporte) REFERENCES Transporte(IdTransporte)
);

CREATE TABLE EnvioArticulo (
	IdEnvio INTEGER,
	IdArticulo INTEGER,
	FOREIGN KEY (IdEnvio) REFERENCES Envio(IdEnvio),
	FOREIGN KEY (IdArticulo) REFERENCES Articulo(IdArticulo)
);