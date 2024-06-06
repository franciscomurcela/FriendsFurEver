<?php
    $servername = "localhost";
    $username = "root";
    $password = "";
    $dbname = "friendsfurever";

    try {
        $conn = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);

        $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            // Check if the Id exists in the 'vacinas' table
            $stmt = $conn->prepare("SELECT * FROM vacinas WHERE IdPet_Pet = :id");
            $stmt->bindParam(':id', $_POST['Id']);
            $stmt->execute();
            $vacinasExists = $stmt->fetch(PDO::FETCH_ASSOC);

            // If the Id exists, update the record. Otherwise, insert a new record
            if ($vacinasExists) {
                $stmt = $conn->prepare("
                    UPDATE vacinas 
                    SET Leishmaniose = :Leishmaniose, Gripe = :Gripe, Raiva = :Raiva 
                    WHERE IdPet_Pet = :Id
                ");
            } else {
                $stmt = $conn->prepare("
                    INSERT INTO vacinas (IdPet_Pet, Leishmaniose, Gripe, Raiva) 
                    VALUES (:Id, :Leishmaniose, :Gripe, :Raiva)
                ");
            }

            $stmt->bindParam(':Leishmaniose', $_POST['Leishmaniose']);
            $stmt->bindParam(':Gripe', $_POST['Gripe']);
            $stmt->bindParam(':Raiva', $_POST['Raiva']);
            $stmt->bindParam(':Id', $_POST['Id']);
            $stmt->execute();

            // Repeat the same process for the 'tratamentos' table
            $stmt = $conn->prepare("SELECT * FROM tratamentos WHERE IdPet_Pet_Pet = :Id");
            $stmt->bindParam(':Id', $_POST['Id']);
            $stmt->execute();
            $tratamentosExists = $stmt->fetch(PDO::FETCH_ASSOC);

            if ($tratamentosExists) {
                $stmt = $conn->prepare("
                    UPDATE tratamentos 
                    SET Desparasitado = :desparasitado, Esterilizado = :esterilizado 
                    WHERE IdPet_Pet_Pet = :id
                ");
            } else {
                $stmt = $conn->prepare("
                    INSERT INTO tratamentos (IdPet_Pet_Pet, Desparasitado, Esterilizado) 
                    VALUES (:id, :desparasitado, :esterilizado)
                ");
            }

            $stmt->bindParam(':desparasitado', $_POST['Desparasitado']);
            $stmt->bindParam(':esterilizado', $_POST['Esterilizado']);
            $stmt->bindParam(':id', $_POST['Id']);
            $stmt->execute();

            echo json_encode(['message' => 'Data updated successfully']);
        }
    } catch(PDOException $e) {
        echo "Error: " . $e->getMessage();
    }

    $conn = null;
?>