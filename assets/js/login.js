function logar() {
    let user = document.getElementById("email").value.trim();
    let password = document.getElementById("senha").value;
    let lembrar = document.getElementById("rememberMe").checked;

    let nomeExibicao = "";
    let redirecionamento = "";
    let usuarioChave = "";
    if (user == "tutor" && password == 123456) {
        nomeExibicao = "Alberto Silva";
        usuarioChave = "tutor";
        redirecionamento = "../paginas/consulta.html";
    }
    else if (user === "candidato" && password === "cand!098") {
        nomeExibicao = "Candidato";
        usuarioChave = "candidato";
        redirecionamento = "../paginas/adocao.html";
    }
    else if (user == "Ong" && password == "ong$-135") {
        nomeExibicao = "ONG Protetores";
        usuarioChave = "Ong";
        redirecionamento = "../paginas/consulta.html";
    }
    else if (user == "prefeitura" && password == "pref@456") {
        nomeExibicao = "Prefeitura";
        usuarioChave = "prefeitura";
        redirecionamento = "../paginas/solicatacoesFunc.html";
    } else {
        window.alert("Usuário ou senha inválidos!");
        return;
    }
    sessionStorage.setItem("usuario_logado", nomeExibicao);
    if (lembrar) {
        localStorage.setItem("usuario", usuarioChave);
    } else {
        localStorage.removeItem("usuario");
    }
    window.location.href = redirecionamento;
}