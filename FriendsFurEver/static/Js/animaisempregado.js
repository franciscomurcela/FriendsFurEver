function loadAnimals(filter) {
    var xhr = new XMLHttpRequest();
    xhr.open('POST', '/animaisempregado', true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    xhr.onload = function() {
        if (this.status == 200) {
            var pets = JSON.parse(this.responseText);
            var petContainer = document.querySelector('.animal-container');
            petContainer.innerHTML = '';
            pets.forEach(function(pet) {
                var petElement = document.createElement('a');
                petElement.innerHTML = `
                    <a href="/manageanimal?nome=${pet.Nome}">
                    <div class="group">
                        <img class="img" src="${pet.img}" />
                        <div class="text-wrapper">${pet.Nome}</div>
                    </div>
                    </a>
                `;
                petContainer.appendChild(petElement);
            });
        }
    };
    xhr.send('filter=' + filter);
}

// Create a new container for the animals
var animalContainer = document.createElement('div');
animalContainer.className = 'animal-container';
document.querySelector('.flex-container').appendChild(animalContainer);

// Load all animals when the page loads
loadAnimals('all');

// Update the animals when the filter changes
document.getElementById('filter').addEventListener('change', function() {
    loadAnimals(this.value);
});