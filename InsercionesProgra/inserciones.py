import psycopg2
import random
import hashlib
import json

conn = psycopg2.connect(dbname='postgresql', \
                        user='postgres', \
                        password='estebandcg1999', \
                        host='localhost', \
                        port = "5432")
cur = conn.cursor()

lugares = {}
direcciones = ['de la Iglesia', 'del Centro', 'del Super',
               'del Parque', 'de la Escuela']


def calculo_puntos(p):
    return p // 10000


def cargar_lugares():
    global lugares
    file = open("C:/Users/este0/Desktop/Esteban/TEC/2019 - \
II Semestre/Bases de Datos/Ubicaciones/Provincias.txt")
    f_provincias = [line.strip() for line in file]
    file.close()
    for i in f_provincias:
        lugares[i] = {}

    for k in f_provincias:
        provincia = k
        file = open("C:/Users/este0/Desktop/Esteban/TEC/2019 - \
II Semestre/Bases de Datos/Ubicaciones/Cantones" + provincia + ".txt")
        f_cantones = [line.strip() for line in file]
        file.close()
        new_dict = {}
        for i in f_cantones:
            new_dict[i] = []
        lugares[provincia] = new_dict.copy()

        for j in f_cantones:
            canton = j
            file = open("C:/Users/este0/Desktop/Esteban/TEC/2019 - \
II Semestre/Bases de Datos/Ubicaciones/Distritos/" + provincia + "/Distritos"+\
                        canton + ".txt")
            f_distritos = [line.strip() for line in file]
            file.close()
            new_list = []
            for i in f_distritos:
                new_list.append(i)
            lugares[provincia][canton] = new_list.copy()



def search_random():
    file = open("C:/Users/este0/Desktop/Esteban/TEC/2019 - \
II Semestre/Bases de Datos/Ubicaciones/Provincias.txt")
    provincia = random.choice([line.strip() for line in file])
    file.close()

    file = open("C:/Users/este0/Desktop/Esteban/TEC/2019 - \
II Semestre/Bases de Datos/Ubicaciones/Cantones" + provincia + ".txt")
    canton = random.choice([line.strip() for line in file])
    file.close()

    file = open("C:/Users/este0/Desktop/Esteban/TEC/2019 - \
II Semestre/Bases de Datos/Ubicaciones/Distritos/" + provincia + "/Distritos"+\
                canton + ".txt")
    distrito = random.choice([line.strip() for line in file])
    file.close()

    distancia = random.randint(1, 50) * 10
    direccion = str(distancia) + 'm ' + random.choice(direcciones)
    
    return provincia, canton, distrito, direccion


def insertar_pais(nombre):
    cur.execute("""INSERT INTO Pais (Nombre) VALUES (%s);""",
                (nombre,))
    conn.commit()



def insertar_provincia(idpais, nombre):
    cur.execute("""INSERT INTO Provincia (IdPais, Nombre) VALUES (%s, %s);""",
                (idpais, nombre))
    conn.commit()



def insertar_canton(idprovincia, nombre):
    cur.execute("""INSERT INTO Canton (IdProvincia, Nombre) VALUES (%s, %s);""",
                (idprovincia, nombre))
    conn.commit()



def insertar_ciudad(idcanton, nombre):
    cur.execute("""INSERT INTO Ciudad (IdCanton, Nombre) VALUES (%s, %s);""",
                (idcanton, nombre))
    conn.commit()



def insertar_direccion(idciudad, nombre):
    cur.execute("""INSERT INTO Direccion (IdCiudad, Nombre) VALUES (%s, %s);""",
                (idciudad, nombre))
    conn.commit()


def insertar_lugar(direccion, ciudad, canton, provincia, pais):
    cur.execute("""SELECT EXISTS(SELECT 1 FROM Pais WHERE Nombre = %s);""",
                (pais,))
    result_pais = cur.fetchall()[0][0]
    if not result_pais:
        insertar_pais(pais)
    cur.execute("""SELECT IdPais FROM Pais WHERE Nombre = %s;""",
                (pais,))
    id_pais = cur.fetchall()[0][0]


    cur.execute("""SELECT EXISTS( SELECT 1 \
FROM Provincia AS Pr \
INNER JOIN Pais AS Pa ON Pa.IdPais = Pr.IdPais \
WHERE Pr.Nombre = %s AND Pa.Nombre = %s);""",
                (provincia, pais))
    result_provincia = cur.fetchall()[0][0]
    if not result_provincia:
        insertar_provincia(id_pais, provincia)
    cur.execute("""SELECT Pr.IdProvincia \
FROM Provincia AS Pr \
INNER JOIN Pais AS Pa ON Pa.IdPais = Pr.IdPais \
WHERE Pr.Nombre = %s AND Pa.Nombre = %s;""",
                (provincia, pais))
    id_provincia = cur.fetchall()[0][0]


    cur.execute("""SELECT EXISTS( SELECT 1\
FROM Canton AS Ca \
INNER JOIN Provincia AS Pr ON Pr.IdProvincia = Ca.IdProvincia \
INNER JOIN Pais AS Pa ON Pa.IdPais = Pr.IdPais \
WHERE Ca.Nombre = %s AND Pr.Nombre = %s AND Pa.Nombre = %s);""",
                (canton, provincia, pais))
    result_canton = cur.fetchall()[0][0]
    if not result_canton:
        insertar_canton(id_provincia, canton)
    cur.execute("""SELECT Ca.IdCanton \
FROM Canton AS Ca \
INNER JOIN Provincia AS Pr ON Pr.IdProvincia = Ca.IdProvincia \
INNER JOIN Pais AS Pa ON Pa.IdPais = Pr.IdPais \
WHERE Ca.Nombre = %s AND Pr.Nombre = %s AND Pa.Nombre = %s;""",
                (canton, provincia, pais))
    id_canton = cur.fetchall()[0][0]


    cur.execute("""SELECT EXISTS( SELECT 1 \
FROM Ciudad AS Ci \
INNER JOIN Canton AS Ca ON Ca.IdCanton = Ci.IdCanton \
INNER JOIN Provincia AS Pr ON Pr.IdProvincia = Ca.IdProvincia \
INNER JOIN Pais AS Pa ON Pa.IdPais = Pr.IdPais \
WHERE Ci.Nombre = %s AND Ca.Nombre = %s \
AND Pr.Nombre = %s AND Pa.Nombre = %s);""",
                (ciudad, canton, provincia, pais))
    result_ciudad = cur.fetchall()[0][0]
    if not result_ciudad:
        insertar_ciudad(id_canton, ciudad)
    cur.execute("""SELECT Ci.IdCiudad \
FROM Ciudad AS Ci \
INNER JOIN Canton AS Ca ON Ca.IdCanton = Ci.IdCanton \
INNER JOIN Provincia AS Pr ON Pr.IdProvincia = Ca.IdProvincia \
INNER JOIN Pais AS Pa ON Pa.IdPais = Pr.IdPais \
WHERE Ci.Nombre = %s AND Ca.Nombre = %s \
AND Pr.Nombre = %s AND Pa.Nombre = %s;""",
                (ciudad, canton, provincia, pais))
    id_ciudad = cur.fetchall()[0][0]


    cur.execute("""SELECT EXISTS( SELECT 1 \
FROM Direccion AS D \
INNER JOIN Ciudad AS Ci ON Ci.IdCiudad = D.IdCiudad \
INNER JOIN Canton AS Ca ON Ca.IdCanton = Ci.IdCanton \
INNER JOIN Provincia AS Pr ON Pr.IdProvincia = Ca.IdProvincia \
INNER JOIN Pais AS Pa ON Pa.IdPais = Pr.IdPais \
WHERE D.Nombre = %s AND Ci.Nombre = %s AND Ca.Nombre = %s \
AND Pr.Nombre = %s AND Pa.Nombre = %s);""",
                (direccion, ciudad, canton, provincia, pais))
    result_direccion = cur.fetchall()[0][0]
    if not result_direccion:
        insertar_direccion(id_ciudad, direccion)



