-- ¿Qué es DDL?
-- Data Definition Language (Lenguaje de Definición de Datos)
-- Permite crear, modificar y eliminar estructuras de una base de datos

Create Database SistemaReparaciones; -- Crear la base de datos
Go

Use SistemaReparaciones; -- Seleccionar la base de datos
Go

Create Table Usuarios ( -- Crear la tabla de usuarios
UsuarioID Int Identity(1,1) Primary Key, -- ID único autogenerado del usuario
Nombre Nvarchar(100) Not Null, -- Nombre obligatorio del usuario
CorreoElectronico Nvarchar(254) Not Null Unique, -- Correo único y obligatorio
Telefono Varchar(20) -- Número de teléfono del usuario
);
Go

Create Table Tecnicos ( -- Crear la tabla de técnicos
TecnicoID Int Identity(1,1) Primary Key, -- ID único autogenerado del técnico
Nombre Nvarchar(100) Not Null, -- Nombre obligatorio del técnico
Especialidad Nvarchar(100) Not Null -- Especialidad del técnico
);
Go

Create Table Equipos ( -- Crear la tabla de equipos
EquipoID Int Identity(1,1) Primary Key, -- ID único autogenerado del equipo
TipoEquipo Nvarchar(50) Not Null, -- Tipo de equipo tecnológico
Modelo Nvarchar(100) Not Null, -- Modelo del equipo
UsuarioID Int Not Null, -- ID del usuario propietario del equipo

Constraint FK_Equipos_Usuarios -- Nombre de la relación
Foreign Key (UsuarioID) -- Indicar la clave foránea
References Usuarios(UsuarioID) -- Relacionar con la tabla Usuarios
);
Go

Create Table Reparaciones ( -- Crear la tabla de reparaciones
ReparacionID Int Identity(1,1) Primary Key, -- ID único autogenerado
EquipoID Int Not Null, -- ID del equipo que necesita reparación
FechaSolicitud DateTime2(0) Not Null -- Fecha y hora de solicitud
Default SysDateTime(), -- Asignar fecha y hora automáticamente
Estado Nvarchar(30) Not Null -- Estado actual de la reparación
Default 'Pendiente', -- Estado inicial por defecto

Constraint FK_Reparaciones_Equipos -- Nombre de la relación
Foreign Key (EquipoID) -- Indicar la clave foránea
References Equipos(EquipoID), -- Relacionar con la tabla Equipos

Constraint CK_Reparaciones_Estado -- Nombre de la restricción
Check (Estado In ( -- Validar los estados permitidos
'Pendiente', -- Reparación pendiente
'En proceso', -- Reparación en proceso
'Finalizada', -- Reparación finalizada
'Cancelada' -- Reparación cancelada
))
);
Go

Create Table Asignaciones ( -- Crear la tabla de asignaciones
AsignacionID Int Identity(1,1) Primary Key, -- ID único autogenerado
ReparacionID Int Not Null, -- ID de la reparación asignada
TecnicoID Int Not Null, -- ID del técnico asignado
FechaAsignacion DateTime2(0) Not Null -- Fecha y hora de asignación
Default SysDateTime(), -- Registrar fecha automáticamente

Constraint FK_Asignaciones_Reparaciones -- Nombre de la primera relación
Foreign Key (ReparacionID) -- Clave foránea de la reparación
References Reparaciones(ReparacionID), -- Relacionar con Reparaciones

Constraint FK_Asignaciones_Tecnicos -- Nombre de la segunda relación
Foreign Key (TecnicoID) -- Clave foránea del técnico
References Tecnicos(TecnicoID) -- Relacionar con Tecnicos
);
Go

