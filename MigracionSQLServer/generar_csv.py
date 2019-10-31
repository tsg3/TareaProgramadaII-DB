import psycopg2

conn = psycopg2.connect(dbname='postgres', \
                        user='postgres', \
                        password='estebandcg1999', \
                        host='localhost', \
                        port = "5432")
cur = conn.cursor()

tablas = ['ActualizacionArticuloPunto', 'AdministradorSucursal',
          'Articulo', 'ArticuloPunto', 'Canton', 'Ciudad', 'Cliente',
          'DetalleProducto', 'Devolucion', 'DevolucionArticulo', 'Direccion',
          'Distribuidor', 'DistribuidorArticulo', 'DistribuidorProducto',
          'Empleado', 'Envio', 'EnvioArticulo', 'EnvioTransporte', 'Marca',
          'Pais', 'Producto', 'Promocion', 'PromocionProducto', 'Provincia',
          'Puesto', 'PuestoEmpleado', 'ReporteCaja', 'ReporteDevolucion',
          'ReporteVenta', 'Sucursal', 'SucursalEmpleado', 'TipoArticulo',
          'Transporte', 'Usuario']


def generar_csv():
    query = "COPY JOEC TO STDOUT WITH CSV DELIMITER ',';"
    path = 'C:/Users/este0/Desktop/Esteban/TEC/2019 - II Semestre/Bases de Dato\
s/Progra 2/MigracionSQLServer/Datos/JOEC.csv'
    for tabla in tablas:
        copy = query.replace('JOEC', tabla)
        pathfile = path.replace('JOEC', tabla)
        with open(pathfile, 'w') as file:
            cur.copy_expert(copy, file)
    fix()
    

def fix():
    file = open('C:/Users/este0/Desktop/Esteban/TEC/2019 - II Semestre/Bases de Datos/Progra 2/MigracionSQLServer/Datos/Sucursal.csv', 'r+')
    text = [i.replace(',t\n', ',1\n') for i in file]
    file.close()
    file = open('C:/Users/este0/Desktop/Esteban/TEC/2019 - II Semestre/Bases de Datos/Progra 2/MigracionSQLServer/Datos/Sucursal.csv', 'w')
    for i in text:
        file.write(i)

    file = open('C:/Users/este0/Desktop/Esteban/TEC/2019 - II Semestre/Bases de Datos/Progra 2/MigracionSQLServer/Datos/Empleado.csv', 'r+')
    text = [i.replace(',t\n', ',1\n') for i in file]
    file.close()
    file = open('C:/Users/este0/Desktop/Esteban/TEC/2019 - II Semestre/Bases de Datos/Progra 2/MigracionSQLServer/Datos/Empleado.csv', 'w')
    for i in text:
        file.write(i)

    file = open('C:/Users/este0/Desktop/Esteban/TEC/2019 - II Semestre/Bases de Datos/Progra 2/MigracionSQLServer/Datos/Articulo.csv', 'r+')
    text = [i.replace(',t,', ',1,') for i in file]
    file.close()
    file = open('C:/Users/este0/Desktop/Esteban/TEC/2019 - II Semestre/Bases de Datos/Progra 2/MigracionSQLServer/Datos/Articulo.csv', 'w')
    for i in text:
        file.write(i)
