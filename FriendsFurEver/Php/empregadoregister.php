<?php
    $servername = "localhost";
    $username = "root";
    $password = "";
    $dbname = "friendsfurever";
    $idtrabalho = $_POST['idtrabalho'];
    $cc = $_POST['cc'];
    $password1 = $_POST['password']; 
    $passwordvalidate = $_POST['passwordvalidate'];

    $conn = new mysqli('localhost','root','','friendsfurever');
    if($conn->connect_error){
        echo "$conn->connect_error";
        die("Connection Failed : ". $conn->connect_error);
    } else {
        if($password1 != $passwordvalidate) {
            echo "Passwords do not match";
            exit();
        }
        $hashed_password = password_hash($password1, PASSWORD_DEFAULT);

        $stmt = $conn->prepare("INSERT INTO utilizador(cc,Pass) VALUES(?,?)");
        $stmt->bind_param("ss", $cc, $hashed_password);
        $execval = $stmt->execute();
        echo $execval;
        echo "Registration successfully...";

        $stmt = $conn->prepare("INSERT INTO empregado(idtrabalho, cc) VALUES(?,?)");
        $stmt->bind_param("ss", $idtrabalho, $cc);
        $execval = $stmt->execute();
        echo $execval;
        echo "Employee added successfully...";

        header("Location: ../Html/empregadologin.html");
        $stmt->close();
        $conn->close();
    }
?>