<?php
    var_dump($_POST);
    
    $servername = "localhost";
    $username = "root";
    $password = "";
    $dbname = "friendsfurever";
    $idtrabalho = $_POST['idtrabalho'];
    $password1 = $_POST['password']; 

    $conn = new mysqli('localhost','root','','friendsfurever');
    if($conn->connect_error){
        echo "$conn->connect_error";
        die("Connection Failed : ". $conn->connect_error);
    } else {
        $stmt = $conn->prepare("SELECT u.Pass FROM utilizador u INNER JOIN empregado e ON u.cc = e.cc WHERE e.idtrabalho = ?");
        $stmt->bind_param("s", $idtrabalho);
        $stmt->bind_result($hashed_password);
        $stmt->execute();
        $result = $stmt->get_result();
        $user = $result->fetch_assoc();
        if ($user && password_verify($password1, $user['Pass'])) {
            echo "Login successful...";
            header("Location: ../Html/homeempregado.html");
        } else {
            echo "Invalid credentials";
        }
        $stmt->close();
        $conn->close();
    }
?>