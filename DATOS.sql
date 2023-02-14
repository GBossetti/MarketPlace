insert into Generos (Descripcion) values
('Ciencia Ficción'),
('Terror'),
('Infantil'),
('Aventuras'),
('Policial'),
('Novela no ficción'),
('Thriller'),
('Fantástico')

insert into Libros (Titulo, Descripcion, Autor, Editorial, Precio, Stock, IdGenero, Portada, Estado) values
('Nuestra parte de noche', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.', 'Mariana Enríquez', 'Anagrama', 5350, 200, 1, 'https://www.anagrama-ed.es/uploads/media/portadas/0001/23/9931fa307ceb1ff16718890a064f7522d498e7ef.jpeg', 1),
('De vidas ajenas', 'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', 'Emmanuel Carrère', 'Anagrama', 2950, 100, 6, 'https://www.anagrama-ed.es/uploads/media/portadas/0001/15/80349febc9ba6d3dae6a1922cbe38becf4840c8a.jpeg', 1 )

EXEC SP_AltaLibro 'La Chica del Tren', 'El Bestseller en el que se basa la película', 'Paula Hawkins', 'Planeta', 4500, 10, 7,
                            'https://http2.mlstatic.com/D_NQ_NP_629953-MLA46669897461_072021-O.jpg'


