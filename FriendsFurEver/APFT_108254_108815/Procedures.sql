-- Procedure AuthenticateEmployee
CREATE PROCEDURE AuthenticateEmployee (@idtrabalho VARCHAR(255)) AS
BEGIN
    SELECT u.Pass 
    FROM utilizador u 
    INNER JOIN empregado e ON u.cc = e.cc 
    WHERE e.idtrabalho = @idtrabalho;
END;
GO

-- Procedure AuthenticateUser
CREATE PROCEDURE AuthenticateUser (@cc VARCHAR(255)) AS
BEGIN
    SELECT Pass 
    FROM utilizador 
    WHERE cc = @cc;
END;
GO

-- Procedure FetchPetDetails
CREATE PROCEDURE FetchPetDetails (@nome VARCHAR(255)) AS
BEGIN
    SELECT pet.*, COALESCE(dog.Nome, cat.Nome) as Nome, COALESCE(dog.Raca, cat.Raca) as Raca, COALESCE(dog.Idade, cat.Idade) as Idade
    FROM pet 
    LEFT JOIN dog ON pet.Id = dog.IdDog 
    LEFT JOIN cat ON pet.Id = cat.IdCat 
    WHERE COALESCE(dog.Nome, cat.Nome) = @nome;
END;
GO

-- Procedure FetchPets
CREATE PROCEDURE FetchPets (@filterOption VARCHAR(255)) AS
BEGIN
    IF @filterOption = 'option1' 
        SELECT dog.Nome, pet.img FROM pet JOIN dog ON pet.Id = dog.IdDog;
    ELSE IF @filterOption = 'option2' 
        SELECT cat.Nome, pet.img FROM pet JOIN cat ON pet.Id = cat.IdCat;
    ELSE IF @filterOption = 'option3' 
        SELECT dog.Nome, pet.img FROM pet JOIN dog ON pet.Id = dog.IdDog WHERE pet.Sexo = 'f'
        UNION SELECT cat.Nome, pet.img FROM pet JOIN cat ON pet.Id = cat.IdCat WHERE pet.Sexo = 'f';
    ELSE IF @filterOption = 'option4' 
        SELECT dog.Nome, pet.img FROM pet JOIN dog ON pet.Id = dog.IdDog WHERE pet.Sexo = 'm'
        UNION SELECT cat.Nome, pet.img FROM pet JOIN cat ON pet.Id = cat.IdCat WHERE pet.Sexo = 'm';
    ELSE IF @filterOption = 'option5' 
        SELECT dog.Nome, pet.img FROM pet JOIN dog ON pet.Id = dog.IdDog WHERE dog.idade < 4
        UNION SELECT cat.Nome, pet.img FROM pet JOIN cat ON pet.Id = cat.IdCat WHERE cat.idade < 4;
    ELSE IF @filterOption = 'option6' 
        SELECT dog.Nome, pet.img FROM pet JOIN dog ON pet.Id = dog.IdDog WHERE dog.idade BETWEEN 4 AND 7
        UNION SELECT cat.Nome, pet.img FROM pet JOIN cat ON pet.Id = cat.IdCat WHERE cat.idade BETWEEN 4 AND 7;
    ELSE IF @filterOption = 'option7' 
        SELECT dog.Nome, pet.img FROM pet JOIN dog ON pet.Id = dog.IdDog WHERE dog.idade > 7
        UNION SELECT cat.Nome, pet.img FROM pet JOIN cat ON pet.Id = cat.IdCat WHERE cat.idade > 7;
    ELSE
        SELECT dog.Nome, pet.img FROM pet JOIN dog ON pet.Id = dog.IdDog
        UNION SELECT cat.Nome, pet.img FROM pet JOIN cat ON pet.Id = cat.IdCat;
END;
GO

-- Procedure FetchPets2
CREATE PROCEDURE FetchPets2 AS
BEGIN
    SELECT dog.Nome, pet.img FROM pet JOIN dog ON pet.Id = dog.IdDog 
    UNION 
    SELECT cat.Nome, pet.img FROM pet JOIN cat ON pet.Id = cat.IdCat;
END;
GO