Create Table DetallesReparacion ( -- Crear la tabla de detalles
DetalleID Int Identity(1,1) Primary Key, -- ID único del detalle
ReparacionID Int Not Null, -- ID de la reparación relacionada
Descripcion Nvarchar(500) Not Null, -- Descripción del trabajo realizado
FechaInicio DateTime2(0), -- Fecha y hora de inicio
FechaFin DateTime2(0), -- Fecha y hora de finalización

Constraint FK_Detalles_Reparaciones -- Nombre de la relación
Foreign Key (ReparacionID) -- Indicar la clave foránea
References Reparaciones(ReparacionID), -- Relacionar con Reparaciones

Constraint CK_Detalles_Fechas -- Nombre de la restricción
Check ( -- Validar las fechas de reparación
FechaFin Is Null -- Permitir reparaciones sin fecha de finalización
Or FechaInicio Is Null -- Permitir registros sin fecha de inicio
Or FechaFin >= FechaInicio -- Evitar finalizar antes de comenzar
)
);
Go

-- Verificar las tablas creadas

Select Table_Name As NombreTabla -- Mostrar el nombre de cada tabla
From Information_Schema.Tables -- Consultar información de las tablas
Where Table_Type = 'BASE TABLE' -- Mostrar únicamente tablas
Order By Table_Name; -- Ordenar alfabéticamente
Go

-- Fase 3 Manipulación y lógica de negocio (DML)

-- ¿Qué es DML?
-- Data Manipulation Language (Lenguaje de Manipulación de Datos) que permite insertar, actualizar y eliminar información.
-- La función de SELECT se utiliza para consultar los registros almacenados.

-- Insertar 5 usuarios

Insert Into Usuarios -- Insertar registros en Usuarios
(Nombre, CorreoElectronico, Telefono) -- Columnas que recibirán los datos
Values -- Valores que se van a registrar
('Lucia Vado', 'lvado@gmail.com', '88881234'), -- Usuario 1
('Maria Murillo', 'mmurillo@gmail.com', '87774567'), -- Usuario 2
('Thania Camacho', 'tcamacho@gmail.com', '86661234'), -- Usuario 3
('Didier Suarez', 'dsuarez@gmail.com', '85552345'), -- Usuario 4
('Alba Guardado', 'aguardado@gmail.com', '84443456'); -- Usuario 5
Go

-- Insertar 5 técnicos

Insert Into Tecnicos -- Insertar registros en Tecnicos
(Nombre, Especialidad) -- Nombre y especialidad del técnico
Values -- Valores que se van a registrar
('Jose Manzan', 'Computadoras'), -- Técnico 1
('Oscar Flores', 'Telefonos'), -- Técnico 2
('Rolando Camacho', 'Redes'), -- Técnico 3
('Juan Luis', 'Impresoras'), -- Técnico 4
('Cesar Morera', 'Software'); -- Técnico 5
Go

-- Insertar 5 equipos

Insert Into Equipos -- Insertar registros en Equipos
(TipoEquipo, Modelo, UsuarioID) -- Tipo, modelo y propietario
Values -- Valores que se van a registrar
('Laptop', 'HP Pavilion', 1), -- Equipo del usuario 1
('Telefono', 'Samsung Galaxy A54', 2), -- Equipo del usuario 2
('Computadora', 'Dell OptiPlex', 3), -- Equipo del usuario 3
('Impresora', 'Epson EcoTank L3250', 4), -- Equipo del usuario 4
('Laptop', 'Lenovo ThinkPad E14', 5); -- Equipo del usuario 5
Go

-- Insertar 5 reparación

Insert Into Reparaciones -- Insertar solicitudes de reparación
(EquipoID, FechaSolicitud, Estado) -- Equipo, fecha y estado
Values -- Valores que se van a registrar
(1, '2026-11-01 08:00:00', 'Pendiente'), -- Reparación 1
(2, '2026-11-02 09:30:00', 'Pendiente'), -- Reparación 2
(3, '2026-11-03 10:00:00', 'Pendiente'), -- Reparación 3
(4, '2026-11-04 11:00:00', 'Pendiente'), -- Reparación 4
(5, '2026-11-05 13:00:00', 'Pendiente'); -- Reparación 5
Go

-- Insertar 5 asignaciones

