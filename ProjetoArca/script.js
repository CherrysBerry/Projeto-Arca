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