<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "friendsfurever";

try {
    $db = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
    $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    $petId = $_POST['id'];

    $stmt = $db->prepare("DELETE FROM dog WHERE IdDog = :id");
    $stmt->bindParam(':id', $petId);
    $stmt->execute();

    $stmt = $db->prepare("DELETE FROM cat WHERE IdCat = :id");
    $stmt->bindParam(':id', $petId);
    $stmt->execute();

    $stmt = $db->prepare("DELETE FROM pet WHERE Id = :id");
    $stmt->bindParam(':id', $petId);
    $stmt->execute();

    echo 'success';
} catch (Exception $e) {
    http_response_code(500);
    echo 'Error: ' . $e->getMessage();
}
?>