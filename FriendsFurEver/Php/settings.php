<?php
    var_dump($_POST);
    
    $servername = "localhost";
    $username = "root";
    $password = "";
    $dbname = "friendsfurever";
    $cc = $_POST['cc'];
    $nome = $_POST['nome']; 
    $morada = $_POST['morada']; 
    $contacto = $_POST['contacto']; 
    $idade = $_POST['idade']; 
    $emprego = $_POST['emprego']; 
    $email = $_POST['email']; 

    $conn = new mysqli('localhost','root','','friendsfurever');
    if($conn->connect_error){
        echo "$conn->connect_error";
        die("Connection Failed : ". $conn->connect_error);
    } else {
        $stmt = $conn->prepare("SELECT cc FROM utilizador WHERE cc = ?");
        $stmt->bind_param("s", $cc);
        $stmt->execute();
        $result = $stmt->get_result();

        if ($result->num_rows > 0) {
            $stmt = $conn->prepare("UPDATE utilizador SET nome = ?, morada = ?, contacto = ?, email = ? WHERE cc = ?");
            $stmt->bind_param("ssiss", $nome, $morada, $contacto, $email, $cc);
            $execval = $stmt->execute();
            echo $execval;
            echo "Update successfully...";
        } else {
            echo "CC does not exist in the utilizador table.";
        }


        $stmt = $conn->prepare("SELECT cc FROM utilizador WHERE cc = ?");
        $stmt->bind_param("s", $cc);
        $stmt->execute();
        $result = $stmt->get_result();

        if ($result->num_rows > 0) {
            $stmt = $conn->prepare("SELECT CC FROM adotante WHERE CC = ?");
            $stmt->bind_param("s", $cc);
            $stmt->execute();
            $result = $stmt->get_result();

            if ($result->num_rows > 0) {
                $stmt = $conn->prepare("UPDATE adotante SET idade = ?, emprego = ? WHERE CC = ?");
                $stmt->bind_param("iss", $idade, $emprego, $cc);
                $execval = $stmt->execute();
                echo $execval;
                echo "Update successfully...";
            } else {
                $stmt = $conn->prepare("INSERT INTO adotante(idade, emprego, CC) VALUES (?, ?, ?)");
                $stmt->bind_param("iss", $idade, $emprego, $cc);
                $execval = $stmt->execute();
                echo $execval;
                echo "Registration successfully...";
            }
            header("Location: ../Html/home.html");
        } else {
            echo "CC does not exist in the utilizador table.";
        }

        $stmt->close();
        $conn->close();
    }
?>