Insert Into Asignaciones -- Insertar asignaciones de técnicos
(ReparacionID, TecnicoID, FechaAsignacion) -- Reparación, técnico y fecha
Values -- Valores que se van a registrar
(1, 1, '2026-11-01 08:30:00'), -- Técnico 1 asignado a reparación 1
(2, 2, '2026-11-02 10:00:00'), -- Técnico 2 asignado a reparación 2
(3, 3, '2026-11-03 10:30:00'), -- Técnico 3 asignado a reparación 3
(4, 4, '2026-11-04 11:30:00'), -- Técnico 4 asignado a reparación 4
(5, 5, '2026-11-05 13:30:00'); -- Técnico 5 asignado a reparación 5
Go

-- Insertar 5 detalles de reparación

Insert Into DetallesReparacion -- Insertar detalles de las reparaciones
(ReparacionID, Descripcion, FechaInicio, FechaFin) -- Columnas del detalle
Values -- Valores que se van a registrar

(1, 'Revision general de laptop', -- Descripción de reparación 1
'2026-11-01 09:00:00', Null), -- Inicio registrado, finalización pendiente

(2, 'Diagnostico de pantalla', -- Descripción de reparación 2
'2026-11-02 10:30:00', Null), -- Inicio registrado, finalización pendiente

(3, 'Revision de componentes internos', -- Descripción de reparación 3
'2026-11-03 11:00:00', Null), -- Inicio registrado, finalización pendiente

(4, 'Reparacion de sistema de impresion', -- Descripción de reparación 4
'2026-11-04 12:00:00', Null), -- Inicio registrado, finalización pendiente

(5, 'Mantenimiento de software', -- Descripción de reparación 5
'2026-11-05 14:00:00', Null); -- Inicio registrado, finalización pendiente
Go

-- Verificación de los registros insertados

Select * From Usuarios; -- Consultar todos los usuarios
Select * From Equipos; -- Consultar todos los equipos
Select * From Tecnicos; -- Consultar todos los técnicos
Select * From Reparaciones; -- Consultar todas las reparaciones
Select * From Asignaciones; -- Consultar todas las asignaciones
Select * From DetallesReparacion; -- Consultar todos los detalles
Go

-- ¿Qué significa CRUD?
-- Create: Crear registros.
-- Read: Consultar registros.
-- Update: Actualizar registros.
-- Delete: Eliminar registros.

-- Creamos un usuario
Insert Into Usuarios -- Insertar un nuevo usuario
(Nombre, CorreoElectronico, Telefono) -- Columnas a completar
Values -- Valores del nuevo usuario
('Fabricio Cortes', 'fcortes@gmail.com', '71348458'); -- Datos de Fabricio Cortes
Go

-- Consultamos usuarios

Select * From Usuarios; -- Mostrar todos los usuarios registrados
Go

-- Actualizamos un usuario

Update Usuarios -- Seleccionar la tabla que se actualizará
Set Telefono = '89990000' -- Establecer el nuevo teléfono
Where UsuarioID = 6; -- Actualizar únicamente al usuario 6
Go

-- Eliminar un usuario

Delete From Usuarios -- Eliminar un registro de Usuarios
Where UsuarioID = 6; -- Eliminar únicamente al usuario 6
Go

-- ¿Qué es un procedimiento almacenado?
-- Es un conjunto de instrucciones SQL guardadas en la base de datos que permite ejecutar tareas repetitivas mediante parámetros

-- Se crea el procedimiento sp_RegistrarReparacion

Create Procedure sp_RegistrarReparacion -- Crear procedimiento para registrar reparaciones
@EquipoID Int, -- Recibir el identificador del equipo
@FechaSolicitud DateTime2(0) -- Recibir la fecha de solicitud
As -- Indicar el inicio de las instrucciones del procedimiento
Begin -- Iniciar el bloque de código

Set NoCount On; -- Evitar mensajes de cantidad de filas afectadas

Insert Into Reparaciones -- Insertar una nueva reparación
(EquipoID, FechaSolicitud, Estado) -- Columnas que recibirán los datos
Values -- Valores de la nueva reparación
(@EquipoID, @FechaSolicitud, 'Pendiente'); -- Registrar reparación como pendiente

Print 'Reparacion registrada correctamente'; -- Mostrar mensaje de confirmación

End; -- Finalizar el procedimiento
Go

-- Ejecutamos sp_RegistrarReparación

