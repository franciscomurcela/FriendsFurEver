<?php
    error_reporting(E_ALL);
    ini_set('display_errors', 1);
    $serverNome = "localhost";
    $userNome = "root";
    $password = "";
    $dbNome = "friendsfurever";

    $filter = $_POST['filter'];
    $page = isset($_POST['page']) ? $_POST['page'] : 1;
    $recordsPerPage = isset($_POST['recordsPerPage']) ? $_POST['recordsPerPage'] : 8;
    $offset = ($page - 1) * $recordsPerPage;

    $conn = new mysqli($serverNome, $userNome, $password, $dbNome);

    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }

    if ($filter == "option1") {
        $sql = "SELECT dog.Nome, pet.img FROM pet JOIN dog ON pet.Id = dog.IdDog LIMIT $offset, $recordsPerPage";
    } elseif ($filter == "option2") {
        $sql = "SELECT cat.Nome, pet.img FROM pet JOIN cat ON pet.Id = cat.IdCat LIMIT $offset, $recordsPerPage";
    } elseif ($filter == "option3") {
        $sql = "SELECT dog.Nome, pet.img FROM pet JOIN dog ON pet.Id = dog.IdDog WHERE pet.Sexo = 'f' UNION SELECT cat.Nome, pet.img FROM pet JOIN cat ON pet.Id = cat.IdCat WHERE pet.Sexo = 'f' LIMIT $offset, $recordsPerPage";
    } elseif ($filter == "option4") {
        $sql = "SELECT dog.Nome, pet.img FROM pet JOIN dog ON pet.Id = dog.IdDog WHERE pet.Sexo = 'm' UNION SELECT cat.Nome, pet.img FROM pet JOIN cat ON pet.Id = cat.IdCat WHERE pet.Sexo = 'm' LIMIT $offset, $recordsPerPage";
    } elseif ($filter == "option5") {
        $sql = "SELECT dog.Nome, pet.img FROM pet JOIN dog ON pet.Id = dog.IdDog WHERE dog.idade < 4 UNION SELECT cat.Nome, pet.img FROM pet JOIN cat ON pet.Id = cat.IdCat WHERE cat.idade < 4 LIMIT $offset, $recordsPerPage";
    } elseif ($filter == "option6") {
        $sql = "SELECT dog.Nome, pet.img FROM pet JOIN dog ON pet.Id = dog.IdDog WHERE dog.idade BETWEEN 4 AND 7 UNION SELECT cat.Nome, pet.img FROM pet JOIN cat ON pet.Id = cat.IdCat WHERE cat.idade BETWEEN 4 AND 7 LIMIT $offset, $recordsPerPage";
    } elseif ($filter == "option7") {
        $sql = "SELECT dog.Nome, pet.img FROM pet JOIN dog ON pet.Id = dog.IdDog WHERE dog.idade > 7 UNION SELECT cat.Nome, pet.img FROM pet JOIN cat ON pet.Id = cat.IdCat WHERE cat.idade > 7 LIMIT $offset, $recordsPerPage";
    } else {
        $sql = "SELECT dog.Nome, pet.img FROM pet JOIN dog ON pet.Id = dog.IdDog UNION SELECT cat.Nome, pet.img FROM pet JOIN cat ON pet.Id = cat.IdCat LIMIT $offset, $recordsPerPage";
    }


    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        $pets = $result->fetch_all(MYSQLI_ASSOC);
    } else {
        $pets = array();
    }

    echo json_encode($pets);

    $conn->close();
?>