-- Procedure FetchPets3
CREATE PROCEDURE FetchPets3 AS
BEGIN
    SELECT dog.Nome, pet.img FROM pet JOIN dog ON pet.Id = dog.IdDog 
    UNION 
    SELECT cat.Nome, pet.img FROM pet JOIN cat ON pet.Id = cat.IdCat;
END;
GO

-- Procedure FetchUserDetails
CREATE PROCEDURE FetchUserDetails (@cc INT) AS
BEGIN
    SELECT * FROM utilizador, adotante WHERE utilizador.CC = @cc AND adotante.CC = @cc;
END;
GO

-- Procedure InsertIntoAdocoes
CREATE PROCEDURE InsertIntoAdocoes (@idPet INT, @ccAdotante INT) AS
BEGIN
    INSERT INTO adocoes (IdPet, CCAdotante) VALUES (@idPet, @ccAdotante);
END;
GO

-- Procedure InsertIntoCat
CREATE PROCEDURE InsertIntoCat (@idPet INT, @nome VARCHAR(255), @raca VARCHAR(255), @idade INT) AS
BEGIN
    INSERT INTO cat(IdCat, nome, raca, idade) 
    VALUES(@idPet, @nome, @raca, @idade);
END;
GO

-- Procedure InsertIntoDog
CREATE PROCEDURE InsertIntoDog (@idPet INT, @nome VARCHAR(255), @raca VARCHAR(255), @idade INT) AS
BEGIN
    INSERT INTO dog(IdDog, nome, raca, idade) 
    VALUES(@idPet, @nome, @raca, @idade);
END;
GO

-- Procedure InsertIntoPet
CREATE PROCEDURE InsertIntoPet (@estadoAdocao INT, @microchip INT, @comportamento INT, @idmae INT, @idpai INT, @sexo CHAR(1), @img VARCHAR(255), @idPet INT OUTPUT) AS
BEGIN
    INSERT INTO pet(EstadoDeAdocao, microchip, comportamento, IdMae, IdPai, sexo, img) 
    VALUES(@estadoAdocao, @microchip, @comportamento, @idmae, @idpai, @sexo, @img);
    
    SET @idPet = SCOPE_IDENTITY();
END;
GO

-- Procedure RegisterAdotante
CREATE PROCEDURE RegisterAdotante (@idade INT, @emprego VARCHAR(255), @cc VARCHAR(255)) AS
BEGIN
    INSERT INTO adotante(idade, emprego, CC) VALUES(@idade, @emprego, @cc);
END;
GO

-- Procedure RegisterEmployee
CREATE PROCEDURE RegisterEmployee (@idtrabalho VARCHAR(255), @cc VARCHAR(255)) AS
BEGIN
    INSERT INTO empregado(idtrabalho, cc) VALUES(@idtrabalho, @cc);
END;
GO

-- Procedure RegisterUser
CREATE PROCEDURE RegisterUser (@cc VARCHAR(255), @hashed_password VARCHAR(255)) AS
BEGIN
    INSERT INTO utilizador(cc, Pass) VALUES(@cc, @hashed_password);
END;
GO

-- Procedure RegisterUser2
CREATE PROCEDURE RegisterUser2 (@cc VARCHAR(255), @hashed_password VARCHAR(255)) AS
BEGIN
    INSERT INTO utilizador(cc, Pass) VALUES(@cc, @hashed_password);
END;
GO

-- Procedure RemoveCat
CREATE PROCEDURE RemoveCat (@petId INT) AS
BEGIN
    DELETE FROM cat WHERE IdCat = @petId;
END;
GO

-- Procedure RemoveDog
CREATE PROCEDURE RemoveDog (@petId INT) AS
BEGIN
    DELETE FROM dog WHERE IdDog = @petId;
END;
GO

-- Procedure RemovePet
CREATE PROCEDURE RemovePet (@petId INT) AS
BEGIN
    DELETE FROM pet WHERE Id = @petId;
END;
GO