Exec sp_RegistrarReparacion -- Ejecutar el procedimiento almacenado
@EquipoID = 1, -- Indicar el equipo que necesita reparación
@FechaSolicitud = '2026-11-10 09:00:00'; -- Indicar fecha y hora de solicitud
Go

Select * From Reparaciones; -- Verificar que se registró la reparación
Go

-- Crear procedimiento sp_AsignarTecnico

Create Procedure sp_AsignarTecnico -- Crear procedimiento de asignación
@ReparacionID Int, -- Recibir el ID de la reparación
@TecnicoID Int -- Recibir el ID del técnico
As -- Indicar el inicio de las instrucciones
Begin -- Iniciar el procedimiento

Set NoCount On; -- Evitar mensajes de filas afectadas

-- Validamos que exista la reparación

If Not Exists ( -- Verificar si la reparación no existe
Select 1 -- Comprobar la existencia de un registro
From Reparaciones -- Buscar en la tabla Reparaciones
Where ReparacionID = @ReparacionID -- Comparar el ID recibido
)
Begin -- Iniciar bloque cuando no existe la reparación

Throw 50001, 'La reparacion no existe.', 1; -- Mostrar error personalizado

End; -- Finalizar primera validación

-- Comprobar que el técnico exista

If Not Exists ( -- Verificar si el técnico no existe
Select 1 -- Comprobar la existencia de un registro
From Tecnicos -- Buscar en la tabla Tecnicos
Where TecnicoID = @TecnicoID -- Comparar el ID recibido
)
Begin -- Iniciar bloque cuando no existe el técnico

Throw 50002, 'El tecnico no existe.', 1; -- Mostrar error personalizado

End; -- Finalizar segunda validación

-- Comprobar la disponibilidad

If Exists ( -- Verificar si el técnico tiene reparaciones activas
Select 1 -- Comprobar si existen asignaciones
From Asignaciones A -- Consultar las asignaciones
Inner Join Reparaciones R -- Relacionar asignaciones y reparaciones
On A.ReparacionID = R.ReparacionID -- Vincular mediante ReparacionID
Where A.TecnicoID = @TecnicoID -- Buscar asignaciones del técnico
And R.Estado In ('Pendiente', 'En proceso') -- Comprobar estados activos
)
Begin -- Iniciar bloque si el técnico está ocupado

Throw 50003, 'El tecnico no esta disponible.', 1; -- Mostrar error de disponibilidad

End; -- Finalizar tercera validación

-- Registro de la asignación

Insert Into Asignaciones -- Insertar una nueva asignación
(ReparacionID, TecnicoID, FechaAsignacion) -- Columnas que recibirán los datos
Values -- Valores de la asignación
(@ReparacionID, @TecnicoID, SysDateTime()); -- Registrar asignación con fecha actual

Print 'Tecnico asignado correctamente'; -- Mostrar mensaje de confirmación

End; -- Finalizar el procedimiento
Go

-- Probar el procedimiento de asignación
Exec sp_AsignarTecnico -- Ejecutar el procedimiento
@ReparacionID = 6, -- Reparación que se desea asignar
@TecnicoID = 1; -- Técnico que se desea asignar
Go

-- Implementación del trigger

-- ¿Qué es un Trigger?
-- Es un disparador que ejecuta instrucciones automáticamente puede activarse al insertar, actualizar o eliminar registros.
-- En este proyecto actualiza el estado al finalizar una reparación.

-- Modificar la restricción de estados
Alter Table Reparaciones -- Modificar la tabla Reparaciones
Drop Constraint CK_Reparaciones_Estado; -- Eliminar restricción anterior
Go

Alter Table Reparaciones -- Modificar nuevamente la tabla Reparaciones
Add Constraint CK_Reparaciones_Estado -- Agregar restricción de estados
Check (Estado In ( -- Validar los valores permitidos
'Pendiente', -- Reparación pendiente
'En proceso', -- Reparación en proceso
'Finalizada', -- Reparación finalizada
'Completado', -- Reparación completada
'Cancelada' -- Reparación cancelada
));
Go

-- Crear el trigger trg_FinalizarReparacion

