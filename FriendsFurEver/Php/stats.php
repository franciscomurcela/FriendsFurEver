<?php
    $servername = "localhost";
    $username = "root";
    $password = "";
    $dbname = "friendsfurever";

    try {
        $conn = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
        $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

        $shelterId = 1; 

        $stmt = $conn->prepare("SELECT GetTotalPetsInShelter(:shelterId) AS totalPets");
        $stmt->bindParam(':shelterId', $shelterId);
        $stmt->execute();
        $totalPets = $stmt->fetch(PDO::FETCH_ASSOC)['totalPets'];

        $stmt = $conn->prepare("SELECT TotalAdoptedPetsInShelter(:shelterId) AS totalAdoptedPets");
        $stmt->bindParam(':shelterId', $shelterId);
        $stmt->execute();
        $totalAdoptedPets = $stmt->fetch(PDO::FETCH_ASSOC)['totalAdoptedPets'];

        $stmt = $conn->prepare("SELECT TotalEmployeesInShelter(:shelterId) AS totalEmployees");
        $stmt->bindParam(':shelterId', $shelterId);
        $stmt->execute();
        $totalEmployees = $stmt->fetch(PDO::FETCH_ASSOC)['totalEmployees'];

        $stmt = $conn->prepare("SELECT PercentageAdoptedPetsInShelter(:shelterId) AS percentageAdoptedPets");
        $stmt->bindParam(':shelterId', $shelterId);
        $stmt->execute();
        $percentageAdoptedPets = $stmt->fetch(PDO::FETCH_ASSOC)['percentageAdoptedPets'];

        $stmt = $conn->prepare("SELECT MostCommonPetBreedInShelter(:shelterId) AS mostCommonBreed");
        $stmt->bindParam(':shelterId', $shelterId);
        $stmt->execute();
        $mostCommonBreed = $stmt->fetch(PDO::FETCH_ASSOC)['mostCommonBreed'];

        echo json_encode([
            'totalPets' => $totalPets,
            'totalAdoptedPets' => $totalAdoptedPets,
            'totalEmployees' => $totalEmployees,
            'percentageAdoptedPets' => $percentageAdoptedPets,
            'mostCommonBreed' => $mostCommonBreed
        ]);

    } catch(PDOException $e) {
        echo "Error: " . $e->getMessage();
    }

    $conn = null;
?>