def insertar_sucursales():
    main_num = '2556507'
    for i in range(1, 4):
        num = main_num + str(i)
        code = hashlib.md5(num.encode())
        code = code.hexdigest()
        code = code[0:3] + '-' + code[4:7] + '-' + code[8:12]
        direction = search_random()
        insertar_lugar(direction[3], direction[2], direction[1],
                       direction[0], 'Costa Rica')
        cur.execute("""INSERT INTO Sucursal \
(IdDireccion, NumeroTelefonico, Codigo, Estado) VALUES (%s, %s, %s, %s);""",
                    (i, num, code, 'true'))
        conn.commit()


def insertar_usuarios():
    
    file = open("C:/Users/este0/Desktop/Esteban/TEC/2019 - II Semestre/\
Bases de Datos/InsercionesProgra/nombres1h.json")
    names_json = json.loads(file.read())
    names_list = [names_json[i]['Names'] for i in range(0,75)]
    file.close()

    file = open("C:/Users/este0/Desktop/Esteban/TEC/2019 - II Semestre/\
Bases de Datos/InsercionesProgra/apellidosP1h.json")
    surnamesP_json = json.loads(file.read())
    surnamesP_list = [surnamesP_json[i]['Names'] for i in range(0,75)]
    file.close()

    file = open("C:/Users/este0/Desktop/Esteban/TEC/2019 - II Semestre/\
Bases de Datos/InsercionesProgra/apellidosM1h.json")
    surnamesM_json = json.loads(file.read())
    surnamesM_list = [surnamesM_json[i]['Names'] for i in range(0,75)]
    file.close()

    file = open("C:/Users/este0/Desktop/Esteban/TEC/2019 - II Semestre/\
Bases de Datos/InsercionesProgra/nombres1m.json")
    names_json = json.loads(file.read())
    names_list_m = [names_json[i]['Names'] for i in range(0,75)]
    file.close()

    file = open("C:/Users/este0/Desktop/Esteban/TEC/2019 - II Semestre/\
Bases de Datos/InsercionesProgra/apellidosP1m.json")
    surnamesP_json = json.loads(file.read())
    surnamesP_list_m = [surnamesP_json[i]['Names'] for i in range(0,75)]
    file.close()

    file = open("C:/Users/este0/Desktop/Esteban/TEC/2019 - II Semestre/\
Bases de Datos/InsercionesProgra/apellidosM1m.json")
    surnamesM_json = json.loads(file.read())
    surnamesM_list_m = [surnamesM_json[i]['Names'] for i in range(0,75)]
    file.close()

    for i in range(0, 75):
        num = random.randint(10000000, 9999999999)
        day = random.randint(1, 30)
        month = random.randint(1, 12)
        if (month == 2 and day > 28):
            day = 28
        year = 2019 - 18 - random.randint(0, 52)
        birth = str(day) + '-' + str(month) + '-' + str(year)
        code = hashlib.md5((names_list[i] + surnamesP_list[i] + surnamesM_list[i]
                            + birth).encode()).hexdigest()[0:20]
        direction = search_random()
        insertar_lugar(direction[3], direction[2], direction[1],
                       direction[0], 'Costa Rica')

        cur.execute("""SELECT Dir.IdDireccion
FROM Direccion AS Dir \
INNER JOIN Ciudad AS Ci ON Ci.IdCiudad = Dir.IdCiudad \
INNER JOIN Canton AS Ca ON Ca.IdCanton = Ci.IdCanton \
INNER JOIN Provincia AS Pr ON Pr.IdProvincia = Ca.IdProvincia \
INNER JOIN Pais AS Pa ON Pa.IdPais = Pr.IdPais \
WHERE Dir.Nombre = %s AND Ci.Nombre = %s AND Ca.Nombre = %s \
AND Pr.Nombre = %s AND Pa.Nombre = %s""",
        (direction[3], direction[2], direction[1], direction[0], 'Costa Rica'))
        idD = cur.fetchall()[0][0]
        
        cur.execute("""INSERT INTO Usuario 
(IdDireccion, Identificacion, Nombre, ApellidoPat, ApellidoMat, \
FechaNacimiento, NumeroTelefonico) VALUES
(%s, %s, %s, %s, %s, %s, %s)""",
        (idD, code, names_list[i], surnamesP_list[i], surnamesM_list[i], birth,
         num))
        conn.commit()

    for i in range(0, 75):
        num = random.randint(10000000, 9999999999)
        day = random.randint(1, 30)
        month = random.randint(1, 12)
        if (month == 2 and day > 28):
            day = 28
        year = 2019 - 18 - random.randint(0, 52)
        birth = str(day) + '-' + str(month) + '-' + str(year)
        code = hashlib.md5((names_list_m[i] + surnamesP_list_m[i] + surnamesM_list_m[i]
                            + birth).encode()).hexdigest()[0:20]
        direction = search_random()
        insertar_lugar(direction[3], direction[2], direction[1],
                       direction[0], 'Costa Rica')

        cur.execute("""SELECT Dir.IdDireccion
FROM Direccion AS Dir \
INNER JOIN Ciudad AS Ci ON Ci.IdCiudad = Dir.IdCiudad \
INNER JOIN Canton AS Ca ON Ca.IdCanton = Ci.IdCanton \
INNER JOIN Provincia AS Pr ON Pr.IdProvincia = Ca.IdProvincia \
INNER JOIN Pais AS Pa ON Pa.IdPais = Pr.IdPais \
WHERE Dir.Nombre = %s AND Ci.Nombre = %s AND Ca.Nombre = %s \
AND Pr.Nombre = %s AND Pa.Nombre = %s""",
        (direction[3], direction[2], direction[1], direction[0], 'Costa Rica'))
        idD = cur.fetchall()[0][0]
        
        cur.execute("""INSERT INTO Usuario 
(IdDireccion, Identificacion, Nombre, ApellidoPat, ApellidoMat, \
FechaNacimiento, NumeroTelefonico) VALUES
(%s, %s, %s, %s, %s, %s, %s)""",
        (idD, code, names_list_m[i], surnamesP_list_m[i], surnamesM_list_m[i], birth,
         num))
        conn.commit()

    
def insertar_empleados():
    for i in range(1, 151):
        bank_account = random.randint(10000000000000000000,
                                      99999999999999999999)
        cur.execute("""INSERT INTO Empleado \
(IdUsuario, FechaIngreso, CuentaBancaria, Estado) VALUES \
(%s, %s, %s, %s)""",
        (i, '27-10-2019', str(bank_account), 'true'))
    conn.commit()


