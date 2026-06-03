function toggleMenu() {
    document.getElementById('dropdownPerfil').classList.toggle('aberto');
}
document.addEventListener('click', function(e) {
    const dropdown = document.getElementById('dropdownPerfil');
    const botao = document.getElementById('botaoPerfil');
    
    if (!botao.contains(e.target) && !dropdown.contains(e.target)) {
        dropdown.classList.remove('aberto');
    }
});
document.addEventListener("DOMContentLoaded", () => {
    let nomeUsuario = sessionStorage.getItem("usuario_logado");
    let linkLogin = document.getElementById("link-login-menu");
    let blocoUsuario = document.getElementById("usuario-logado-menu");
    let containerNome = document.getElementById("nome-usuario-container");
    if (nomeUsuario && linkLogin && blocoUsuario && containerNome) {
        containerNome.innerText = nomeUsuario;
        linkLogin.style.display = "none";
        blocoUsuario.style.display = "block";
    }
});
function redirecionarSolicitacoes(event) {
    event.preventDefault(); 
    let usuarioLogadoNome = sessionStorage.getItem("usuario_logado");
    if (usuarioLogadoNome && usuarioLogadoNome.includes("Prefeitura")) {
        window.location.href = "../paginas/solicatacoesFunc.html";
    } 
    else {
        window.location.href = "../paginas/solicitacoes.html";
    }
}