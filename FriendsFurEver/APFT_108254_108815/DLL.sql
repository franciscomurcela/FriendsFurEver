DROP TABLE IF EXISTS adocoes
DROP TABLE IF EXISTS adotante
DROP TABLE IF EXISTS tratamentos
DROP TABLE IF EXISTS vacinas
DROP TABLE IF EXISTS dog
DROP TABLE IF EXISTS cat
DROP TABLE IF EXISTS empregado
DROP TABLE IF EXISTS pet
DROP TABLE IF EXISTS shelter
DROP TABLE IF EXISTS utilizador

CREATE TABLE adocoes (
  IdAdocao int NOT NULL,
  CCAdotante varchar(20) NOT NULL,
  IdPet int NOT NULL,
  EstadoAdocaoPet bit NOT NULL
);

CREATE TABLE adotante (
  CC varchar(20) NOT NULL,
  Idade int NOT NULL,
  Emprego varchar(255) NOT NULL
);

CREATE TABLE cat (
  IdCat int NOT NULL,
  Nome varchar(50) NOT NULL,
  Raca varchar(63) NOT NULL,
  Idade int NOT NULL
);

CREATE TABLE dog (
  IdDog int NOT NULL,
  Nome varchar(50) NOT NULL,
  Raca varchar(63) NOT NULL,
  Idade int NOT NULL
);

CREATE TABLE empregado (
  CC varchar(20) NOT NULL,
  IdTrabalho int NOT NULL
);

CREATE TABLE pet (
  Id int NOT NULL,
  EstadoDeAdocao bit NOT NULL,
  Microchip bit NOT NULL,
  Comportamento varchar(2083) NOT NULL,
  IdMae int,
  IdPai int,
  Healthy bit NOT NULL,
  Sexo char(1) NOT NULL CHECK (Sexo IN ('f', 'm')),
  Img varchar(100) NOT NULL
);

CREATE TABLE shelter (
  Morada varchar(MAX) NOT NULL,
  Email varchar(255) NOT NULL,
  Contacto int NOT NULL
);

CREATE TABLE tratamentos (
  IdPet_Pet_Pet int NOT NULL,
  Desparasitado bit NOT NULL,
  Esterilizado bit NOT NULL
);

CREATE TABLE utilizador (
  Email varchar(255),
  Nome varchar(255),
  Contacto int,
  Morada varchar(255),
  CC varchar(20) NOT NULL,
  Pass varchar(100) NOT NULL
);

CREATE TABLE vacinas (
  IdPet_Pet int NOT NULL,
  Leishmaniose bit NOT NULL,
  Gripe bit NOT NULL,
  Raiva bit NOT NULL
);

-- Indices for table `pet`
ALTER TABLE pet ADD CONSTRAINT PK_pet PRIMARY KEY (Id);
ALTER TABLE pet ADD CONSTRAINT FK_pet_pet_IdMae FOREIGN KEY (IdMae) REFERENCES pet(Id);
ALTER TABLE pet ADD CONSTRAINT FK_pet_pet_IdPai FOREIGN KEY (IdPai) REFERENCES pet(Id);

-- Indices for table `utilizador`
ALTER TABLE utilizador ADD CONSTRAINT PK_utilizador PRIMARY KEY (CC);

-- Indices for table `vacinas`
ALTER TABLE vacinas ADD CONSTRAINT PK_vacinas PRIMARY KEY (IdPet_Pet);

-- Indices for table `shelter`
ALTER TABLE shelter ADD CONSTRAINT PK_shelter PRIMARY KEY (Contacto);

-- Indices for table `adotante`
ALTER TABLE adotante ADD CONSTRAINT PK_adotante PRIMARY KEY (CC);

-- Indices for table `cat`
ALTER TABLE cat ADD CONSTRAINT PK_cat PRIMARY KEY (IdCat);

-- Indices for table `dog`
ALTER TABLE dog ADD CONSTRAINT PK_dog PRIMARY KEY (IdDog);

-- Indices for table `tratamentos`
ALTER TABLE tratamentos ADD CONSTRAINT PK_tratamentos PRIMARY KEY (IdPet_Pet_Pet);

-- Indices for table `adocoes`
ALTER TABLE adocoes ADD CONSTRAINT PK_adocoes PRIMARY KEY (IdAdocao);
ALTER TABLE adocoes ADD CONSTRAINT FK_adocoes_pet FOREIGN KEY (IdPet) REFERENCES pet(Id);
ALTER TABLE adocoes ADD CONSTRAINT FK_adocoes_adotante FOREIGN KEY (CCAdotante) REFERENCES adotante(CC);

-- Indices for table `empregado`
ALTER TABLE empregado ADD CONSTRAINT PK_empregado PRIMARY KEY (IdTrabalho);
ALTER TABLE empregado ADD CONSTRAINT FK_empregado_utilizador FOREIGN KEY (CC) REFERENCES utilizador(CC);




-- Constraints for table `adotante`
ALTER TABLE adotante ADD CONSTRAINT FK_adotante_utilizador FOREIGN KEY (CC) REFERENCES utilizador(CC);

-- Constraints for table `cat`
ALTER TABLE cat ADD CONSTRAINT FK_cat_pet FOREIGN KEY (IdCat) REFERENCES pet(Id);

-- Constraints for table `dog`
ALTER TABLE dog ADD CONSTRAINT FK_dog_pet FOREIGN KEY (IdDog) REFERENCES pet(Id);


-- Constraints for table `tratamentos`
ALTER TABLE tratamentos ADD CONSTRAINT FK_tratamentos_pet FOREIGN KEY (IdPet_Pet_Pet) REFERENCES pet(Id);

-- Constraints for table `vacinas`
ALTER TABLE vacinas ADD CONSTRAINT FK_vacinas_pet FOREIGN KEY (IdPet_Pet) REFERENCES pet(Id);