def insertar_puestos():
    cur.execute("""INSERT INTO Puesto \
(SalarioBase, Nombre) VALUES (%s, %s), (%s, %s);""",
    (100000, 'Cajero', 50000, 'Vendedor'))
    conn.commit()


def insertar_puesto_empleados():
    for i in range(1, 151):
        num = random.random()
        if (num < 0.2):
            num = 1
        else:
            num = 2
        cur.execute("""INSERT INTO PuestoEmpleado \
(IdPuesto, IdEmpleado, FechaInicio) VALUES (%s, %s, %s);""",
    (num, i, '27-10-2019'))
    conn.commit()


def insertar_sucursal_empleados():
    cur.execute("""SELECT Em.IdEmpleado \
FROM Empleado AS Em
INNER JOIN PuestoEmpleado AS Pu ON Pu.IdEmpleado = Em.IdEmpleado
WHERE Pu.IdPuesto = 1;""")
    cajeros = cur.fetchall()

    cur.execute("""SELECT Em.IdEmpleado \
FROM Empleado AS Em
INNER JOIN PuestoEmpleado AS Pu ON Pu.IdEmpleado = Em.IdEmpleado
WHERE Pu.IdPuesto = 2;""")
    vendedores = cur.fetchall()
    
    cur.execute("""SELECT IdSucursal \
FROM Sucursal;""")
    sucursales = cur.fetchall()

    cantidad_caj = len(cajeros) // 3
    cantidad_ven = len(vendedores) // 3

    i = 0
    j = 0
    while (i < 3):
        if (i < 2):
            for _ in range(0, cantidad_caj):
                        cur.execute("""INSERT INTO SucursalEmpleado \
(IdSucursal, IdEmpleado, FechaInicio) VALUES (%s, %s, %s);""",
                                    (sucursales[i][0], cajeros[j][0], '27-10-2019'))
                        j = j + 1
        else:
            for _ in range(cantidad_caj * 2, len(cajeros)):
                        cur.execute("""INSERT INTO SucursalEmpleado \
(IdSucursal, IdEmpleado, FechaInicio) VALUES (%s, %s, %s);""",
                                    (sucursales[i][0], cajeros[j][0], '27-10-2019'))
                        j = j + 1
        i = i + 1

    i = 0
    j = 0
    while (i < 3):
        if (i < 2):
            for _ in range(0, cantidad_ven):
                        cur.execute("""INSERT INTO SucursalEmpleado \
(IdSucursal, IdEmpleado, FechaInicio) VALUES (%s, %s, %s);""",
                                    (sucursales[i][0], vendedores[j][0], '27-10-2019'))
                        j = j + 1
        else:
            for _ in range(cantidad_ven * 2, len(vendedores)):
                        cur.execute("""INSERT INTO SucursalEmpleado \
(IdSucursal, IdEmpleado, FechaInicio) VALUES (%s, %s, %s);""",
                                    (sucursales[i][0], vendedores[j][0], '27-10-2019'))
                        j = j + 1
        i = i + 1
        
    conn.commit()
                

def insertar_administrador_sucursal():
    cur.execute("""SELECT Em.IdEmpleado \
FROM Empleado AS Em
INNER JOIN SucursalEmpleado AS Su ON Su.IdEmpleado = Em.IdEmpleado
WHERE Su.IdSucursal = 1;""")
    empleados1 = cur.fetchall()
    
    cur.execute("""SELECT Em.IdEmpleado \
FROM Empleado AS Em
INNER JOIN SucursalEmpleado AS Su ON Su.IdEmpleado = Em.IdEmpleado
WHERE Su.IdSucursal = 2;""")
    empleados2 = cur.fetchall()
    
    cur.execute("""SELECT Em.IdEmpleado \
FROM Empleado AS Em
INNER JOIN SucursalEmpleado AS Su ON Su.IdEmpleado = Em.IdEmpleado
WHERE Su.IdSucursal = 3;""")
    empleados3 = cur.fetchall()

    empleado1 = empleados1[random.randint(0, len(empleados1) - 1)][0]
    empleado2 = empleados2[random.randint(0, len(empleados2) - 1)][0]
    empleado3 = empleados3[random.randint(0, len(empleados3) - 1)][0]

    cur.execute("""INSERT INTO AdministradorSucursal \
    (IdSucursal, IdEmpleado, Fecha) VALUES \
    (%s, %s, %s), \
    (%s, %s, %s), \
    (%s, %s, %s);""",
                (1, empleado1, '27-10-2019',
                 2, empleado2, '27-10-2019',
                 3, empleado3, '27-10-2019'))

    conn.commit()
    

def insertar_distribuidoras():
    cur.execute("""INSERT INTO Distribuidor \
(Nombre, Telefono) VALUES \
(%s, %s), \
(%s, %s), \
(%s, %s);""",
                ('Zara', random.randint(10000000, 9999999999),
                 'Sandro', random.randint(10000000, 9999999999),
                 'Cortefiel', random.randint(10000000, 9999999999)))
    conn.commit()


def insertar_tipos():
    cur.execute("""INSERT INTO TipoArticulo \
(Nombre) VALUES \
(%s), (%s), (%s), \
(%s), (%s), (%s), \
(%s), (%s), (%s);""",
                ('Superior', 'Inferior', 'Interior',
                 'Calzado', 'Bisuteria', 'Accesorio',
                 'Skate', 'Cabeza', 'Otro'))
    conn.commit()
    

def insertar_marcas():
    cur.execute("""INSERT INTO Marca \
(NombreMarca, FechaAdicion) VALUES \
(%s, %s), (%s, %s), (%s, %s), \
(%s, %s), (%s, %s), (%s, %s), \
(%s, %s), (%s, %s), (%s, %s), \
(%s, %s), (%s, %s), (%s, %s), \
(%s, %s), (%s, %s), (%s, %s), \
(%s, %s), (%s, %s), (%s, %s), \
(%s, %s);""",
                ('Volcom', '27-10-2019',
                 'Adidas', '27-10-2019',
                 'Lacoste', '27-10-2019',
                 'Spellbound', '27-10-2019',
                 'Rag & Bone', '27-10-2019',
                 "Victoria's Secret", '27-10-2019',
                 'Calvin Klein', '27-10-2019',
                 'Roxy', '27-10-2019',
                 'Lueli', '27-10-2019',
                 'Solo Sophi', '27-10-2019',
                 'Fossil', '27-10-2019',
                 'Seiko', '27-10-2019',
                 'Zero', '27-10-2019',
                 'Plan B', '27-10-2019',
                 'Element', '27-10-2019',
                 'Fox', '27-10-2019',
                 'Bic', '27-10-2019',
                 'Gucci', '27-10-2019',
                 'Dolce & Gabbana', '27-10-2019'))
    conn.commit()


def insertar_productos(marca, tipo, nombre, peso, garantia, sexo, medida, fecha):
    codigo = hashlib.md5((str(marca) + str(tipo) + nombre +
                          str(peso) + str(garantia) + sexo +
                          medida + fecha).encode()).hexdigest()[0:20]
    cur.execute("""INSERT INTO Producto \
(IdMarca, IdTipoArticulo, Nombre, Codigo, Peso, TiempoGarantia, \
Sexo, Medida, FechaAdicion) VALUES \
(%s, %s, %s, %s, %s, %s, %s, %s, %s);""",
                (marca, tipo, nombre, codigo, peso, garantia, sexo, medida, fecha))
    conn.commit()


