<?php

    $servername = "localhost";
    $username = "root";
    $password = "";
    $dbname = "friendsfurever";
    $pdo = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);

    $cc = $_POST['cc'];

    $id = $_POST['Id'];

    $stmt = $pdo->prepare("SELECT * FROM utilizador, adotante WHERE utilizador.CC = :cc AND adotante.CC = :cc");
    $stmt->bindParam(':cc', $cc);
    $stmt->execute();

    $user = $stmt->fetch(PDO::FETCH_ASSOC);

    // Check if all the columns are filled
    $allColumnsFilled = true;
    foreach ($user as $key => $value) {
        if (is_null($value)) {
            $allColumnsFilled = false;
            break;
        }
    }

    // If all the columns are filled, insert the ID and CC into the adocoes table
    if ($allColumnsFilled) {
        $stmt = $pdo->prepare("INSERT INTO adocoes (IdPet, CCAdotante, EstadoAdocaoPet) VALUES (:Id, :CC, 1)");
        $stmt->bindParam(':Id', $id);
        $stmt->bindParam(':CC', $cc);
        $stmt->execute();

        // Update the pet table
        $stmt = $pdo->prepare("UPDATE pet SET EstadoDeAdocao = 1 WHERE Id = :Id");
        $stmt->bindParam(':Id', $id);
        $stmt->execute();
    }
?>