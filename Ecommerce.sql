/*drop database ECOMMERCE
go*/

/*create database ECOMMERCE
go

create table Generos (
	IdGenero smallint primary key identity (1,1),
	Descripcion varchar(1000)
)
go

create table Libros (
	Id smallint primary Key Identity (1,1),
	Titulo varchar (200) Not Null,
	Descripcion varchar(1000), 
	Autor varchar (200) Not Null,
	Editorial varchar (100) Not Null,
	Precio money Not Null Check(Precio > 0),
	Stock int Not Null Check (Stock >=0),
	IdGenero smallint Not Null foreign key references Generos(idGenero),
	Portada varchar (1000),
	Estado bit not null
	)
go*/

create table Administradores (
	IdAdministrador smallint primary key identity (1,1),
	Mail varchar(500) unique, 
	Contraseña varchar (500) Not Null,
	Nombres varchar (50) Not Null,
	Apellidos varchar (50) Not Null
)
go

create table Clientes (
	IdCliente smallint primary key identity (1,1),
	Mail varchar(500) unique, 
	Contraseña varchar (500) Not Null,
	Nombres varchar (100) Not Null,
	Apellidos varchar (100) Not Null,
	DNI varchar (50) not null unique,
	Telefono varchar (100), 
	Celular varchar (100),
	Calle varchar (100),
	Numero varchar (10),
	Piso varchar (10),
	Departamento varchar (10),
	CP varchar (10),
	Localidad varchar (100),
	Provincia varchar (100)
)
go


/*create table Carrito(
	IdCarrito smallint primary key identity (1,1),
	IdCliente smallint foreign key references Clientes (IdCliente)
)
go

create table Ventas(
	IdVenta smallint primary key identity (1,1),
	IdCarrito smallint foreign key references Carrito (IdCarrito),
	FormaPago varchar (100) not null,
	Fecha date not null,
	Estado varchar (100) not null
)
go*/

/*create procedure SP_librosListar as
select l.id, l.Titulo, l.Descripcion, l.Autor, l.Editorial, l.Precio, l.Stock, g.IdGenero as Genero_ID, g.Descripcion as Genero_Desc, l.Portada, l.estado 
from Libros l 
inner join Generos g on l.IdGenero = g.IdGenero 
where l.Estado = 1
GO

CREATE PROCEDURE SP_AltaLibro
    @Titulo varchar(200),
    @Descripcion varchar (1000),
    @Autor varchar(200),
    @Editorial varchar (100),
    @Precio money,
    @Stock int,
    @IdGenero smallint,
    @PortadaURL varchar (100)
AS 
INSERT INTO Libros VALUES (@Titulo, @Descripcion, @Autor, @Editorial, @Precio, @Stock, @IdGenero, @PortadaURL, 1)
GO 

CREATE PROCEDURE SP_ModificarLibro 
    @Titulo varchar(200),
    @Descripcion varchar (1000),
    @Autor varchar(200),
    @Editorial varchar (100),
    @Precio money,
    @Stock int,
    @IdGenero smallint,
    @PortadaURL varchar (100),
    @Id smallint
AS 
UPDATE Libros SET Titulo= @Titulo, Descripcion= @Descripcion, Autor= @Autor, Editorial= @Editorial, Precio= @Precio, Stock= @Stock,
                  IDGenero= @IdGenero, Portada= @PortadaURL WHERE Id= @Id
GO*/

/*create procedure sp_altaCliente
	@mail varchar(500), 
	@contraseña varchar (500),
	@nombres varchar (100),
	@apellidos varchar (100),
	@DNI varchar (50),
	@telefono varchar (100), 
	@celular varchar (100),
	@calle varchar (100),
	@numero varchar (10),
	@piso varchar (10),
	@departamento varchar (10),
	@CP varchar (10),
	@localidad varchar (100),
	@provincia varchar (100)
as 
insert into Clientes values (@mail,	@contraseña, @nombres, @apellidos, @DNI, @telefono, @celular, @calle, @numero, @piso, @departamento, @CP, @localidad, @provincia, 1)
go*/


alter table Clientes
add Estado bit not null default(1);
go


/*CREATE PROCEDURE SP_EliminarFisico
	@Id smallint 
AS 
DELETE FROM Libros WHERE Id = @Id

GO*/