def insertar_productos_handle():
    insertar_productos(1, 1, 'Sol Manga Corta',
                       200, 30, 'H', 'S', '27-10-2019')
    insertar_productos(1, 1, 'Chaqueta Enemigo',
                       400, 30, 'M', 'M', '27-10-2019')
    insertar_productos(2, 1, 'Camiseta Alphaskin',
                       200, 30, 'M', 'S', '27-10-2019')
    insertar_productos(3, 1, 'Sudadera LIVE',
                       400, 30, 'H', 'L', '27-10-2019')
    insertar_productos(1, 2, 'Jeans Liberator',
                       400, 60, 'M', '24', '27-10-2019')
    insertar_productos(4, 2, 'Jeans 40-153B',
                       400, 60, 'H', '28', '27-10-2019')
    insertar_productos(5, 2, 'Pantalon Simone',
                       400, 60, 'M', '27', '27-10-2019')
    insertar_productos(5, 2, 'Chino Clasico',
                       400, 60, 'H', '34', '27-10-2019')
    insertar_productos(1, 3, 'Bikini Seamless',
                       100, 15, 'M', 'XS', '27-10-2019')
    insertar_productos(6, 3, 'Lenceria Teddy',
                       100, 15, 'M', 'M', '27-10-2019')
    insertar_productos(7, 3, 'Boxer 3-Pack',
                       300, 15, 'H', 'M', '27-10-2019')
    insertar_productos(7, 3, 'Calzoncillos 2-Pack',
                       200, 15, 'H', 'L', '27-10-2019')
    insertar_productos(1, 4, 'Sandalias Rocker 2',
                       200, 15, 'H', '10', '27-10-2019')
    insertar_productos(2, 4, 'Tacos Natural Seco',
                       200, 15, 'H', '10', '27-10-2019')
    insertar_productos(8, 4, 'Botas Whitley',
                       200, 15, 'M', '7', '27-10-2019')
    insertar_productos(8, 4, 'Tenis Bayshore',
                       200, 15, 'M', '6', '27-10-2019')
    insertar_productos(9, 5, 'Collar Cadena',
                       50, 60, 'M', '40', '27-10-2019')
    insertar_productos(10, 5, 'Anillo GALA',
                       50, 60, 'M', 'S', '27-10-2019')
    insertar_productos(11, 5, 'Pulsera Glitz',
                       50, 60, 'M', '22', '27-10-2019')
    insertar_productos(11, 5, 'Pendientes Fossil',
                       50, 60, 'M', '10', '27-10-2019')
    insertar_productos(1, 6, 'Faja Web',
                       50, 15, 'H', '4', '27-10-2019')
    insertar_productos(2, 6, 'Calcetas Piqui',
                       50, 15, 'U', '10', '27-10-2019')
    insertar_productos(12, 6, 'Seiko Prospex',
                       100, 365, 'H', '23', '27-10-2019')
    insertar_productos(12, 6, 'Seiko Astron',
                       100, 365, 'H', '23', '27-10-2019')
    insertar_productos(13, 7, 'Darkness - Summers',
                       800, 120, 'U', '32', '27-10-2019')
    insertar_productos(13, 7, 'Splatter Bold',
                       800, 120, 'U', '32', '27-10-2019')
    insertar_productos(14, 7, 'Team OG Duffy',
                       800, 120, 'U', '31', '27-10-2019')
    insertar_productos(15, 7, 'Calavera Nyjah',
                       800, 120, 'U', '32', '27-10-2019')
    insertar_productos(1, 8, 'Gorra Rose Wood',
                       50, 30, 'M', 'M', '27-10-2019')
    insertar_productos(1, 8, 'Gorra 9Forty',
                       50, 30, 'H', 'M', '27-10-2019')
    insertar_productos(16, 8, 'Gorra Flexfit',
                       50, 30, 'H', 'XL', '27-10-2019')
    insertar_productos(16, 8, 'Gorro Indio',
                       50, 30, 'M', 'OS', '27-10-2019')
    insertar_productos(17, 9, 'Lapicero',
                       6, 1, 'U', 'M', '27-10-2019')
    insertar_productos(18, 9, 'Salveque GG',
                       600, 90, 'U', 'L', '27-10-2019')
    insertar_productos(18, 9, 'Bolso Zumi',
                       500, 90, 'M', 'S', '27-10-2019')
    insertar_productos(19, 9, 'The One',
                       400, 60, 'H', '-', '27-10-2019')


def insertar_detalles(producto, detalles):
    cur.execute("""INSERT INTO DetalleProducto \
(IdProducto, Detalle, Descripcion) VALUES \
(%s, %s, %s), \
(%s, %s, %s), \
(%s, %s, %s), \
(%s, %s, %s);""",
                (producto, detalles[0][0], detalles[0][1],
                 producto, detalles[1][0], detalles[1][1],
                 producto, detalles[2][0], detalles[2][1],
                 producto, detalles[3][0], detalles[3][1]))
    conn.commit()


