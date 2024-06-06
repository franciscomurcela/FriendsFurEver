document.getElementById('registerForm').addEventListener('submit', function(event) {
    var password = document.getElementById('password').value;
    var confirmPassword = document.getElementById('confirm_password').value;

    if (password != confirmPassword) {
        alert('Passwords do not match.');
        event.preventDefault(); 
    } else {
        event.preventDefault();
        var form = document.getElementById('registerForm');
        var formData = new FormData(form);
        fetch('/register', {method: 'POST', body: formData})
            .then(response => response.text())
            .then(data => window.location.href = '/home')
            .catch(error => console.error(error));
    }
});