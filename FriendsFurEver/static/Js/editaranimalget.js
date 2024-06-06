// Get the URL parameters 
var urlParams = new URLSearchParams(window.location.search);
// Get the pet's id and nome from the URL parameters
var nome = urlParams.get('nome');
// Now you can use the id and nome variables in your code
var petId
// Make a request to your PHP script for the pet's details
$.ajax({
    url: '/editanimalget', // Replace with your actual PHP script
    type: 'GET',
    data: { nome: nome },
    dataType: 'json',
    success: function(pet) {
        // Log the returned pet object to the console
        console.log(pet);
        $('#Nome').val(pet.Nome);
        $('#Id').val(pet.Id);
        $('#raca').val(pet.Raca);
        $('#Idade').val(pet.Idade);
        $('#Sexo').val(pet.Sexo);
        $('#adocao').val(pet.EstadoDeAdocao);
        $('#comportamento').val(pet.Comportamento);
        $('#microchip').val(pet.Microchip);
        $('#sexo').val(pet.Sexo);
        $('#imgpet').attr('src', pet.Img);
        $('#Healthy').val(pet.Healthy);
        $('#img').val(pet.Img);
        $('#Leishmaniose').val(pet.Leishmaniose);
        $('#Gripe').val(pet.Gripe);
        $('#Raiva').val(pet.Raiva);
        $('#Desparasitado').val(pet.Desparasitado);
        $('#Esterilizado').val(pet.Esterilizado);

        petId = pet.Id;

        if (pet.IdMae != null){
            $('#idmae').val(pet.IdMae);
        }

        if (pet.IdPai != null){
            $('#idpai').val(pet.IdPai);
        }

    },
    error: function(jqXHR, textStatus, errorThrown) {
        $('#pet-details').html('<p>An error occurred.</p>');
        console.error('Error:', textStatus, errorThrown);
    }
});





$('#tratamentosform').on('submit', function(e) {
    e.preventDefault();

    $.ajax({
        url: '/tratamentos_api',
        type: 'POST',
        data: $('#tratamentosform').serialize(),
        success: function(response) {
            // Handle the response from the server
            console.log('Server response:', response);
            var result = response;
            if (result.message === 'Data updated successfully') {
                console.log('Redirecting to /settingsempregado');
                window.location.href = '/settingsempregado';
            } else {
                alert('An error occurred while updating the data.');
            }
        },
        error: function(jqXHR, textStatus, errorThrown) {
            alert('An error occurred while updating the data.');
            console.error('Error:', textStatus, errorThrown);
            console.error('HTTP status:', jqXHR.status);
            console.error('Response text:', jqXHR.responseText);
        }
    })
});







function removeAnimal(petId) {
    $.ajax({
        url: '/removeanimal',
        type: 'POST',
        data: { id: petId },
        success: function(response) {
            // Handle the response from the server
            if (response === 'success') {
                alert('The pet has been removed successfully.');
                // Redirect to another page
                window.location.href = '../Html/animaisempregado.html';
            } else {
                alert('An error occurred while removing the pet.');
            }
        },
        error: function(jqXHR, textStatus, errorThrown) {
            alert('An error occurred while removing the pet.');
            console.error('Error:', textStatus, errorThrown);
            console.error('HTTP status:', jqXHR.status);
            console.error('Response text:', jqXHR.responseText);
        }
    });
}