def insertar_detalles_handle():
    insertar_detalles(1, [['Material', 'Algodon'],
                          ['Material', 'Poliester'],
                          ['Color', 'Crema'],
                          ['Estampado', 'Volcom Sol']])
    insertar_detalles(2, [['Largo', '26 Pulgadas'],
                          ['Material', 'Poliester'],
                          ['Color', 'Verde'],
                          ['Extra', 'Bolsillos']])
    insertar_detalles(3, [['Tecnologia', 'Climachill'],
                          ['Cuello', 'Redondo'],
                          ['Material', 'Nylon'],
                          ['Estampado', 'Rayas']])
    insertar_detalles(4, [['Color', 'Blanco'],
                          ['Cuello', 'Alto'],
                          ['Material', 'Poliester'],
                          ['Estampado', 'Franjas']])
    insertar_detalles(5, [['Color', 'Negro'],
                          ['Entrepierna', '27'],
                          ['Material', 'Algodon'],
                          ['Estilo', 'Clasico']])
    insertar_detalles(6, [['Color', 'Indigo'],
                          ['Aspecto', 'Usado'],
                          ['Entrepierna', '28'],
                          ['Estilo', 'Simple']])
    insertar_detalles(7, [['Color', 'Negro'],
                          ['Estilo', 'Italiano'],
                          ['Material', 'Algodon'],
                          ['Diseno', 'Zebra']])
    insertar_detalles(8, [['Color', 'Beige'],
                          ['Corte', 'Japones'],
                          ['Material', 'Algodon'],
                          ['Diseno', 'Simple']])
    insertar_detalles(9, [['Color', 'Zinfandel'],
                          ['Fabricado', 'Italia'],
                          ['Material', 'Nylon'],
                          ['Estilo', 'Separado']])
    insertar_detalles(10, [['Color', 'Negro'],
                          ['Diseno', 'Elegante'],
                          ['Material', 'Poliamida'],
                          ['Estilo', 'Separado']])
    insertar_detalles(11, [['Colores', 'Cromaticos'],
                          ['Contenido', '3 Boxers'],
                          ['Material', 'Microfibra'],
                          ['Extra', 'Control de humedad']])
    insertar_detalles(12, [['Colores', 'Blanco'],
                          ['Contenido', '2 Calzoncillos'],
                          ['Estampado', 'Logo CK en la banda'],
                          ['Diseno', 'Con contorno']])
    insertar_detalles(13, [['Diseno', 'Floral'],
                          ['Suela', 'Doble'],
                          ['Material', 'TPU & EVA'],
                          ['Durabilidad', 'Alta']])
    insertar_detalles(14, [['Color', 'Amarillo'],
                          ['Suela', 'TPU'],
                          ['Parte Superior', 'Doble capa'],
                          ['Tipos', 'Tacos Futbol']])
    insertar_detalles(15, [['Color', 'Negro'],
                          ['Cerrado', 'Cordon'],
                          ['Interior', 'Lana'],
                          ['Suela', 'TPR']])
    insertar_detalles(16, [['Colores', 'Naranja Russett'],
                          ['Cerrado', 'Cordon'],
                          ['Interior', 'Espuma'],
                          ['Suela', 'TPR flexible']])
    insertar_detalles(17, [['Material', 'Plata'],
                          ['Detalle', 'Medalla y Bolas'],
                          ['Extra', 'Grabacion'],
                          ['Permite', 'Banado en oro']])
    insertar_detalles(18, [['Circonita', 'Rosa'],
                          ['Diseno', 'Elegante'],
                          ['Material', 'Plata'],
                          ['Banado', 'Oro']])
    insertar_detalles(19, [['Material', 'Acero y Cristal'],
                          ['Detalles', 'Nacar'],
                          ['Cierre', 'Deslizante'],
                          ['Coleccion', 'Vintage Glitz']])
    insertar_detalles(20, [['Material', 'Acero Inoxidable'],
                          ['Colores', 'Oro y Cuarzo'],
                          ['Forma', 'Hexagonal'],
                          ['Cierre', 'De presion']])
    insertar_detalles(21, [['Material', 'Algodon'],
                          ['Diseno', 'Logo Volcom'],
                          ['Estilo', 'Simple'],
                          ['Colores', 'Varios']])
    insertar_detalles(22, [['Color', 'Blanco'],
                          ['Material', 'Nylon y Poliester'],
                          ['Contenido', 'Par por paquete'],
                          ['Tecnologia', 'Formotion']])
    insertar_detalles(23, [['Color', 'Violeta'],
                          ['Material', 'Oro'],
                          ['Resistencia', 'Agua'],
                          ['Estampado', '30 joyas']])
    insertar_detalles(24, [['Color', 'Negro'],
                          ['Calibracion', 'Senal GPS'],
                          ['Resistencia', 'Agua'],
                          ['Posee', 'Ahorro de Energia']])
    insertar_detalles(25, [['Modelo', 'Pro Model Debut'],
                          ['Disenado', 'Darkness'],
                          ['Elaborado', 'Summers'],
                          ['Diseno', 'Calavera y Rosa']])
    insertar_detalles(26, [['Diseno', 'ZERO'],
                          ['Elaborado', 'Brockman'],
                          ['Colores', 'Varios'],
                          ['Contorno', 'Blanco']])
    insertar_detalles(27, [['Diseno', 'PLAN B'],
                          ['Modelo', 'Pro Deck'],
                          ['Color', 'Blanco'],
                          ['Fondo', 'Negro']])
    insertar_detalles(28, [['Coleccion', 'Nyjah'],
                          ['Colores', 'Negro y Verde'],
                          ['Diseno', 'Halloween'],
                          ['Elaborado', 'Bryan Arii']])
    insertar_detalles(29, [['Material', 'Poliester'],
                          ['Color', 'Negro'],
                          ['Cerrado', 'Por broche'],
                          ['Diseno', 'Rosas']])
    insertar_detalles(30, [['Material', 'Poliester'],
                          ['Color', 'Negro'],
                          ['Cerrado', 'Por broche'],
                          ['Diseno', 'Logo Volcom Dorado']])
    insertar_detalles(31, [['Color', 'Azul Maui'],
                          ['Material', 'Algodon'],
                          ['Detalle', 'Bordado'],
                          ['Diseno', 'Logo Fox Negro']])
    insertar_detalles(32, [['Color', 'Morado'],
                          ['Material', 'Acrilico'],
                          ['Estilo', 'De pom'],
                          ['Clima', 'Frio']])
    insertar_detalles(33, [['Color', 'Negro'],
                          ['Precio', 'Economico'],
                          ['Material', 'Cristal'],
                          ['Tipo', 'De capuchon']])
    insertar_detalles(34, [['Material', 'Lana'],
                          ['Color', 'Rojo y Azul'],
                          ['Tiras', 'Cuero'],
                          ['Elaborado', 'Italia']])
    insertar_detalles(35, [['Material', 'Cuero'],
                          ['Detallado', 'Oro y Plata'],
                          ['Color', 'Verde oscuro'],
                          ['Elaborado', 'Italia']])
    insertar_detalles(36, [['Tipo', 'Colonia'],
                          ['Fragancia', 'Tabaco y especias'],
                          ['Frasco', 'Cristal'],
                          ['Tapon', 'Marron mate']])


def insertar_promocion():
    cur.execute("""INSERT INTO Promocion \
(IdSucursal, FechaHoraInicio, FechaHoraFin, Porcentaje) VALUES \
(%s, %s, %s, %s);""",
                (1, '27-10-2019 00:00:00', '31-10-2019 23:59:59', 50))
    cur.execute("""INSERT INTO PromocionProducto \
(IdPromocion, IdProducto) VALUES (%s, %s);""",
                (1, 34))
    conn.commit()


def insertar_distribuidor_productos():
    costos = [30000, 50000, 20000, 34000, 60000, 60000, 80000, 50000,
              35000, 64000, 15000, 15000, 20000, 60000, 80000, 45000,
              25000, 45000, 65000, 35000, 10000, 10000, 650000, 2500000,
              150000, 35000, 48000, 95000, 15000, 24000, 17500, 20000,
              500, 95000, 250000, 475000]
    for i in range(0, 36):
        for j in range(1, 4):
            costo = costos[i] - random.randint(-costos[i] / 2, costos[i] / 2)
            cur.execute("""INSERT INTO DistribuidorProducto \
(IdDistribuidor, Costo, IdProducto) VALUES (%s, %s, %s);""",
                        (j, costo, i + 1))
    conn.commit()            


def insertar_articulos():
    for i in range(1, 37):
        for _ in range(0, 60):
            cur.execute("""INSERT INTO Articulo \
(IdProducto, Estado, EstadoArticulo) VALUES (%s, %s, %s);""",
                        (i, 'true', 'En bodega'))
    conn.commit()


