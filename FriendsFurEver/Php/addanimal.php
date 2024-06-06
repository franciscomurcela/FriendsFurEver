<?php
    var_dump($_POST);
    
    $servername = "localhost";
    $username = "root";
    $password = "";
    $dbname = "friendsfurever";
    
    
    $nome = $_POST['nome'];
    $raca = $_POST['raca'];
    $sexo = $_POST['sexo'];

    $estadoAdocao = isset($_POST['estadoAdocao']) ? 1 : 0;
    $microchip = isset($_POST['microchip']) ? 1 : 0;
    $tipo = isset($_POST['tipo']) ? 1 : 0;

    $idade = $_POST['idade'];
    $idmae = isset($_POST['idMae']) && $_POST['idMae'] !== '' ? $_POST['idMae'] : NULL;
    $idpai = isset($_POST['idPai']) && $_POST['idPai'] !== '' ? $_POST['idPai'] : NULL;
    $img = $_POST['img'];
    $comportamento = $_POST['comportamento'];


    $conn = new mysqli('localhost','root','','friendsfurever');
    if($conn->connect_error){
        echo "$conn->connect_error";
        die("Connection Failed : ". $conn->connect_error);
    } else {
             
            if ($idmae !== NULL && $idmae !== '') {
                $result = $conn->query("SELECT Id FROM pet WHERE Id = $idmae");
                if ($result->num_rows == 0) {
                    die("Error: IdMae does not exist in the 'pet' table.");
                }
            }
            
            $stmt = $conn->prepare("INSERT INTO pet(EstadoDeAdocao,microchip,comportamento,IdMae,IdPai,sexo,img) values(?,?,?,?,?,?,?)");
            $stmt->bind_param("iisiiss", $estadoAdocao,$microchip,$comportamento,$idmae,$idpai,$sexo,$img);
            $execval = $stmt->execute();
            echo $execval;
            echo "Registration successful...";
            $idPet = $stmt->insert_id;


            if($tipo==1){
                $stmt = $conn->prepare("INSERT INTO dog(IdDog,nome,raca,idade) values(?,?,?,?)");
                $stmt->bind_param("issi", $idPet,$nome,$raca,$idade);
                $execval = $stmt->execute();
                echo $execval;
                echo "Dog Created...";
            } else{
                $stmt = $conn->prepare("INSERT INTO cat(IdCat,nome,raca,idade) values(?,?,?,?)");
                $stmt->bind_param("issi", $idPet,$nome,$raca,$idade);
                $execval = $stmt->execute();
                echo $execval;
                echo "Cat Created...";
            }
            
            header("Location: ../Html/animaisempregado.html");
            $stmt->close();
            $conn->close();
    }
?>