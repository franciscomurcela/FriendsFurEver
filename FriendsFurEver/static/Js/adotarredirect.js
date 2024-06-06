var urlParams = new URLSearchParams(window.location.search);
var nome = urlParams.get('nome');
$.ajax({
    url: '/api_adotar', 
    type: 'GET',
    data: { nome: nome },
    dataType: 'json',
    success: function(pet) {
        console.log(pet);
            $('#Id').val(pet.Id);
            $('#Nome').val(pet.Nome);
            $('#raca').val(pet.Raca);
            $('#Idade').val(pet.Idade);
            $('#Sexo').val(pet.Sexo);
            $('#adocao').val(pet.EstadoDeAdocao);
            $('#comportamento').val(pet.Comportamento);
            $('#microchip').val(pet.Microchip);
            $('#sexo').val(pet.Sexo);
            $('#petimg').attr('src', pet.Img)
            $('#Healthy').val(pet.Healthy);
            
            if (pet.EstadoDeAdocao == 0){
                $('#adocao').val('Disponível para adoção');
            } else{
                $('#adocao').val('Adotado');
            }

            if (pet.Healthy == 0){
                $('#Healthy').val('Não Saudável');
            } else{
                $('#Healthy').val('Saudável');
            }

            if (pet.Microchip == 0){
                $('#microchip').val('Não tem');
            } else{
                $('#microchip').val('Tem');
            }

            if (pet.Sexo == 'f'){
                $('#sexo').val('Fêmea');
            } else{
                $('#sexo').val('Macho');
            }

            if (pet.IdMae != null){
                $('#idmae').val(pet.IdMae);
            } else if (pet.IdPai != null){
                $('#idpai').val(pet.IdPai);
            } else{
                $('#idmae').val('Desconhecido');
                $('#idpai').val('Desconhecido');
            }
    },
    error: function(jqXHR, textStatus, errorThrown) {
        $('#pet-details').html('<p>An error occurred.</p>');
        console.error('Error:', textStatus, errorThrown);
    }
});