def insertar_distribuidor_articulos():
    for i in range(1, 37):
        cur.execute("""SELECT DisP.IdDistribuidorProducto
FROM DistribuidorProducto AS DisP
WHERE DisP.IdProducto = %s;""",
                    (i, ))
        dist = cur.fetchall()
        for j in range(0, 60):
            choice = random.choice(dist)[0]
            cur.execute("""INSERT INTO DistribuidorArticulo
(IdDistribuidorProducto, IdArticulo, Fecha) VALUES (%s, %s, %s);""",
                        (choice, (i - 1) * 60 + j + 1, '27-10-2019'))
            conn.commit()
            cur.execute("""UPDATE Articulo
SET Costo = ROUND((
SELECT DP.Costo
From DistribuidorProducto AS DP
INNER JOIN DistribuidorArticulo AS DA \
    ON DA.IdDistribuidorProducto = DP.IdDistribuidorProducto
INNER JOIN Articulo AS A ON A.IdArticulo = DA.IdArticulo
WHERE A.IdArticulo = %s
) * 1.25, 0)
WHERE IdArticulo = %s;""",
                        ((i - 1) * 60 + j + 1, (i - 1) * 60 + j + 1))
            conn.commit()
    

def insertar_lista_puntos():
    cur.execute("""INSERT INTO ActualizacionArticuloPunto
(FechaInicio, FechaFinal) VALUES (%s, %s);""",
                ('27-10-2019', '28-11-2019'))
    cur.execute("""SELECT IdProducto FROM Producto;""")
    productos = cur.fetchall()
    for _ in range(0, 10):
        random.shuffle(productos)
        producto = productos.pop(0)
        cur.execute("""INSERT INTO ArticuloPunto
(IdActualizacionArticuloPunto, IdProducto, Puntos) VALUES (%s, %s, %s);""",
                    (1, producto, random.randint(1, 33)))
    conn.commit()


def insertar_envios():
    cur.execute("""INSERT INTO Envio
(IdSucursal, FechaHoraLlegada, FechaHoraSalida) VALUES
(%s, %s, %s), (%s, %s, %s), (%s, %s, %s);""",
                (1, '27-10-2019 05:00:00', '26-10-2019 23:00:00',
                 2, '27-10-2019 05:00:00', '26-10-2019 23:00:00',
                 3, '27-10-2019 05:00:00', '26-10-2019 23:00:00'))
    cur.execute("""INSERT INTO Transporte
(Nombre, Telefono) VALUES
(%s, %s), (%s, %s), (%s, %s),
(%s, %s), (%s, %s), (%s, %s),
(%s, %s), (%s, %s), (%s, %s);""",
                ('TransporteA1', str(random.randint(10000000, 9999999999)),
                 'TransporteA2', str(random.randint(10000000, 9999999999)),
                 'TransporteA3', str(random.randint(10000000, 9999999999)),
                 'TransporteB1', str(random.randint(10000000, 9999999999)),
                 'TransporteB2', str(random.randint(10000000, 9999999999)),
                 'TransporteB3', str(random.randint(10000000, 9999999999)),
                 'TransporteC1', str(random.randint(10000000, 9999999999)),
                 'TransporteC2', str(random.randint(10000000, 9999999999)),
                 'TransporteC3', str(random.randint(10000000, 9999999999))))
    conn.commit()
    cur.execute("""INSERT INTO EnvioTransporte
(IdEnvio, IdTransporte) VALUES
(%s, %s), (%s, %s), (%s, %s),
(%s, %s), (%s, %s), (%s, %s),
(%s, %s), (%s, %s), (%s, %s);""",
                (1, 1, 1, 2, 1, 3, 2, 4, 2, 5, 2, 6, 3, 7, 3, 8, 3, 9))
    for j in range(1, 37):
        cur.execute("""SELECT IdArticulo
FROM Articulo
WHERE IdProducto = %s
GROUP BY IdArticulo
ORDER BY IdArticulo ASC
LIMIT 15;""", (j, ))
        ids = cur.fetchall()
        for i in range(0, 5):
            for k in range(0, 3):
                cur.execute("""INSERT INTO EnvioArticulo
(IdEnvio, IdArticulo) VALUES (%s, %s);""",
                            (k + 1, ids[i * 3 + k][0]))
                cur.execute("""UPDATE Articulo
SET IdSucursal = %s
WHERE IdArticulo = %s;""",
                            (k + 1, ids[i * 3 + k][0]))
    conn.commit()


def actualizar_estado_articulo():
    cur.execute("""UPDATE Articulo
SET EstadoArticulo = 'En sucursal'
WHERE IdSucursal IS NOT NULL;""")
    conn.commit()


def usuarios_dia_1():
    file = open("C:/Users/este0/Desktop/Esteban/TEC/2019 - II Semestre/\
Bases de Datos/InsercionesProgra/nombres1h.json")
    names_json = json.loads(file.read())
    names_list = [i['Names'] for i in names_json]
    file.close()

    file = open("C:/Users/este0/Desktop/Esteban/TEC/2019 - II Semestre/\
Bases de Datos/InsercionesProgra/apellidosP1h.json")
    surnamesP_json = json.loads(file.read())
    surnamesP_list = [i['Names'] for i in surnamesP_json]
    file.close()

    file = open("C:/Users/este0/Desktop/Esteban/TEC/2019 - II Semestre/\
Bases de Datos/InsercionesProgra/apellidosM1h.json")
    surnamesM_json = json.loads(file.read())
    surnamesM_list = [i['Names'] for i in surnamesM_json]
    file.close()

    file = open("C:/Users/este0/Desktop/Esteban/TEC/2019 - II Semestre/\
Bases de Datos/InsercionesProgra/nombres1m.json")
    names_json = json.loads(file.read())
    names_list_m = [i['Names'] for i in names_json]
    file.close()

    file = open("C:/Users/este0/Desktop/Esteban/TEC/2019 - II Semestre/\
Bases de Datos/InsercionesProgra/apellidosP1m.json")
    surnamesP_json = json.loads(file.read())
    surnamesP_list_m = [i['Names'] for i in surnamesP_json]
    file.close()

    file = open("C:/Users/este0/Desktop/Esteban/TEC/2019 - II Semestre/\
Bases de Datos/InsercionesProgra/apellidosM1m.json")
    surnamesM_json = json.loads(file.read())
    surnamesM_list_m = [i['Names'] for i in surnamesM_json]
    file.close()

    nombres = names_list + names_list_m
    apellidosP = surnamesP_list + surnamesP_list_m
    apellidosM = surnamesM_list + surnamesM_list_m

    for _ in range(0, 108):
        nombre = random.choice(nombres)
        apellido_p = random.choice(apellidosP)
        apellido_m = random.choice(apellidosM)
        num = random.randint(10000000, 9999999999)
        day = random.randint(1, 30)
        month = random.randint(1, 12)
        if (month == 2 and day > 28):
            day = 28
        year = 2019 - 18 - random.randint(0, 52)
        birth = str(day) + '-' + str(month) + '-' + str(year)
        code = hashlib.md5((nombre
                            + apellido_p
                            + apellido_m
                            + birth).encode()).hexdigest()[0:20]
        direction = search_random()
        insertar_lugar(direction[3], direction[2], direction[1],
                       direction[0], 'Costa Rica')

        cur.execute("""SELECT Dir.IdDireccion
FROM Direccion AS Dir \
INNER JOIN Ciudad AS Ci ON Ci.IdCiudad = Dir.IdCiudad \
INNER JOIN Canton AS Ca ON Ca.IdCanton = Ci.IdCanton \
INNER JOIN Provincia AS Pr ON Pr.IdProvincia = Ca.IdProvincia \
INNER JOIN Pais AS Pa ON Pa.IdPais = Pr.IdPais \
WHERE Dir.Nombre = %s AND Ci.Nombre = %s AND Ca.Nombre = %s \
AND Pr.Nombre = %s AND Pa.Nombre = %s""",
        (direction[3], direction[2], direction[1], direction[0], 'Costa Rica'))
        idD = cur.fetchall()[0][0]
        
        cur.execute("""INSERT INTO Usuario 
(IdDireccion, Identificacion, Nombre, ApellidoPat, ApellidoMat, \
FechaNacimiento, NumeroTelefonico) VALUES
(%s, %s, %s, %s, %s, %s, %s)""",
        (idD, code, nombre, apellido_p, apellido_m, birth,
         num))
        conn.commit()


