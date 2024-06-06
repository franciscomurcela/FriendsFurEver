$('#editanimalform').on('submit', function(e) {
    e.preventDefault();
    // Get the updated data from the form
    var updatedPet = {
        Nome: $('#Nome').val(),
        Id: $('#Id').val(),
        Raca: $('#raca').val(),
        Idade: $('#Idade').val(),
        EstadoDeAdocao: $('#adocao').val(),
        Comportamento: $('#comportamento').val(),
        Sexo: $('#Sexo').val(),
        Microchip: $('#microchip').val(),
        Img: $('#img').val(),
        Healthy: $('#Healthy').val(),
        IdMae: $('#idmae').val() != 'Desconhecido' ? $('#idmae').val() : null,
        IdPai: $('#idpai').val() != 'Desconhecido' ? $('#idpai').val() : null,
    };

    // Send an AJAX request with the updated data
    $.ajax({
        url: '/editanimalupdate',
        type: 'POST',
        data: updatedPet,
        success: function(response) {
            console.log(response);
            window.location.href = '/animaisempregado';
        },
        error: function(jqXHR, textStatus, errorThrown) {
            console.error('Error:', textStatus, errorThrown);
        }
    });
});