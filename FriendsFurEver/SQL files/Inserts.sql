-- Remove all existing records
DELETE FROM adocoes;
DELETE FROM adotante;
DELETE FROM cat;
DELETE FROM dog;
DELETE FROM empregado;
DELETE FROM pet;
DELETE FROM shelter;
DELETE FROM tratamentos;
DELETE FROM utilizador;
DELETE FROM vacinas;

-- Insert new records in the correct order

-- utilizador
INSERT INTO utilizador (Email, Nome, Contacto, Morada, CC, Pass) VALUES
(NULL, NULL, NULL, NULL, '1', '$2y$10$GXUS2/0YWJBNT5MBbW1aZOEwpDNmhXORCaURT8K.BXCvh7HrH2BBG'),
('ilidio@gmail.com', 'Ilidio', 923432122, 'Rua das Amoreiras 120', '123454321', '$2y$10$K7VMGii6rD50b8b1X5UOWeXYl3KwL.ONx6ilaHrOUbSaQtrUieKLK'),
('rubenamorim@gmail.com', 'Amorim', 923161623, 'Alcochete', '999111', '$2y$10$XJMxCStdQJDE4thGjfIfXOLPHjPEuRVGhvW0Hjwb3CXprE3FDwSgm');

-- shelter
INSERT INTO shelter (Morada, Email, Contacto) 
VALUES
('Rua Doutor Tomás Aquino 3800-523 Cabeço', 'FriendsFurEver@gmail.com', 0);

-- pet
INSERT INTO pet (Id, EstadoDeAdocao, Microchip, Comportamento, IdMae, IdPai, Healthy, Sexo, Img) 
VALUES
(1, 1, 1, 'Calmo e pacifico', NULL, NULL, 0, 'm', '../Img/toby.png'),
(2, 1, 1, 'Brincalhão e meigo', NULL, NULL, 1, 'm', '../Img/ruben.png'),
(3, 0, 1, 'Come bastante, por vezes agressivo', NULL, NULL, 0, 'm', '../Img/chentric.png'),
(4, 0, 1, 'Não gosta de sair, calma', NULL, NULL, 0, 'f', '../Img/lucia.png'),
(5, 1, 1, 'Explorador e brincalhao', 4, 3, 0, 'f', '../Img/riscas.png'),
(6, 0, 1, 'Leal e gentil', NULL, 2, 1, 'm', '../Img/ben.png'),
(7, 0, 1, 'Gosta de sair e brincar', NULL, NULL, 0, 'm', '../Img/scooby.png'),
(8, 1, 1, 'Pouco ativo e calmo', NULL, NULL, 0, 'm', '../Img/travis.png'),
(9, 0, 1, 'Leal e otima guarda', NULL, NULL, 0, 'f', '../Img/lorde.png'),
(19, 0, 1, 'Energético e Teimoso', NULL, NULL, 1, 'm', '../Img/inacio.png');

-- cat
INSERT INTO cat (IdCat, Nome, Raca, Idade) 
VALUES
(3, 'Chentric', 'American Wirehair', 5),
(4, 'Lucia', 'La Perm', 4),
(5, 'Riscas', 'Rafeiro', 1),
(8, 'Travis', 'Rafeiro', 1);

-- dog
INSERT INTO dog (IdDog, Nome, Raca, Idade) 
VALUES
(1, 'Toby', 'Rafeiro', 12),
(2, 'Ruben', 'Jack Russel', 8),
(6, 'Ben', 'Jack Russel', 2),
(7, 'Scooby', 'Rafeiro', 8),
(9, 'Lorde', 'Dobermann', 6);

-- adotante
INSERT INTO adotante (CC, Idade, Emprego) 
VALUES
('123454321', 24, 'Trolha'),
('999111', 90, 'Juiz');

-- empregado
INSERT INTO empregado (CC, IdTrabalho) 
VALUES
('1', 5);

-- adocoes
INSERT INTO adocoes (IdAdocao, CCAdotante, IdPet, EstadoAdocaoPet) 
VALUES
(28, '123454321', 1, 1),
(29, '123454321', 5, 1),
(43, '123454321', 2, 1),
(45, '999111', 8, 1);

-- tratamentos
INSERT INTO tratamentos (IdPet_Pet_Pet, Desparasitado, Esterilizado) 
VALUES
(2, 1, 1),
(3, 1, 1),
(6, 1, 1),
(19, 1, 1);

-- vacinas
INSERT INTO vacinas (IdPet_Pet, Leishmaniose, Gripe, Raiva) VALUES
(2, 1, 1, 1),
(3, 1, 1, 0),
(6, 1, 1, 1),
(19, 1, 1, 1);