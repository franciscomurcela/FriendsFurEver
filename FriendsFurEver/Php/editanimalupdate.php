<?php
    $dbHost     = 'localhost';
    $dbUsername = 'root';
    $dbPassword = '';
    $dbName     = 'friendsfurever';

    $db = new PDO("mysql:host=$dbHost;dbname=$dbName", $dbUsername, $dbPassword);

    $updatedPet = $_POST;
    echo 'Received data: ' . print_r($_POST, true) . '<br>';
    $stmt = $db->prepare("
        UPDATE pet
        SET Sexo = :Sexo, EstadoDeAdocao = :EstadoDeAdocao, Comportamento = :Comportamento, Microchip = :Microchip, Img = :Img, Healthy = :Healthy, IdMae = :IdMae, IdPai = :IdPai 
        WHERE Id = :Id
    ");
    
    $stmt->bindParam(':Sexo', $updatedPet['Sexo']);
    $stmt->bindParam(':EstadoDeAdocao', $updatedPet['EstadoDeAdocao']);
    $stmt->bindParam(':Comportamento', $updatedPet['Comportamento']);
    $stmt->bindParam(':Microchip', $updatedPet['Microchip']);
    $stmt->bindParam(':Img', $updatedPet['Img']);
    $stmt->bindParam(':Healthy', $updatedPet['Healthy']);

    $IdMae = !empty($updatedPet['IdMae']) ? $updatedPet['IdMae'] : NULL;
    $IdPai = !empty($updatedPet['IdPai']) ? $updatedPet['IdPai'] : NULL;
    $stmt->bindParam(':IdMae', $IdMae);
    $stmt->bindParam(':IdPai', $IdPai);

    $stmt->bindParam(':Id', $updatedPet['Id']);
    $stmt->execute();

    // Check if the pet is a dog
    $stmt = $db->prepare("SELECT * FROM dog WHERE IdDog = :Id");
    $stmt->bindParam(':Id', $updatedPet['Id']);
    $stmt->execute();
    if ($stmt->fetch()) {
        $stmt = $db->prepare("
            UPDATE dog
            SET Nome = :Nome, Raca = :Raca, Idade = :Idade
            WHERE IdDog = :Id
        ");
        bindParameters($stmt, $updatedPet);
        $stmt->execute();
    } else {
        $stmt = $db->prepare("
            UPDATE cat
            SET Nome = :Nome, Raca = :Raca, Idade = :Idade
            WHERE IdCat = :Id
        ");
        bindParameters($stmt, $updatedPet);
        $stmt->execute();
    }

    function bindParameters($stmt, $updatedPet) {
        $stmt->bindParam(':Nome', $updatedPet['Nome']);
        $stmt->bindParam(':Raca', $updatedPet['Raca']);
        $stmt->bindParam(':Idade', $updatedPet['Idade']);
        $stmt->bindParam(':Id', $updatedPet['Id']);
    }

    
    echo 'SQL query: ' . $stmt->queryString . '<br>';
    echo 'Parameters: ' . print_r($updatedPet, true) . '<br>';
    echo 'Pet updated successfully.';
?>  