/*CREATE PROCEDURE SP_EliminarLogico
@Id smallint 
AS 
UPDATE Libros SET Estado= 0 WHERE Id = @Id

GO*/ 

/*CREATE PROCEDURE SP_ListarLibrosInactivos
as
select l.id, l.Titulo, l.Descripcion, l.Autor, l.Editorial, l.Precio, l.Stock, g.IdGenero as Genero_ID, g.Descripcion as Genero_Desc, l.Portada, l.estado 
from Libros l 
inner join Generos g on l.IdGenero = g.IdGenero 

GO*/ 

/*CREATE PROCEDURE SP_EliminarLogico
@Id smallint, 
@Estado bit
AS 
UPDATE Libros SET Estado= @Estado WHERE Id = @Id
go*/

/*create procedure sp_listarClientes as
select 
	c.IdCliente, 
	c.mail, 
	c.Contraseña, 
	c.Nombres, 
	c.Apellidos, 
	c.Dni, 
	c.Telefono, 
	c.Celular, 
	c.Calle, 
	c.Numero, 
	c.Piso, 
	c.Departamento, 
	c.CP, 
	c.Localidad, 
	c.Provincia, 
	c.estado
from clientes c
go*/

/*create procedure sp_modificarCliente
@idCliente smallint, 
@contraseña varchar(500),
@nombres varchar(100),
@apellidos varchar(100),
@dni varchar (50),
@telefono varchar (100),
@celular varchar (100),
@calle varchar (100),
@numero varchar (10),
@piso varchar (10),
@departamento varchar (10),
@cp varchar (10),
@localidad varchar (100),
@provincia varchar (100),
@estado bit
as
update Clientes set Contraseña = @contraseña, Nombres = @nombres, Apellidos = @apellidos, DNI = @dni, Telefono = @telefono, 
Celular = @celular, Calle = @calle, Numero = @numero, Piso = @piso, Departamento = @departamento, CP = @cp, Localidad = @localidad, Provincia = @provincia, Estado = @estado
where IdCliente = @idCliente
go*/


/*create procedure sp_ClienteEliminarFisico
	@idCliente smallint
as
delete from clientes 
where idCliente = @idCliente
go*/

alter table clientes
add TipoUser int default (1)
go

alter table administradores
add TipoUser int default (2)
go


/*create procedure sp_login(
	@mail varchar (500), 
	@pass varchar (500)
)
as
select 
	u.IdUsuario,
	u.TipoUsuario,
	u.Apellidos,
	u.Nombres
from usuarios u
where u.Mail = @mail 
and u.Contraseña = @pass
go*/


/*create table usuarios (
	IdUsuario smallint primary key identity (1,1),
	Mail varchar(500) unique, 
	Contraseña varchar (500) Not Null,
	Nombres varchar (100) Not Null,
	Apellidos varchar (100) Not Null,
	Estado bit not null,
	TipoUsuario smallint not null
)
go

create table datos_usuario (
	IdUsuario smallint primary key foreign key references usuarios(IdUsuario), 
	DNI varchar (50) not null unique,
	Telefono varchar (100), 
	Celular varchar (100),
	Calle varchar (100),
	Numero varchar (10),
	Piso varchar (10),
	Departamento varchar (10),
	CP varchar (10),
	Localidad varchar (100),
	Provincia varchar (100)
)
go*/


/*create procedure sp_insertarNuevo(
	@Apellidos varchar (100),
	@Nombres varchar (100),
	@Mail varchar (500),
	@Contraseña varchar(500),
	@TipoUsuario smallint
)
as
begin
	insert into usuarios (Apellidos, Nombres, Mail, Contraseña, TipoUsuario, Estado)
	output inserted.IdUsuario
	values (@Apellidos, @Nombres, @Mail, @Contraseña, @TipoUsuario, 1)
end
go*/