def clientes_dia_1():
    for i in range(151, 259):
        cur.execute("""INSERT INTO Cliente 
(IdUsuario, Puntos) VALUES (%s, %s);""",
                    (i, 0))
    conn.commit()


def reportes_dia_1():
    cur.execute("""INSERT INTO ReporteCaja 
(IdSucursal, FechaReporte) VALUES (%s, %s), (%s, %s), (%s, %s);""",
                (1, '27-10-2019 20:45:05',
                 2, '27-10-2019 22:32:26',
                 3, '27-10-2019 21:12:33'))
    conn.commit()
    a_vender = []
    clientes = list(range(1, 109))
    random.shuffle(clientes)
    for j in range(2, 5):
        vender = []
        for i in range(1, 37):
            cur.execute("""SELECT IdArticulo
From Articulo
WHERE IdProducto = %s AND IdSucursal = %s;""",
                        (i, j - 1))
            result = cur.fetchall()
            random.shuffle(result)
            vender = vender + [i[0] for i in result[0:3]]
        a_vender.append(vender)
    numero_venta = 1
    for i in range(0, 3):
        for _ in range(0, 36):
            venta = []
            for _ in range(0, 3):
                venta.append(a_vender[i].pop(random.randint(0, len(a_vender[i])-1)))
            costo = 0
            cliente = clientes.pop(0)
            for j in venta:
                cur.execute("""SELECT Costo
From Articulo
WHERE IdArticulo = %s;""",
                            (j, ))
                costo = costo + cur.fetchall()[0][0]
                cur.execute("""INSERT INTO ReporteVenta
(IdReporteCaja, IdArticulo, NumeroVenta, IdCliente) VALUES (%s, %s, %s, %s);""",
                            (i + 1, j, numero_venta, cliente))
                cur.execute("""UPDATE Articulo
SET EstadoArticulo = 'Periodo garantia'
WHERE IdArticulo = %s;""",
                            (j, ))
            cur.execute("""UPDATE Cliente
SET Puntos = %s
WHERE IdCliente = %s;""",
                        (calculo_puntos(costo), cliente))
            numero_venta = numero_venta + 1
            
    conn.commit()


def envios_dia_1():
    cur.execute("""INSERT INTO Envio
(IdSucursal, FechaHoraLlegada, FechaHoraSalida) VALUES
(%s, %s, %s), (%s, %s, %s), (%s, %s, %s);""",
                (1, '28-10-2019 05:00:00', '28-10-2019 00:00:00',
                 2, '28-10-2019 05:00:00', '28-10-2019 00:00:00',
                 3, '28-10-2019 05:00:00', '28-10-2019 00:00:00'))
    cur.execute("""INSERT INTO Transporte
(Nombre, Telefono) VALUES
(%s, %s), (%s, %s), (%s, %s),
(%s, %s), (%s, %s), (%s, %s);""",
                ('TransporteD1', str(random.randint(10000000, 9999999999)),
                 'TransporteD2', str(random.randint(10000000, 9999999999)),
                 'TransporteE1', str(random.randint(10000000, 9999999999)),
                 'TransporteE2', str(random.randint(10000000, 9999999999)),
                 'TransporteF1', str(random.randint(10000000, 9999999999)),
                 'TransporteF2', str(random.randint(10000000, 9999999999))))
    conn.commit()
    cur.execute("""INSERT INTO EnvioTransporte
(IdEnvio, IdTransporte) VALUES
(%s, %s), (%s, %s), (%s, %s),
(%s, %s), (%s, %s), (%s, %s);""",
                (4, 10, 4, 11, 5, 12, 5, 13, 6, 14, 6, 15))
    for i in range(1, 37):
        cur.execute("""SELECT IdArticulo
FROM Articulo
WHERE IdProducto = %s AND IdSucursal IS NULL
GROUP BY IdArticulo
ORDER BY IdArticulo ASC;""",
                    (i, ))
        ids = cur.fetchall()
        random.shuffle(ids)
        ids = [j[0] for j in ids[0:12]]
        for j in range(4, 7):
            for k in range(0, 4):
                cur.execute("""INSERT INTO EnvioArticulo
(IdEnvio, IdArticulo) VALUES (%s, %s);""",
                            (j, ids[(j - 4) * 4 + k]))
                cur.execute("""UPDATE Articulo
SET IdSucursal = %s, EstadoArticulo = 'En sucursal'
WHERE IdArticulo = %s;""",
                            (j - 3, ids[(j - 4) * 4 + k]))
    conn.commit()


def usuarios_dia_2():
    file = open("C:/Users/este0/Desktop/Esteban/TEC/2019 - II Semestre/\
Bases de Datos/InsercionesProgra/nombres1h.json")
    names_json = json.loads(file.read())
    names_list = [i['Names'] for i in names_json]
    file.close()

    file = open("C:/Users/este0/Desktop/Esteban/TEC/2019 - II Semestre/\
Bases de Datos/InsercionesProgra/apellidosP1h.json")
    surnamesP_json = json.loads(file.read())
    surnamesP_list = [i['Names'] for i in surnamesP_json]
    file.close()

    file = open("C:/Users/este0/Desktop/Esteban/TEC/2019 - II Semestre/\
Bases de Datos/InsercionesProgra/apellidosM1h.json")
    surnamesM_json = json.loads(file.read())
    surnamesM_list = [i['Names'] for i in surnamesM_json]
    file.close()

    file = open("C:/Users/este0/Desktop/Esteban/TEC/2019 - II Semestre/\
Bases de Datos/InsercionesProgra/nombres1m.json")
    names_json = json.loads(file.read())
    names_list_m = [i['Names'] for i in names_json]
    file.close()

    file = open("C:/Users/este0/Desktop/Esteban/TEC/2019 - II Semestre/\
Bases de Datos/InsercionesProgra/apellidosP1m.json")
    surnamesP_json = json.loads(file.read())
    surnamesP_list_m = [i['Names'] for i in surnamesP_json]
    file.close()

    file = open("C:/Users/este0/Desktop/Esteban/TEC/2019 - II Semestre/\
Bases de Datos/InsercionesProgra/apellidosM1m.json")
    surnamesM_json = json.loads(file.read())
    surnamesM_list_m = [i['Names'] for i in surnamesM_json]
    file.close()

    nombres = names_list + names_list_m
    apellidosP = surnamesP_list + surnamesP_list_m
    apellidosM = surnamesM_list + surnamesM_list_m

    for _ in range(0, 54):
        nombre = random.choice(nombres)
        apellido_p = random.choice(apellidosP)
        apellido_m = random.choice(apellidosM)
        num = random.randint(10000000, 9999999999)
        day = random.randint(1, 30)
        month = random.randint(1, 12)
        if (month == 2 and day > 28):
            day = 28
        year = 2019 - 18 - random.randint(0, 52)
        birth = str(day) + '-' + str(month) + '-' + str(year)
        code = hashlib.md5((nombre
                            + apellido_p
                            + apellido_m
                            + birth).encode()).hexdigest()[0:20]
        direction = search_random()
        insertar_lugar(direction[3], direction[2], direction[1],
                       direction[0], 'Costa Rica')

        cur.execute("""SELECT Dir.IdDireccion
FROM Direccion AS Dir \
INNER JOIN Ciudad AS Ci ON Ci.IdCiudad = Dir.IdCiudad \
INNER JOIN Canton AS Ca ON Ca.IdCanton = Ci.IdCanton \
INNER JOIN Provincia AS Pr ON Pr.IdProvincia = Ca.IdProvincia \
INNER JOIN Pais AS Pa ON Pa.IdPais = Pr.IdPais \
WHERE Dir.Nombre = %s AND Ci.Nombre = %s AND Ca.Nombre = %s \
AND Pr.Nombre = %s AND Pa.Nombre = %s""",
        (direction[3], direction[2], direction[1], direction[0], 'Costa Rica'))
        idD = cur.fetchall()[0][0]
        
        cur.execute("""INSERT INTO Usuario 
(IdDireccion, Identificacion, Nombre, ApellidoPat, ApellidoMat, \
FechaNacimiento, NumeroTelefonico) VALUES
(%s, %s, %s, %s, %s, %s, %s)""",
        (idD, code, nombre, apellido_p, apellido_m, birth,
         num))
        conn.commit()


