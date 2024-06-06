<?php
    error_reporting(E_ALL);
    ini_set('display_errors', 1);
    $serverNome = "localhost";
    $userNome = "root";
    $password = "";
    $dbNome = "friendsfurever";

    $filter = $_POST['filter'];

    $conn = new mysqli($serverNome, $userNome, $password, $dbNome);

    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }

    $sql = "SELECT dog.Nome, pet.img FROM pet JOIN dog ON pet.Id = dog.IdDog UNION SELECT cat.Nome, pet.img FROM pet JOIN cat ON pet.Id = cat.IdCat";
    
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        $pets = $result->fetch_all(MYSQLI_ASSOC);
    } else {
        $pets = array();
    }

    echo json_encode($pets);

    $conn->close();
?>