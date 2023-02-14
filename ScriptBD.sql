--CREACIÓN BD
create database ECOMMERCE
go

--TABLAS PARA LIBROS
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
go

--PROCEDIMIENTOS PARA LIBROS
create procedure SP_librosListar as
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
GO


CREATE PROCEDURE SP_EliminarFisico
	@Id smallint 
AS 
DELETE FROM Libros WHERE Id = @Id
GO


CREATE PROCEDURE SP_EliminarLogico
@Id smallint, 
@Estado bit
AS 
UPDATE Libros SET Estado= @Estado WHERE Id = @Id
go


CREATE PROCEDURE SP_ListarLibrosInactivos
as
select l.id, l.Titulo, l.Descripcion, l.Autor, l.Editorial, l.Precio, l.Stock, g.IdGenero as Genero_ID, g.Descripcion as Genero_Desc, l.Portada, l.estado 
from Libros l 
inner join Generos g on l.IdGenero = g.IdGenero 
GO 


--SP quedó sin uso -> Eliminar y eliminar Método listarConStockConSP de LibroNegocio.cs
create procedure SP_librosListarStock as
select l.id, l.Titulo, l.Descripcion, l.Autor, l.Editorial, l.Precio, l.Stock, g.IdGenero as Genero_ID, g.Descripcion as Genero_Desc, l.Portada, l.estado 
from Libros l 
inner join Generos g on l.IdGenero = g.IdGenero 
where l.Estado = 1
and l.Stock > 0
GO

