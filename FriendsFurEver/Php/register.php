<?php
    $servername = "localhost";
    $username = "root";
    $password = "";
    $dbname = "friendsfurever";
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

        $stmt = $conn->prepare("insert into utilizador(cc,Pass) values(?,?)");
        $stmt->bind_param("ss", $cc, $hashed_password);
        $execval = $stmt->execute();
        echo $execval;
        echo "Registration successfully...";
        header("Location: ../Html/login.html");
        $stmt->close();
        $conn->close();
    }
?>