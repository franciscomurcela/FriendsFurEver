-- Function GetTotalPetsInShelter
CREATE FUNCTION GetTotalPetsInShelter ()
RETURNS INT AS
BEGIN
    DECLARE @totalPets INT;
    SELECT @totalPets = COUNT(*)
    FROM Pet;
    RETURN @totalPets;
END;
GO

-- Function MostCommonPetBreedInShelter
CREATE FUNCTION MostCommonPetBreedInShelter ()
RETURNS VARCHAR(255) AS
BEGIN
    DECLARE @mostCommonBreed VARCHAR(255);
    SELECT TOP 1 @mostCommonBreed = Raca
    FROM (
        SELECT Raca FROM Dog
        UNION ALL 
        SELECT Raca FROM Cat
    ) AS PetRaca
    GROUP BY Raca
    ORDER BY COUNT(*) DESC;
    RETURN @mostCommonBreed;
END;
GO

-- Function PercentageAdoptedPetsInShelter
CREATE FUNCTION PercentageAdoptedPetsInShelter ()
RETURNS FLOAT AS
BEGIN
    DECLARE @totalPets FLOAT;
    DECLARE @totalAdoptedPets FLOAT;
    SELECT @totalPets = COUNT(*)
    FROM Pet;

    SELECT @totalAdoptedPets = COUNT(*)
    FROM Pet
    WHERE EstadoDeAdocao = 1;

    RETURN (@totalAdoptedPets / @totalPets) * 100;
END;
GO

-- Function TotalAdoptedPetsInShelter
CREATE FUNCTION TotalAdoptedPetsInShelter ()
RETURNS INT AS
BEGIN
    DECLARE @totalAdoptedPets INT;
    SELECT @totalAdoptedPets = COUNT(*)
    FROM Pet
    WHERE EstadoDeAdocao = 1;
    RETURN @totalAdoptedPets;
END;
GO

-- Function TotalEmployeesInShelter
CREATE FUNCTION TotalEmployeesInShelter ()
RETURNS INT AS
BEGIN
    DECLARE @totalEmployees INT;
    SELECT @totalEmployees = COUNT(*)
    FROM Empregado;
    RETURN @totalEmployees;
END;
GO