--TABLAS PARA USUARIOS
create table usuarios (
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
go

ALTER TABLE [dbo].[datos_usuario] DROP CONSTRAINT [UQ__datos_us__C035B8DD11060EC6]
GO


--PROCEDIMIENTOS PARA USUARIOS

--12/12/2022 SE MODIFICA PROCEDIMIENTO PARA QUE NO PERMITA LOGUEAR USUARIOS INACTIVOS
alter procedure sp_login(
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
and u.Estado = 1
GO


create procedure sp_insertarNuevo(
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
go


create procedure sp_listarClientes
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
where u.TipoUsuario = 1
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
	declare @relacionID smallint
	select @relacionID = IdUsuario from datos_usuario du 
		where du.IdUsuario = @idUsuario 
	update usuarios 
	set 
		Contraseña = @contraseña, 
		Nombres = @nombres, 
		Apellidos = @apellidos,
		Estado = 1
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
GO


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
go

--Modificar porque tira error -- SOLUCIONADO!!!
alter procedure sp_ClienteEliminarFisico (
	@idUsuario smallint
)
as
begin
BEGIN TRY
	
	delete from ItemCarrito
		from ItemCarrito IC 
		inner join Ventas V on ic.IDVenta = v.IDVenta
		where v.IDUsuario = @idUsuario

	delete from ventas 
	where IDUsuario = @idUsuario
	
	delete from datos_usuario
	where IdUsuario = @idUsuario
	
	delete from usuarios 
	where IdUsuario = @idUsuario

END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION
	RAISERROR('No se pudo eliminar usuario', 16,1)
END CATCH
end
go


--TABLAS PARA VENTAS
CREATE TABLE Ventas(
    IDVenta int PRIMARY KEY IDENTITY(1,1),
    IDUsuario smallint not null FOREIGN KEY REFERENCES Usuarios (IdUsuario),
    FormaPago char not null CHECK (FormaPago='E' OR FormaPago='T'),
    Envio bit not null,
    Importe money not null CHECK(Importe>0),
    Cantidad int not null CHECK (Cantidad>0),
    Fecha datetime not null,
    Estado char not null CHECK (Estado='R' OR Estado='P' OR Estado='E' OR Estado='C')
)
GO

ALTER TABLE Ventas
ADD Calle varchar (100),
	Numero varchar (10),
	Piso varchar (10),
	Depto varchar (10),
	CodPostal varchar (10),
	Localidad varchar (100),
	Provincia varchar (100)


CREATE TABLE ItemCarrito(
    IDItem smallint not null,
    NombreItem varchar (200) not null,
    Cantidad int not null Check(Cantidad >0),
    Precio money not null Check(Precio >0),
    IDVenta int not null FOREIGN KEY REFERENCES Ventas (IDVenta)
)
GO

--PROCEDIMIENTOS PARA VENTAS
CREATE PROCEDURE SP_AltaVenta (
	@IDUsuario smallint,
	@FormaPago char,
	@Envio bit,
	@Importe money,
	@Cantidad int,
	@Calle varchar (100),
	@Numero varchar (10),
	@Piso varchar (10),
	@Depto varchar (10),
	@CodPostal varchar (10),
	@Localidad varchar (100),
	@Provincia varchar (100)
)
AS 
INSERT INTO Ventas OUTPUT inserted.IDVenta
VALUES (@IDUsuario,@FormaPago,@Envio,@Importe,@Cantidad,GETDATE(),'R',@Calle,@Numero,@Piso,@Depto,@CodPostal,@Localidad,@Provincia)
GO 

CREATE PROCEDURE SP_AltaItemCarrito (
	@IDItem smallint,
	@NombreItem varchar(200),
	@Cantidad int,
	@Precio money,
	@IDVenta int
)
AS 
INSERT INTO ItemCarrito 
VALUES (@IDItem,@NombreItem,@Cantidad,@Precio,@IDVenta)
GO



create procedure sp_listarVentas(
	@idUsuario smallint
)
as
begin
	if(@idUsuario is null) begin
		select 
			idventa,
			FormaPago,
			envio,
			importe,
			cantidad,
			fecha,
			estado,
			calle,
			numero,
			piso,
			depto,
			codPostal,
			Localidad,
			provincia
		from Ventas
	end
	else begin
		select 
			idventa,
			FormaPago,
			envio,
			importe,
			cantidad,
			fecha,
			estado,
			calle,
			numero,
			piso,
			depto,
			codPostal,
			Localidad,
			provincia
		from Ventas
		where @idUsuario = idUsuario
	end
end
GO

create procedure sp_listarItems(
	@idVenta int
)
as
begin
	select
		IdItem,
		NombreItem,
		Cantidad,
		Precio		
	from ItemCarrito
	where @idVenta = IDVenta
end
GO 

--MODIFICADO 10/12 !!!
create procedure sp_seleccionarVenta(
	@idVenta smallint
)
as
begin
	select
		IDUsuario, 
		FormaPago,
		envio,
		importe,
		cantidad,
		fecha,
		estado,
		calle,
		numero,
		piso,
		depto,
		codPostal,
		Localidad,
		provincia
	from Ventas
	where @idVenta = IdVenta
end
GO

create procedure sp_modificaEstadoEnvio(
	@estadoEnvio char,
	@idVenta int
)
as
begin
	update ventas
	set estado = @estadoEnvio
	where IDVenta = @idVenta
end
GO

CREATE procedure sp_restarStock(
	@idItem int,
	@cantidad int
)
as
begin
	declare @stock int
	select @stock = stock from libros where id = @idItem
	BEGIN TRY
	if (@stock >= @cantidad) begin
		update libros
		set stock -= @cantidad
		where id = @idItem
	end
	
	select @stock = stock from libros where id = @idItem

	if (@stock = 0) begin
		update libros
		set estado = 0
		where id = @idItem
	end

	END TRY
	BEGIN CATCH
		raiserror ('No contamos con stock suficiente', 16, 1)
	END CATCH
	
end
GO 


create procedure sp_modificarPass(
	@idUsuario int,
	@pass varchar(100)
)
as
begin
	update usuarios
	set Contraseña = @pass
	where IdUsuario = @idUsuario
end
go


/********************************************************/

create table clientes_codigos(
	mail varchar (100) not null unique,
	id_codigo smallint not null
)


create table codigos( 
	id_codigo smallint primary key identity (1,1),
	codigo varchar (5) not null
) 


insert into codigos (codigo) values('od34j');
insert into codigos (codigo) values('uLd72');
insert into codigos (codigo) values('ouhd6');
insert into codigos (codigo) values('ueJ2q');
insert into codigos (codigo) values('splu1');

GO

create procedure sp_restablecerPass(
	@mail varchar (100),
	@nuevaPass varchar (100),
	@codigoCliente varchar(5)
)
as
begin
	declare @codigo varchar(5)

	select @codigo = codigo 
		from codigos c
		inner join clientes_codigos cc on c.id_codigo = cc.id_codigo
		where cc.mail = @mail


	if (@codigoCliente = @codigo) begin
		update usuarios
		set Contraseña = @nuevaPass
		where mail = @mail

		delete from clientes_codigos
		where mail = @mail
	end
	else begin
		raiserror ('El codigo ingresado es incorrecto', 16, 1)
	end
end
go


create procedure sp_setearCodigo(
	@mail varchar (100),
	@random smallint
)
as
begin
	declare @mailExiste varchar(100)

	select @mailExiste = mail 
		from clientes_codigos
		where mail = @mail

	if (@mailExiste is null) begin
		insert into clientes_codigos
		values (@mail, @random)
	end
	else
	begin
		update clientes_codigos
		set id_codigo = @random
		where mail = @mail
	end
end
go

create procedure sp_enviarCodigo(
	@mail varchar (100)
)
as
begin
	select codigo
	from codigos c
	inner join clientes_codigos cc on c.id_codigo = cc.id_codigo
	where cc.mail = @mail
end
go




--Procedimientos sacados del MANAGMENT
/**********************************/
CREATE TABLE [dbo].[codigos](
	[id_codigo] [smallint] IDENTITY(1,1) NOT NULL,
	[codigo] [varchar](5) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[codigos]  WITH CHECK ADD CHECK  ((len([codigo])=(5)))
GO




CREATE TABLE [dbo].[clientes_codigos](
	[id_usuario] [smallint] NOT NULL,
	[id_codigo] [smallint] NOT NULL,
UNIQUE NONCLUSTERED 
(
	[id_usuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[clientes_codigos]  WITH CHECK ADD FOREIGN KEY([id_codigo])
REFERENCES [dbo].[codigos] ([id_codigo])
GO

ALTER TABLE [dbo].[clientes_codigos]  WITH CHECK ADD FOREIGN KEY([id_usuario])
REFERENCES [dbo].[usuarios] ([IdUsuario])
GO
/**********************************************/



/***************VENTAS**********************/
create table estadoVenta(
	idVenta int not null foreign key references ventas (idventa),
	codPago varchar (20),
	envio datetime,
	entrega datetime
)
go

create procedure sp_estadoCompra(
	@idVenta int
)	
as
begin
	insert into estadoVenta (idVenta)
	values (@idVenta)
end
go

create procedure sp_registroEstadoCompra(
	@idVenta int
)
as
begin
	select 
		codPago,
		envio,
		entrega
	from estadoVenta
	where idVenta = @idVenta
end
go

create procedure sp_modificaEstadoCompra(
	@idVenta int,
	@codPago varchar (20),
	@envio datetime,
	@entrega datetime
)
as 
begin
	update estadoVenta
	set codPago = @codPago, 
		envio = @envio,
		entrega = @entrega
	where idVenta = @idVenta
end
go


create procedure sp_cambiaEstadoCompra(
	@idVenta int
)
as
begin
	declare @codPago varchar (20)
	declare @enviado datetime, @entregado datetime

	select @codPago = codPago from estadoVenta where idVenta = @idVenta
	select @enviado = envio from estadoVenta where idVenta = @idVenta
	select @entregado = entrega from estadoVenta where idVenta = @idVenta

	if (@entregado is not null) begin
		update Ventas set Estado = 'C' where IDVenta = @idVenta
	end
	else if (@enviado is not null) begin
		update Ventas set Estado = 'E' where IDVenta = @idVenta
	end
	else if (@codPago is not null) begin
		update Ventas set Estado = 'P' where IDVenta = @idVenta
	end
	else begin
		update Ventas set Estado = 'R' where IDVenta = @idVenta
	end
end
go

