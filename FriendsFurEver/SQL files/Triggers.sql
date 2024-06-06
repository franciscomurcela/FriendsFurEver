-- Trigger trg_CheckAdoption
CREATE TRIGGER trg_CheckAdoption
ON adocoes
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Pet INNER JOIN inserted ON Pet.Id = inserted.IdPet WHERE Pet.EstadoDeAdocao = 1)
    BEGIN
        RAISERROR ('This pet is already adopted', 16, 1);
        RETURN;
    END
    INSERT INTO adocoes SELECT * FROM inserted;
END;
GO

-- Trigger trg_UpdateEstadoDeAdocao
CREATE TRIGGER trg_UpdateEstadoDeAdocao
ON adocoes
AFTER INSERT
AS
BEGIN
    UPDATE Pet 
    SET EstadoDeAdocao = 1 
    WHERE Pet.Id IN (SELECT IdPet FROM inserted);
END;
GO


-- Trigger trg_UpdateHealthyAfterTratamentos
CREATE TRIGGER trg_UpdateHealthyAfterTratamentos
ON tratamentos
AFTER UPDATE
AS
BEGIN
    UPDATE Pet 
    SET healthy = 1 
    WHERE Pet.Id IN (SELECT IdPet_Pet_Pet FROM inserted WHERE Desparasitado = 1 AND Esterilizado = 1);
END;
GO

-- Trigger trg_UpdateHealthyStatus
CREATE TRIGGER trg_UpdateHealthyStatus
ON tratamentos
AFTER INSERT
AS
BEGIN
    UPDATE Pet
    SET Healthy = 
        CASE 
            WHEN inserted.Desparasitado = 1 AND inserted.Esterilizado = 1 THEN 1
            ELSE 0
        END
    FROM Pet
    INNER JOIN inserted ON Pet.Id = inserted.IdPet_Pet_Pet;
END;
GO


-- Trigger trg_UpdateHealthyAfterVacinas
CREATE TRIGGER trg_UpdateHealthyAfterVacinas
ON vacinas
AFTER UPDATE
AS
BEGIN
    UPDATE Pet 
    SET healthy = 1 
    WHERE Pet.Id IN (SELECT IdPet_Pet FROM inserted WHERE Leishmaniose = 1 AND Gripe = 1 AND Raiva = 1);
END;
GO