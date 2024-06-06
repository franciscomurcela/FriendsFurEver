<?php
    
    $servername = "localhost";
    $username = "root";
    $password = "";
    $dbname = "friendsfurever";
    $cc = $_POST['cc'];
    $password1 = $_POST['password']; 

    $conn = new mysqli('localhost','root','','friendsfurever');
    if($conn->connect_error){
        echo "$conn->connect_error";
        die("Connection Failed : ". $conn->connect_error);
    } else {
        $stmt = $conn->prepare("SELECT Pass FROM utilizador WHERE cc = ?");
        $stmt->bind_param("s", $cc);
        $stmt->bind_result($hashed_password);
        $stmt->execute();
        $result = $stmt->get_result();
        $user = $result->fetch_assoc();
        if ($user && password_verify($password1, $user['Pass'])) {
            echo "Login successful...";
            header("Location: ../Html/home.html");
        } else {
            echo "Invalid credentials";
        }
        $stmt->close();
        $conn->close();
    }
?>