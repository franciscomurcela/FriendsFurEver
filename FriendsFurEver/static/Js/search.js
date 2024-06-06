document.querySelector('input[name="search"]').addEventListener('input', function() {
    var xhr = new XMLHttpRequest();
    xhr.open('POST', '/search', true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    xhr.onload = function() {
        if (this.status == 200) {
            console.log(this.responseText);
            var users = JSON.parse(this.responseText);
            var userContainer = document.querySelector('.user-container');
            userContainer.innerHTML = '';
            users.forEach(function(user) {
                var userElement = document.createElement('div');
                userElement.innerHTML = `
                    <div class="user">
                        <p>Nome: ${user.NomeUser} CC: ${user.CC} ID Pet: ${user.idPet} Nome Pet: ${user.NomePet}</p>
                    </div>
                `;
                userContainer.appendChild(userElement);
            });
        }
    };
    xhr.send('query=' + this.value);
});