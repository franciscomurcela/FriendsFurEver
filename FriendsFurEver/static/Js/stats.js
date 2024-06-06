document.addEventListener("DOMContentLoaded", function() {
    fetch('/stats')
        .then(response => response.json())
        .then(data => {
            document.getElementById('totalPets').textContent += ` ${data.totalPets}`;
            document.getElementById('totalAdoptedPets').textContent += ` ${data.totalAdoptedPets}`;
            document.getElementById('totalEmployees').textContent += ` ${data.totalEmployees}`;
            document.getElementById('percentageAdoptedPets').textContent += ` ${data.percentageAdoptedPets}%`;
            document.getElementById('mostCommonBreed').textContent += ` ${data.mostCommonBreed}`;
        })
        .catch(error => console.error('Error fetching data:', error));
});