Create Trigger trg_FinalizarReparacion -- Crear trigger de finalización
On DetallesReparacion -- Tabla donde se activará
After Insert, Update -- Ejecutar después de insertar o actualizar
As -- Indicar las instrucciones del trigger
Begin -- Iniciar el bloque de código

Set NoCount On; -- Evitar mensajes de filas afectadas

Update R -- Actualizar los registros de Reparaciones
Set R.Estado = 'Completado' -- Cambiar el estado a Completado
From Reparaciones R -- Utilizar Reparaciones con el alias R
Inner Join ( -- Relacionar con los detalles modificados

Select Distinct ReparacionID -- Obtener reparaciones sin repetir identificadores
From inserted -- Consultar los registros insertados o actualizados
Where FechaFin Is Not Null -- Verificar que tengan fecha de finalización

) D -- Asignar el alias D al resultado de la subconsulta

On R.ReparacionID = D.ReparacionID -- Relacionar los identificadores
Where R.Estado = 'Pendiente'; -- Actualizar solo reparaciones pendientes

End; -- Finalizar el trigger
Go

-- Probamos el trigger

Update DetallesReparacion -- Actualizar un detalle de reparación
Set FechaFin = SysDateTime() -- Registrar fecha y hora de finalización
Where DetalleID = 1; -- Modificar únicamente el detalle 1
Go

-- Verificar el resultado del trigger

Select -- Consultar el resultado de las reparaciones
ReparacionID, -- Mostrar identificador de reparación
EquipoID, -- Mostrar identificador del equipo
FechaSolicitud, -- Mostrar fecha de solicitud
Estado -- Mostrar estado actual
From Reparaciones; -- Obtener información de Reparaciones
Go

-- Consultas de reparaciones y técnicos

Select -- Seleccionar información de las reparaciones
R.ReparacionID, -- Identificador de reparación
U.Nombre As Usuario, -- Nombre del propietario
E.TipoEquipo, -- Tipo de dispositivo
E.Modelo, -- Modelo del equipo
R.Estado, -- Estado actual de reparación
T.Nombre As Tecnico, -- Nombre del técnico asignado
T.Especialidad, -- Especialidad del técnico
D.Descripcion, -- Descripción del trabajo
D.FechaInicio, -- Fecha de inicio
D.FechaFin -- Fecha de finalización
From Reparaciones R -- Tabla principal Reparaciones

Inner Join Equipos E -- Relacionar reparaciones con equipos
On R.EquipoID = E.EquipoID -- Vincular mediante EquipoID

Inner Join Usuarios U -- Relacionar equipos con usuarios
On E.UsuarioID = U.UsuarioID -- Vincular mediante UsuarioID

Left Join Asignaciones A -- Incluir reparaciones sin asignaciones
On R.ReparacionID = A.ReparacionID -- Vincular mediante ReparacionID

Left Join Tecnicos T -- Obtener información de los técnicos
On A.TecnicoID = T.TecnicoID -- Vincular mediante TecnicoID

Left Join DetallesReparacion D -- Obtener los detalles de reparación
On R.ReparacionID = D.ReparacionID -- Vincular mediante ReparacionID

Order By R.ReparacionID; -- Ordenar por identificador de reparación
Go

-- Verificamos los procedimientos almacenados

Select name -- Mostrar el nombre del procedimiento
From sys.procedures -- Consultar procedimientos del sistema
Where name In ( -- Filtrar los procedimientos que queremos verificar
'sp_RegistrarReparacion', -- Procedimiento de registro
'sp_AsignarTecnico' -- Procedimiento de asignación
);
Go

-- Verificamos el trigger

Select name -- Mostrar el nombre del trigger
From sys.triggers -- Consultar triggers registrados
Where name = 'trg_FinalizarReparacion'; -- Buscar nuestro trigger
Go

-- Fase 4 Consultas de análisis e informes

-- Informe de asignaciones (inner join)

Select -- Seleccionar las columnas del informe
U.Nombre As NombreUsuario, -- Nombre del propietario del equipo
E.Modelo As ModeloEquipo, -- Modelo del dispositivo tecnológico
T.Nombre As NombreTecnico -- Nombre del técnico asignado

