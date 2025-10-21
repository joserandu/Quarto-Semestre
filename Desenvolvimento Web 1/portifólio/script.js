document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('contactForm');

    form.addEventListener('submit', function(event) {
        event.preventDefault();

        const nome = document.getElementById('nome').value;
        const email = document.getElementById('email').value;
        const assunto = document.getElementById('assunto').value;
        const mensagem = document.getElementById('mensagem').value;
        const aceite = document.getElementById('aceite').checked;

        if (nome === '' || email === '' || assunto === '' || mensagem === '' || !aceite) {
            alert('Por favor, preencha todos os campos obrigatórios e aceite os termos.');
            return;
        }

        const dadosDoFormulario = `
            Nome: ${nome}
            Email: ${email}
            Telefone: ${document.getElementById('telefone').value}
            Assunto: ${assunto}
            Mensagem: ${mensagem}
            Tipo de Contato: ${document.getElementById('tipoContato').value}
            Aceite: ${aceite}
        `;

        alert("Dados enviados com sucesso:\n\n" + dadosDoFormulario);

        form.reset();
    });
});