/*create procedure sp_listarClientes
as
select 
	u.IdUsuario,
	u.Mail,
	u.Nombres,
	u.Apellidos,
	u.Estado,
	du.DNI,
	du.Telefono,
	du.Celular,
	du.Calle,
	du.Numero,
	du.Piso,
	du.Departamento,
	du.CP,
	du.Localidad,
	du.Provincia
from usuarios u
left join datos_usuario du on u.IdUsuario = du.IdUsuario
go



create procedure sp_modificarCliente(
	@idUsuario smallint, 
	@contraseña varchar(500),
	@nombres varchar(100),
	@apellidos varchar(100),
	@dni varchar (50),
	@telefono varchar (100),
	@celular varchar (100),
	@calle varchar (100),
	@numero varchar (10),
	@piso varchar (10),
	@departamento varchar (10),
	@cp varchar (10),
	@localidad varchar (100),
	@provincia varchar (100),
	@estado bit
)
as
begin
	update usuarios 
	set 
		Contraseña = @contraseña, 
		Nombres = @nombres, 
		Apellidos = @apellidos,
		Estado = @estado
	where IdUsuario = @idUsuario
	update datos_usuario 
	set 
		DNI = @dni, 
		Telefono = @telefono, 
		Celular = @celular, 
		Calle = @calle, 
		Numero = @numero, 
		Piso = @piso, 
		Departamento = @departamento, 
		CP = @cp, 
		Localidad = @localidad, 
		Provincia = @provincia 
	where IdUsuario = @idUsuario
end
go

create procedure sp_usuarioEliminarLogico (
	@IdUsuario smallint, 
	@activo bit
)
as 
begin
	update usuarios 
	set Estado= @activo 
	where IdUsuario = @IdUsuario
end
go

create procedure sp_UsuarioEliminarFisico (
	@idUsuario smallint
)
as
begin
	declare @estado bit
	select @estado = estado from usuarios
	if @estado = 0 begin
		
		delete from datos_usuario
		where IdUsuario = @idUsuario

		delete from usuarios 
		where IdUsuario = @idUsuario
	end
	else begin
		raiserror('El usuario se encuentra Activo', 16, 1)
	end
end
go


create procedure sp_buscarPorID(
	@idUsuario smallint
)
as 
begin
select 
	u.IdUsuario,
	u.Mail,
	u.Nombres,
	u.Apellidos,
	u.Estado,
	u.TipoUsuario,
	du.DNI,
	du.Telefono,
	du.Celular,
	du.Calle,
	du.Numero,
	du.Piso,
	du.Departamento,
	du.CP,
	du.Localidad,
	du.Provincia
from usuarios u
left join datos_usuario du on u.IdUsuario = du.IdUsuario
where u.IdUsuario = @idUsuario
end
go*/

ALTER procedure [dbo].[sp_login](
@mail varchar (500), 
@pass varchar (500)
)
as
select 
	u.IdUsuario,
	u.TipoUsuario,
	u.Apellidos,
	u.Nombres,
	u.Estado,
	du.DNI,
	du.Telefono,
	du.Celular,
	du.Calle,
	du.Numero,
	du.Piso,
	du.Departamento,
	du.CP,
	du.Localidad,
	du.Provincia
from usuarios u
left join datos_usuario du on u.IdUsuario = du.IdUsuario
where u.Mail = @mail
and u.Contraseña = @pass


ALTER procedure [dbo].[sp_modificarCliente](
	@idUsuario smallint, 
	@contraseña varchar(500),
	@nombres varchar(100),
	@apellidos varchar(100),
	@dni varchar (50),
	@telefono varchar (100),
	@celular varchar (100),
	@calle varchar (100),
	@numero varchar (10),
	@piso varchar (10),
	@departamento varchar (10),
	@cp varchar (10),
	@localidad varchar (100),
	@provincia varchar (100),
	@estado bit
)
as
begin
	declare @relacionID smallint
	select @relacionID = IdUsuario from datos_usuario du 
		where du.IdUsuario = @idUsuario 
	update usuarios 
	set 
		Contraseña = @contraseña, 
		Nombres = @nombres, 
		Apellidos = @apellidos,
		Estado = @estado
	where IdUsuario = @idUsuario
	
	if (@relacionID is null) begin
		insert into datos_usuario 
		values
			(
			@idUsuario, 
			@dni, 
			@telefono, 
			@celular, 
			@calle, 
			@numero, 
			@piso, 
			@departamento, 
			@cp, 
			@localidad, 
			@provincia 
		)
	end
	else begin	
		update datos_usuario 
		set 
			DNI = @dni, 
			Telefono = @telefono, 
			Celular = @celular, 
			Calle = @calle, 
			Numero = @numero, 
			Piso = @piso, 
			Departamento = @departamento, 
			CP = @cp, 
			Localidad = @localidad, 
			Provincia = @provincia 
			where IdUsuario = @idUsuario
		end
end