CREATE PROCEDURE sp_UpdateHealthStatus (@petId INT) AS
BEGIN
    DECLARE @vaccinationStatus BIT;
    DECLARE @treatmentStatus BIT;

    -- Check if the pet has received all its vaccinations
    SELECT @vaccinationStatus = CASE WHEN Leishmaniose = 1 AND Gripe = 1 AND Raiva = 1 THEN 1 ELSE 0 END
    FROM Vacinas
    WHERE IdPet_Pet = @petId;

    -- Check if the pet has received all its treatments
    SELECT @treatmentStatus = CASE WHEN Desparasitado = 1 AND Esterilizado = 1 THEN 1 ELSE 0 END
    FROM Tratamentos
    WHERE IdPet_Pet_Pet = @petId;

    -- If the pet has received all its vaccinations and treatments, update its health status
    IF @vaccinationStatus = 1 AND @treatmentStatus = 1 
    BEGIN
        UPDATE Pet
        SET Healthy = 1
        WHERE Id = @petId;
    END;
END;
GO

-- Procedure UpdateAdotante
CREATE PROCEDURE UpdateAdotante (@cc VARCHAR(255), @idade INT, @emprego VARCHAR(255)) AS
BEGIN
    UPDATE adotante SET idade = @idade, emprego = @emprego WHERE CC = @cc;
END;
GO

-- Procedure UpdateCat
CREATE PROCEDURE UpdateCat (@Id INT, @Nome VARCHAR(255), @Raca VARCHAR(255), @Idade INT) AS
BEGIN
    UPDATE cat
    SET Nome = @Nome, Raca = @Raca, Idade = @Idade
    WHERE IdCat = @Id;
END;
GO

-- Procedure UpdateDog
CREATE PROCEDURE UpdateDog (@Id INT, @Nome VARCHAR(255), @Raca VARCHAR(255), @Idade INT) AS
BEGIN
    UPDATE dog
    SET Nome = @Nome, Raca = @Raca, Idade = @Idade
    WHERE IdDog = @Id;
END;
GO

-- Procedure UpdateOrInsertTratamentos
CREATE PROCEDURE UpdateOrInsertTratamentos (@id INT, @desparasitado INT, @esterilizado INT) AS
BEGIN
    IF EXISTS (SELECT 1 FROM tratamentos WHERE IdPet_Pet_Pet = @id)
    BEGIN
        UPDATE tratamentos 
        SET Desparasitado = @desparasitado, Esterilizado = @esterilizado 
        WHERE IdPet_Pet_Pet = @id;
    END
    ELSE
    BEGIN
        INSERT INTO tratamentos (IdPet_Pet_Pet, Desparasitado, Esterilizado) 
        VALUES (@id, @desparasitado, @esterilizado);
    END;
END;
GO

-- Procedure UpdateOrInsertVacinas
CREATE PROCEDURE UpdateOrInsertVacinas (@id INT, @leishmaniose INT, @gripe INT, @raiva INT) AS
BEGIN
    IF EXISTS (SELECT 1 FROM vacinas WHERE IdPet_Pet = @id)
    BEGIN
        UPDATE vacinas 
        SET Leishmaniose = @leishmaniose, Gripe = @gripe, Raiva = @raiva 
        WHERE IdPet_Pet = @id;
    END
    ELSE
    BEGIN
        INSERT INTO vacinas (IdPet_Pet, Leishmaniose, Gripe, Raiva) 
        VALUES (@id, @leishmaniose, @gripe, @raiva);
    END;
END;
GO

-- Procedure UpdatePet
CREATE PROCEDURE UpdatePet (@Id INT, @Sexo CHAR(1), @EstadoDeAdocao VARCHAR(255), @Comportamento VARCHAR(255), @Microchip INT, @Img VARCHAR(255), @Healthy INT, @IdMae INT, @IdPai INT) AS
BEGIN
    UPDATE pet
    SET Sexo = @Sexo, EstadoDeAdocao = @EstadoDeAdocao, Comportamento = @Comportamento, Microchip = @Microchip, Img = @Img, Healthy = @Healthy, IdMae = @IdMae, IdPai = @IdPai 
    WHERE Id = @Id;
END;
GO

-- Procedure UpdateUser
CREATE PROCEDURE UpdateUser (@cc VARCHAR(255), @nome VARCHAR(255), @morada VARCHAR(255), @contacto INT, @email VARCHAR(255)) AS
BEGIN
    UPDATE utilizador SET nome = @nome, morada = @morada, contacto = @contacto, email = @email WHERE cc = @cc;
END;
GO