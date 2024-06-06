<?php
    $servername = "localhost";
    $username = "root";
    $password = "";
    $dbname = "friendsfurever";

    try {
        $conn = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);

        $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

        $stmt = $conn->prepare("
            SELECT pet.*, COALESCE(dog.Nome, cat.Nome) as Nome, COALESCE(dog.Raca, cat.Raca) as Raca, COALESCE(dog.Idade, cat.Idade) as Idade, 
            vacinas.Leishmaniose, vacinas.Gripe, vacinas.Raiva, tratamentos.Desparasitado, tratamentos.Esterilizado
            FROM pet 
            LEFT JOIN dog ON pet.Id = dog.IdDog 
            LEFT JOIN cat ON pet.Id = cat.IdCat 
            LEFT JOIN vacinas ON pet.Id = vacinas.IdPet_Pet
            LEFT JOIN tratamentos ON pet.Id = tratamentos.IdPet_Pet_Pet
            WHERE COALESCE(dog.Nome, cat.Nome) = :nome
        ");

        $stmt->bindParam(':nome', $_GET['nome']);

        $stmt->execute();


        $pet = $stmt->fetch(PDO::FETCH_ASSOC);

        echo json_encode($pet);
    } catch(PDOException $e) {
        echo "Error: " . $e->getMessage();
    }

    $conn = null;
?>