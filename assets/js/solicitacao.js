const formConsulta = document.getElementById('form-consulta');
if (formConsulta) {
    formConsulta.addEventListener('submit', function(event) {
        event.preventDefault();

        const formData = new FormData(this);
        const dadosSolicitacao = Object.fromEntries(formData.entries());

        dadosSolicitacao.id = "ARCA-" + Date.now();
        dadosSolicitacao.status = "analise";
        dadosSolicitacao.tipoGeral = "Consulta";

        let solicitacoes = JSON.parse(localStorage.getItem('banco_arca')) || [];
        solicitacoes.push(dadosSolicitacao);
        localStorage.setItem('banco_arca', JSON.stringify(solicitacoes));

        alert('Solicitação enviada com sucesso ao administrador!');
        this.reset();
    });
}

let solicitacaoSelecionadaId = null;

function renderizarPainelAdmin(tipoAbaAtiva) {
    const container = document.getElementById('container-cards-admin');
    const boxConfirmacao = document.getElementById('box-confirmacao');
    if (!container) return;

    const cardFantasma = document.getElementById('card-fantasma');
    if (cardFantasma) cardFantasma.remove();

    const cardsAntigos = container.querySelectorAll('.card-agendamento');
    cardsAntigos.forEach(card => card.remove());

    let solicitacoes = JSON.parse(localStorage.getItem('banco_arca')) || [];

    let filtradas = solicitacoes.filter(item => {
        let tipo = (item.tipoAtendimento || item.tipoGeral || "").toLowerCase();
        let bateCategoria = (tipo === tipoAbaAtiva.toLowerCase());

        return bateCategoria && item.status !== 'Concluído';
    });

    if (filtradas.length === 0) {
        const aviso = document.createElement('p');
        aviso.className = 'card-agendamento';
        aviso.style.padding = '15px';
        aviso.innerText = `Nenhuma solicitação de ${tipoAbaAtiva}.`;
        container.insertBefore(aviso, boxConfirmacao);
        return;
    }

    filtradas.forEach(s => {
        const card = document.createElement('div');
        card.className = 'card-agendamento';
        card.style.cursor = 'pointer';
        card.onclick = () => carregarDetalhesAdmin(s.id);

        card.innerHTML = `
            <div class="card-header-info">
                <span class="titulo-agendamento">${s.nomeAnimal || 'Sem nome'}</span>
                <span class="codigo-agendamento">#${s.id ? s.id.toString().slice(-5) : 'xxxxx'}</span>
            </div>
            <span class="status-badge">${s.status || 'Em andamento'}</span>
        `;

        container.insertBefore(card, boxConfirmacao);
    });
}

function carregarDetalhesAdmin(id) {
    solicitacaoSelecionadaId = id;
    let solicitacoes = JSON.parse(localStorage.getItem('banco_arca')) || [];
    let s = solicitacoes.find(item => item.id === id);

    if (!s) return;

    document.getElementById('tipo-solicitacao-titulo').innerText = `${s.tipoAtendimento || s.tipoGeral}`;
    document.querySelector('.usuario-info').innerText = `${s.nomeTutor} - Tel: ${s.telefoneTutor}`;
    
    document.getElementById('admin-info-texto').value = `Animal: ${s.nomeAnimal} | Idade: ${s.idadeAnimal}\nObservações: ${s.observacoesText || 'Nenhuma'}`;
    document.getElementById('admin-data').value = s.dataConsulta || "";
    document.getElementById('admin-select-status').value = s.status;
    
    renderizarPainelAdmin(document.querySelector('.aba-btn.active').innerText);
}

function responderConfirmacao(resposta) {
    const box = document.getElementById('box-confirmacao');
    box.classList.remove('visible');

    if (resposta && solicitacaoSelecionadaId) {
        let solicitacoes = JSON.parse(localStorage.getItem('banco_arca')) || [];
        let index = solicitacoes.findIndex(item => item.id === solicitacaoSelecionadaId);

        if (index !== -1) {
            solicitacoes[index].status = document.getElementById('admin-select-status').value;
            solicitacoes[index].atualizacoesAdmin = document.getElementById('admin-atualizacoes').value;
            
            localStorage.setItem('banco_arca', JSON.stringify(solicitacoes));
            alert("Solicitação atualizada e gravada com sucesso!");
            
            renderizarPainelAdmin(document.querySelector('.aba-btn.active').innerText);
        }
    }
}
const alternarAbaOriginal = window.alternarAba;
window.alternarAba = function(botao) {
    document.querySelectorAll('.aba-btn').forEach(b => b.classList.remove('active'));
    botao.classList.add('active');
    document.getElementById('tipo-solicitacao-titulo').innerText = botao.innerText.toLowerCase();

    renderizarPainelAdmin(botao.innerText);
};

document.addEventListener("DOMContentLoaded", () => {
    if (document.getElementById('container-cards-admin')) {
        renderizarPainelAdmin("Castração");
    }
});
function responderConfirmacao(confirmado) {
    if (!confirmado) {
        document.getElementById("box-confirmacao").style.display = "none";
        return;
    }
    if (confirmado && solicitacaoSelecionadaId) {
        let solicitacoes = JSON.parse(localStorage.getItem('banco_arca')) || [];

        const selectStatus = document.getElementById('admin-select-status');
        const statusEscolhido = selectStatus ? selectStatus.value : 'andamento';
        solicitacoes = solicitacoes.map(item => {
            if (item.id === solicitacaoSelecionadaId) {
                item.status = statusEscolhido;
            }
            return item;
        });
        localStorage.setItem('banco_arca', JSON.stringify(solicitacoes));
        document.getElementById("box-confirmacao").style.display = "none";
        document.getElementById('tipo-solicitacao-titulo').innerText = "tipo de acesso";
        document.getElementById('admin-tutor-info').innerText = "Selecione uma solicitação ao lado";
        if (document.getElementById('admin-info-texto')) document.getElementById('admin-info-texto').value = "";
        if (document.getElementById('admin-data')) document.getElementById('admin-data').value = "";
        if (document.getElementById('admin-atualizacoes')) document.getElementById('admin-atualizacoes').value = "";
        if (selectStatus) selectStatus.value = "andamento";
        const abaAtiva = document.querySelector('.aba-btn.active') || { innerText: 'Consulta' };
        
        renderizarPainelAdmin(abaAtiva.innerText);
        
        alert("Solicitação atualizada com sucesso!");
    }
}