def clientes_dia_2():
    for i in range(259, 313):
        cur.execute("""INSERT INTO Cliente 
(IdUsuario, Puntos) VALUES (%s, %s);""",
                    (i, 0))
    conn.commit()


def reportes_dia_2():
    cur.execute("""INSERT INTO ReporteCaja 
(IdSucursal, FechaReporte) VALUES (%s, %s), (%s, %s), (%s, %s);""",
                (1, '28-10-2019 21:40:30',
                 2, '28-10-2019 22:47:12',
                 3, '28-10-2019 20:14:57'))
    conn.commit()
    a_vender = []
    clientes = list(range(109, 163))
    random.shuffle(clientes)
    for j in range(1, 4):
        vender = []
        for i in range(1, 37):
            cur.execute("""SELECT IdArticulo
From Articulo
WHERE IdProducto = %s AND IdSucursal = %s AND EstadoArticulo = 'En sucursal';""",
                        (i, j))
            result = cur.fetchall()
            random.shuffle(result)
            vender = vender + [i[0] for i in result[0:3]]
        a_vender.append(vender)
    numero_venta = 109
    for i in range(0, 3):
        for _ in range(0, 18):
            venta = []
            for _ in range(0, 6):
                venta.append(a_vender[i].pop(random.randint(0, len(a_vender[i])-1)))
            costo = 0
            cliente = clientes.pop(0)
            for j in venta:
                cur.execute("""SELECT Costo
From Articulo
WHERE IdArticulo = %s;""",
                            (j, ))
                costo = costo + cur.fetchall()[0][0]
                cur.execute("""INSERT INTO ReporteVenta
(IdReporteCaja, IdArticulo, NumeroVenta, IdCliente) VALUES (%s, %s, %s, %s);""",
                            (i + 4, j, numero_venta, cliente))
                cur.execute("""UPDATE Articulo
SET EstadoArticulo = 'Periodo garantia'
WHERE IdArticulo = %s;""",
                            (j, ))
            cur.execute("""UPDATE Cliente
SET Puntos = %s
WHERE IdCliente = %s;""",
                        (calculo_puntos(costo), cliente))
            numero_venta = numero_venta + 1
    conn.commit()
    

def envios_dia_2():
    cur.execute("""INSERT INTO Envio
(IdSucursal, FechaHoraLlegada, FechaHoraSalida) VALUES
(%s, %s, %s), (%s, %s, %s), (%s, %s, %s);""",
                (1, '29-10-2019 05:00:00', '29-10-2019 00:00:00',
                 2, '29-10-2019 05:00:00', '29-10-2019 00:00:00',
                 3, '29-10-2019 05:00:00', '29-10-2019 00:00:00'))
    cur.execute("""INSERT INTO Transporte
(Nombre, Telefono) VALUES
(%s, %s), (%s, %s), (%s, %s),
(%s, %s), (%s, %s), (%s, %s);""",
                ('TransporteG1', str(random.randint(10000000, 9999999999)),
                 'TransporteG2', str(random.randint(10000000, 9999999999)),
                 'TransporteH1', str(random.randint(10000000, 9999999999)),
                 'TransporteH2', str(random.randint(10000000, 9999999999)),
                 'TransporteI1', str(random.randint(10000000, 9999999999)),
                 'TransporteI2', str(random.randint(10000000, 9999999999))))
    conn.commit()
    cur.execute("""INSERT INTO EnvioTransporte
(IdEnvio, IdTransporte) VALUES
(%s, %s), (%s, %s), (%s, %s),
(%s, %s), (%s, %s), (%s, %s);""",
                (7, 16, 7, 17, 8, 18, 8, 19, 9, 20, 9, 21))
    for i in range(1, 37):
        cur.execute("""SELECT IdArticulo
FROM Articulo
WHERE IdProducto = %s AND IdSucursal IS NULL
GROUP BY IdArticulo
ORDER BY IdArticulo ASC;""",
                    (i, ))
        ids = cur.fetchall()
        random.shuffle(ids)
        ids = [j[0] for j in ids[0:12]]
        for j in range(0, 3):
            for k in range(0, 4):
                cur.execute("""INSERT INTO EnvioArticulo
(IdEnvio, IdArticulo) VALUES (%s, %s);""",
                            (j + 7, ids[j * 4 + k]))
                cur.execute("""UPDATE Articulo
SET IdSucursal = %s, EstadoArticulo = 'En sucursal'
WHERE IdArticulo = %s;""",
                            (j + 1, ids[j * 4 + k]))
    conn.commit()


def insertar_datos():
    # DIA 0
    insertar_sucursales()
    insertar_usuarios()
    insertar_empleados()
    insertar_puestos()
    insertar_puesto_empleados()
    insertar_sucursal_empleados()
    insertar_administrador_sucursal()
    insertar_distribuidoras()
    insertar_tipos()
    insertar_marcas()
    insertar_productos_handle()
    insertar_detalles_handle()
    insertar_promocion()
    insertar_distribuidor_productos()
    insertar_articulos()
    insertar_distribuidor_articulos()
    insertar_lista_puntos()
    insertar_envios()
    actualizar_estado_articulo()
    # DIA 1
    usuarios_dia_1()
    clientes_dia_1()
    reportes_dia_1()
    envios_dia_1()
    # DIA 2
    usuarios_dia_2()
    clientes_dia_2()
    reportes_dia_2()
    envios_dia_2()

def test():
    cur.execute("""SELECT *
FROM Articulo
GROUP BY 1
ORDER BY 1 ASC
LIMIT 25;""")
    res = cur.fetchall()
    return res