From Usuarios U -- Utilizar Usuarios como tabla principal

Inner Join Equipos E -- Relacionar Usuarios con Equipos
On U.UsuarioID = E.UsuarioID -- Vincular mediante UsuarioID

Inner Join Reparaciones R -- Relacionar Equipos con Reparaciones
On E.EquipoID = R.EquipoID -- Vincular mediante EquipoID

Inner Join Asignaciones A -- Relacionar Reparaciones con Asignaciones
On R.ReparacionID = A.ReparacionID -- Vincular mediante ReparacionID

Inner Join Tecnicos T -- Relacionar Asignaciones con Tecnicos
On A.TecnicoID = T.TecnicoID; -- Vincular mediante TecnicoID
Go

-- Estadistica de carga de trabajo

Select -- Seleccionar las columnas de la estadística
T.TecnicoID, -- Identificador del técnico
T.Nombre As NombreTecnico, -- Nombre del técnico
T.Especialidad, -- Especialidad del técnico
Count(Distinct A.ReparacionID) As TotalReparaciones -- Contar reparaciones diferentes

From Tecnicos T -- Utilizar Tecnicos como tabla principal

Left Join Asignaciones A -- Incluir técnicos sin reparaciones asignadas
On T.TecnicoID = A.TecnicoID -- Vincular mediante TecnicoID

Group By -- Agrupar los registros por técnico
T.TecnicoID, -- Agrupar por identificador
T.Nombre, -- Agrupar por nombre
T.Especialidad -- Agrupar por especialidad

Order By TotalReparaciones Desc; -- Ordenar de mayor a menor cantidad
Go

-- Declaramos el modelo que queremos consultar

Declare @Modelo Nvarchar(100) = 'HP Pavilion'; -- Definir el modelo que queremos buscar

-- Consultas de los equipos de último mes

Select -- Seleccionar las columnas del informe
E.EquipoID, -- Identificador del equipo
E.TipoEquipo, -- Tipo de equipo tecnológico
E.Modelo, -- Modelo del dispositivo
U.Nombre As NombreUsuario, -- Nombre del propietario
R.FechaSolicitud, -- Fecha de solicitud de reparación
R.Estado -- Estado actual de la reparación

From Equipos E -- Utilizar Equipos como tabla principal

Inner Join Usuarios U -- Relacionar Equipos con Usuarios
On E.UsuarioID = U.UsuarioID -- Vincular mediante UsuarioID

Inner Join Reparaciones R -- Relacionar Equipos con Reparaciones
On E.EquipoID = R.EquipoID -- Vincular mediante EquipoID

Where E.Modelo = @Modelo -- Buscar únicamente el modelo indicado

And R.FechaSolicitud >= DateAdd(Month, -1, GetDate()) -- Fecha desde hace un mes

And R.FechaSolicitud <= GetDate() -- Fecha no posterior al momento actual

Order By R.FechaSolicitud Desc; -- Mostrar primero las solicitudes más recientes
Go

-- Explicaciones de algunas funciones del proyecto

-- SELECT: Selecciona las columnas de una consulta.
-- FROM: Indica la tabla principal de la consulta.
-- INNER JOIN: Relaciona registros coincidentes de varias tablas.
-- LEFT JOIN: Incluye registros aunque no tengan coincidencias.
-- ON: Establece la condición utilizada para relacionar tablas.
-- AS: Permite asignar nombres alternativos a las columnas.
-- COUNT: Cuenta los registros que cumplen una condición.
-- DISTINCT: Evita contar valores repetidos.
-- GROUP BY: Agrupa los registros según las columnas indicadas.
-- WHERE: Permite filtrar registros mediante condiciones.
-- AND: Exige que se cumplan varias condiciones.
-- DECLARE: Permite declarar variables.
-- DATEADD: Permite sumar o restar períodos a una fecha.
-- GETDATE: Obtiene la fecha y hora actual del servidor.
-- ORDER BY: Ordena los resultados de una consulta.
-- DESC: Establece el orden descendente.