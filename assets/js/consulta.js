function salvarFormularioConsulta(event) {
    if (event) event.preventDefault(); 
    try {
        const inputNomePet  = document.querySelector('input[name="nomeAnimal"]');
        const inputIdade    = document.querySelector('input[name="idade"]');
        const inputObs      = document.querySelector('textarea[name="observacoes"]') || document.querySelector('input[name="observacoes"]');
        const inputTutor    = document.querySelector('input[name="nomeTutor"]');
        const inputTelefone = document.querySelector('input[name="telefoneTutor"]');
        const inputData     = document.querySelector('input[type="date"]') || document.querySelector('input[name="data"]');
        const novaSolicitacao = {
            id: Date.now(),
            nomeAnimal: inputNomePet ? inputNomePet.value : "Luna",
            idadeAnimal: inputIdade ? inputIdade.value : "5",
            observacoesText: inputObs ? inputObs.value : "nada",
            nomeTutor: inputTutor ? inputTutor.value : "Alberto Silva",
            telefoneTutor: inputTelefone ? inputTelefone.value : "27 977454564",
            dataConsulta: inputData ? inputData.value : "20/06/2026",
            tipoAtendimento: "Consulta", // Força a palavra para a aba do admin reconhecer de primeira!
            status: "Em andamento"
        };
        let banco = JSON.parse(localStorage.getItem('banco_arca')) || [];
        banco.push(novaSolicitacao);
        localStorage.setItem('banco_arca', JSON.stringify(banco));
        alert("Solicitação enviada com sucesso!");
        window.location.href = "./solicitacoes.html";
    } catch (erro) {
        console.error("Erro ao salvar o formulário:", erro);
        alert("Ops! Ocorreu um erro ao salvar. Verifique o Console (F12).");
    }
}