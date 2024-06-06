var currentPage = 1;
var recordsPerPage = 8;

function loadAnimals(filter, page = currentPage, recordsPerPage = recordsPerPage) {
    var xhr = new XMLHttpRequest();
    xhr.open('POST', '/animais', true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    xhr.onload = function() {
        if (this.status == 200) {
            var pets = JSON.parse(this.responseText);
            var petContainer = document.querySelector('.animal-container');
            petContainer.innerHTML = '';
            pets.forEach(function(pet) {
                var petElement = document.createElement('a');
                petElement.innerHTML = `
                    <a href="adotar?nome=${pet.Nome}">
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
    xhr.send('filter=' + filter + '&page=' + page + '&recordsPerPage=' + recordsPerPage);
}

// Load all animals when the page loads
loadAnimals('all', currentPage, recordsPerPage);

// Update the animals when the filter changes
document.getElementById('filter').addEventListener('change', function() {
    loadAnimals(this.value, currentPage, recordsPerPage);
});


document.addEventListener('DOMContentLoaded', (event) => {
    const paginationLinks = document.querySelectorAll('.pagination a');
    for (let i = 0; i < paginationLinks.length; i++) {
        paginationLinks[i].addEventListener('click', function(e) {
            e.preventDefault();
            currentPage = i + 1;
            loadAnimals(document.getElementById('filter').value, currentPage, recordsPerPage);
            for (let j = 0; j < paginationLinks.length; j++) {
                paginationLinks[j].classList.remove('active');
            }
            this.classList.add('active');
        });
    }
});