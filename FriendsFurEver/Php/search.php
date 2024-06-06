<?php
    $servername = "localhost";
    $username = "root";
    $password = "";
    $dbname = "friendsfurever";

    $conn = new mysqli($servername, $username, $password, $dbname);

    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }

    $query = $_POST['query'];

    
    $sql = "SELECT utilizador.Nome AS NomeUser, utilizador.CC, adocoes.idPet, COALESCE(cat.Nome, dog.Nome) AS NomePet
            FROM utilizador 
            JOIN adocoes ON utilizador.CC = adocoes.CCAdotante 
            LEFT JOIN cat ON adocoes.idPet = cat.idCat 
            LEFT JOIN dog ON adocoes.idPet = dog.idDog 
            WHERE utilizador.Nome LIKE ? OR utilizador.CC LIKE ?";


    if ($stmt = $conn->prepare($sql)) {
        $param = "%" . $query . "%";
        $stmt->bind_param("ss", $param, $param);

        if ($stmt->execute()) {
            $result = $stmt->get_result();

            $users = $result->fetch_all(MYSQLI_ASSOC);

            echo json_encode($users);
        }

        $stmt->close();
    }

    $conn->close();
?>