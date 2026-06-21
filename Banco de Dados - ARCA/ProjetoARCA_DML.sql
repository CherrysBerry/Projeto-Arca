CREATE EXTENSION IF NOT EXISTS unaccent;
CREATE OR REPLACE FUNCTION inserir_enderecos_serra()
RETURNS VOID AS $$
DECLARE
    bairros TEXT[] := ARRAY[
        'Caçaroca', 'Santo Antônio', 'São Judas Tadeu', 'São Lourenço', 'Maria Níobe',
        'Serra Centro', 'Centro da Serra', 'São Domingos', 'Jardim Guanabara',
        'Jardim Bela Vista', 'Jardim Primavera', 'Palmeiras', 'Fazenda Cascata',
        'São Marcos', 'São Marcos II', 'São Marcos III', 'Colina da Serra',
        'Jardim da Serra', 'Nossa Senhora da Conceição',
        'Vista da Serra I', 'Vista da Serra II', 'Campinho da Serra I',
        'Campinho da Serra II', 'Planalto Serrano', 'Continental',
        'Divinópolis', 'Belvedere', 'Cidade Nova da Serra', 'Muribeca',
        'Itaiobaia', 'Aroaba', 'Putiri', 'Santiago da Serra',
        'Nova Almeida', 'Poço dos Padres', 'Reis Magos', 'Boa Vista',
        'Bairro Novo', 'São João', 'Marbela', 'Potiguara', 'Parque das Gaivotas',
        'Serramar', 'Praiamar', 'Parque Residencial Nova Almeida', 'Parque Santa Fé',
        'Carapina', 'Carapina Grande', 'Carapina I', 'Industrial de Carapina',
        'Porto de Santana', 'Jardim Limoeiro', 'Residencial Laranjeiras',
        'Pitanga', 'Barro Branco', 'Nova Carapina I', 'Nova Carapina II',
        'Parque Residencial Mestre Álvaro', 'Monte Verde',
        'Cidade Pomar', 'Novo Porto Canoa', 'Eldorado', 'Parque Residencial Tubarão',
        'Serra Dourada', 'Serra Dourada II', 'Serra Dourada III', 'Barcelona',
        'Maringá', 'Planície da Serra', 'Santa Rita de Cássia', 'Mata da Serra', 'Porto Canoa',
        'Jacaraípe', 'Balneário de Carapebus', 'Carapebus', 'Porto Dourado', 'Jacuhy',
        'Civit I', 'Civit II', 'Polo Industrial Tubarão',
        'Jardim Carapina', 'Vila Nova de Colares', 'André Carloni',
        'Parque Residencial Panorama', 'Taquara I', 'Taquara II',
        'Laranjeiras', 'Laranjeiras Velha', 'Chico City', 'Colina de Laranjeiras',
        'Valparaíso', 'Parque Residencial Laranjeiras', 'Chácara Parreiral',
        'Guaraciaba', 'Morada de Laranjeiras', 'Conjunto de Laranjeiras',
        'Solar de Laranjeiras I', 'Solar de Laranjeiras II',
        'Alterosas', 'Nova Zelândia', 'Parque da Lagoa', 'Feu Rosa',
        'Centro Industrial do Município'
    ];
    logradouros TEXT[] := ARRAY[
        'Rua das Flores', 'Avenida Central', 'Rua Principal', 'Travessa da Paz',
        'Avenida Brasil', 'Rua das Palmeiras', 'Rua do Comércio', 'Avenida Litorânea',
        'Rua São José', 'Avenida das Acácias', 'Rua da Saudade', 'Rua do Sol',
        'Avenida das Flores', 'Rua das Palmeiras', 'Rua da Paz', 'Travessa Central',
        'Rua dos Ipês', 'Avenida Serra', 'Rua do Porto', 'Rua das Mangueiras'
    ];
    bairro TEXT;
    logradouro TEXT;
    i INT;
    total INT := 0;
    inserções_por_bairro INT;
BEGIN
    inserções_por_bairro := ceil(3125.0 / array_length(bairros, 1));
    
    FOREACH bairro IN ARRAY bairros LOOP
        FOR i IN 1..inserções_por_bairro LOOP
            EXIT WHEN total >= 3125;
            logradouro := logradouros[1 + floor(random() * array_length(logradouros, 1))::int];
            INSERT INTO endereco (bairro, logradouro, numero, complemento)
            VALUES (
                bairro,
                logradouro,
                (floor(random() * 9999) + 1)::text,
                CASE WHEN random() > 0.5 
                    THEN 'Apto ' || (floor(random() * 200) + 1)::text 
                    ELSE NULL 
                END
            );
            total := total + 1;
        END LOOP;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT inserir_enderecos_serra();

CREATE OR REPLACE FUNCTION inserir_pessoas()
RETURNS VOID AS $$
DECLARE
    nomes_masculinos TEXT[] := ARRAY[
        'João', 'Pedro', 'Lucas', 'Mateus', 'Gabriel', 'Rafael', 'Bruno', 'Felipe',
        'Carlos', 'Eduardo', 'Gustavo', 'Henrique', 'Igor', 'Jorge', 'Leonardo',
        'Marcos', 'Nicolas', 'Otávio', 'Paulo', 'Ricardo'
    ];
    nomes_femininos TEXT[] := ARRAY[
        'Ana', 'Beatriz', 'Carla', 'Daniela', 'Eduarda', 'Fernanda', 'Gabriela',
        'Helena', 'Isabela', 'Juliana', 'Larissa', 'Mariana', 'Natália', 'Olivia',
        'Patrícia', 'Rafaela', 'Sabrina', 'Tatiana', 'Vanessa', 'Yasmin'
    ];
    sobrenomes TEXT[] := ARRAY[
        'Silva', 'Santos', 'Oliveira', 'Souza', 'Rodrigues', 'Ferreira', 'Alves',
        'Pereira', 'Lima', 'Gomes', 'Costa', 'Ribeiro', 'Martins', 'Carvalho',
        'Almeida', 'Lopes', 'Soares', 'Fernandes', 'Vieira', 'Barbosa',
        'Rocha', 'Dias', 'Nascimento', 'Andrade', 'Moreira'
    ];
    nome TEXT;
    sobrenome TEXT;
    cpf TEXT;
    email TEXT;
    telefone TEXT;
    v_endereco_id INT;
    ids_endereco INT[];
    i INT;
BEGIN
    SELECT ARRAY(SELECT id FROM endereco) INTO ids_endereco;
    
    IF array_length(ids_endereco, 1) IS NULL THEN
        RAISE EXCEPTION 'Nenhum endereço cadastrado! Execute inserir_enderecos_serra() primeiro.';
    END IF;

    FOR i IN 1..30000 LOOP
        IF random() > 0.5 THEN
            nome := nomes_masculinos[1 + floor(random() * array_length(nomes_masculinos, 1))::int];
        ELSE
            nome := nomes_femininos[1 + floor(random() * array_length(nomes_femininos, 1))::int];
        END IF;
        
        sobrenome := sobrenomes[1 + floor(random() * array_length(sobrenomes, 1))::int];
        cpf := lpad(i::text, 11, '0');
        email := lower(unaccent(nome)) || '.' || lower(unaccent(sobrenome)) || i || '@email.com';
        telefone := '27' || lpad((floor(random() * 999999999) + 1)::bigint::text, 9, '0');
        
        v_endereco_id := ids_endereco[1 + floor(random() * array_length(ids_endereco, 1))::int];
        
        INSERT INTO pessoas (CPF, nome, email, telefone, endereco_id)
        VALUES (cpf, nome || ' ' || sobrenome, email, telefone, v_endereco_id);
    END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT inserir_pessoas();


CREATE OR REPLACE FUNCTION inserir_funcionarios()
RETURNS VOID AS $$
DECLARE
    cargos TEXT[] := ARRAY[
        'Veterinário', 'Auxiliar Veterinário', 'Recepcionista', 'Gerente', 'Analista', 'Programador', 'Secretário', 'Suporte',
        'Atendente', 'Técnico em Saúde Animal', 'Coordenador', 'Assistente Administrativo'
    ];
    ids_pessoas INT[];
    ids_usados INT[];
    v_pessoas_id INT;
    v_cargo TEXT;
    i INT;
BEGIN
    SELECT ARRAY(
        SELECT id FROM pessoas 
        WHERE id NOT IN (SELECT pessoas_id FROM funcionario)
        ORDER BY random()
        LIMIT 10000
    ) INTO ids_pessoas;

    IF array_length(ids_pessoas, 1) IS NULL THEN
        RAISE EXCEPTION 'Nenhuma pessoa disponível para ser funcionário!';
    END IF;

    IF array_length(ids_pessoas, 1) < 4000 THEN
        RAISE EXCEPTION 'Pessoas insuficientes! Só há % disponíveis.', array_length(ids_pessoas, 1);
    END IF;

    FOR i IN 1..10000 LOOP
        v_pessoas_id := ids_pessoas[i];
        v_cargo := cargos[1 + floor(random() * array_length(cargos, 1))::int];

        INSERT INTO funcionario (pessoas_id, cargo, login, senha)
        VALUES (
            v_pessoas_id,
            v_cargo,
            'user_' || v_pessoas_id,
            'senha' || lpad(i::text, 4, '0')
        );
    END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT inserir_funcionarios();



CREATE OR REPLACE FUNCTION inserir_comuns()
RETURNS VOID AS $$
DECLARE
    ids_pessoas INT[];
    i INT;
BEGIN
    SELECT ARRAY(
        SELECT id FROM pessoas
        WHERE id NOT IN (SELECT pessoas_id FROM comum)
        ORDER BY random()
        LIMIT 10000
    ) INTO ids_pessoas;

    IF array_length(ids_pessoas, 1) IS NULL THEN
        RAISE EXCEPTION 'Nenhuma pessoa disponível!';
    END IF;

    IF array_length(ids_pessoas, 1) < 10000 THEN
        RAISE EXCEPTION 'Pessoas insuficientes! Só há % disponíveis.', array_length(ids_pessoas, 1);
    END IF;

    FOR i IN 1..10000 LOOP
        INSERT INTO comum (pessoas_id)
        VALUES (ids_pessoas[i]);
    END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT inserir_comuns();

CREATE OR REPLACE FUNCTION inserir_tutores()
RETURNS VOID AS $$
DECLARE
    ids_pessoas INT[];
    i INT;
BEGIN
    SELECT ARRAY(
        SELECT id FROM pessoas
        WHERE id NOT IN (SELECT pessoas_id FROM tutor)
        ORDER BY random()
        LIMIT 10000
    ) INTO ids_pessoas;

    IF array_length(ids_pessoas, 1) IS NULL THEN
        RAISE EXCEPTION 'Nenhuma pessoa disponível!';
    END IF;

    IF array_length(ids_pessoas, 1) < 10000 THEN
        RAISE EXCEPTION 'Pessoas insuficientes! Só há % disponíveis.', array_length(ids_pessoas, 1);
    END IF;

    FOR i IN 1..10000 LOOP
        INSERT INTO tutor (pessoas_id)
        VALUES (ids_pessoas[i]);
    END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT inserir_tutores();


CREATE OR REPLACE FUNCTION inserir_solicitacoes()
RETURNS VOID AS $$
DECLARE
    status_opcoes TEXT[] := ARRAY['Em andamento', 'Concluído', 'Indeferido'];
    i INT;
BEGIN
    FOR i IN 1..10000 LOOP
        INSERT INTO solicitacoes (data, hora, status)
        VALUES (
            DATE '2023-01-01' + floor(random() * 1095)::int,
            TIME '07:00' + (floor(random() * 660) || ' minutes')::interval,
            status_opcoes[1 + floor(random() * array_length(status_opcoes, 1))::int]
        );
    END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT inserir_solicitacoes();


CREATE OR REPLACE FUNCTION inserir_unidades()
RETURNS VOID AS $$
DECLARE
    nomes_unidades TEXT[] := ARRAY[
        'Clínica Veterinária Pata Feliz', 'Centro de Zoonoses Serra',
        'Unidade Veterinária Vila Nova', 'Clínica Animal Care',
        'Centro de Controle Animal Serra', 'Unidade de Saúde Animal Laranjeiras',
        'Clínica Bicho Feliz', 'Posto Veterinário Carapina',
        'Unidade Veterinária Jacaraípe', 'Centro Animal Feu Rosa',
        'Clínica Pet Saúde', 'Unidade de Zoonoses Nova Almeida',
        'Centro Veterinário Serra Sede', 'Clínica Animal Plus',
        'Posto de Atendimento Animal Colina', 'Unidade Pet Care Laranjeiras',
        'Centro de Controle de Zoonoses Municipal', 'Clínica Amigo Animal',
        'Unidade Veterinária Campinho', 'Clínica Serra Pet',
        'Posto Animal Saudável', 'Unidade Veterinária Civit',
        'Centro Animal Nova Carapina', 'Clínica Vida Animal',
        'Unidade de Saúde Pet Taquara'
    ];
    ids_solicitacoes INT[];
    v_solicitacao_id INT;
    i INT;
BEGIN
    SELECT ARRAY(
        SELECT id FROM solicitacoes
        ORDER BY random()
        LIMIT 3000
    ) INTO ids_solicitacoes;

    IF array_length(ids_solicitacoes, 1) IS NULL THEN
        RAISE EXCEPTION 'Nenhuma solicitação cadastrada!';
    END IF;

    FOR i IN 1..3000 LOOP
        v_solicitacao_id := ids_solicitacoes[i];

        INSERT INTO unidade (nome, solicitacoes_id)
        VALUES (
            nomes_unidades[1 + floor(random() * array_length(nomes_unidades, 1))::int],
            v_solicitacao_id
        );
    END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT inserir_unidades();



CREATE OR REPLACE FUNCTION inserir_visualiza()
RETURNS VOID AS $$
DECLARE
    ids_solicitacoes INT[];
    ids_funcionarios INT[];
    v_solicitacao_id INT;
    v_funcionario_id INT;
    i INT;
    tentativas INT;
BEGIN
    SELECT ARRAY(SELECT id FROM solicitacoes ORDER BY random()) INTO ids_solicitacoes;
    SELECT ARRAY(SELECT pessoas_id FROM funcionario ORDER BY random()) INTO ids_funcionarios;

    IF array_length(ids_solicitacoes, 1) IS NULL THEN
        RAISE EXCEPTION 'Nenhuma solicitação cadastrada!';
    END IF;

    IF array_length(ids_funcionarios, 1) IS NULL THEN
        RAISE EXCEPTION 'Nenhum funcionário cadastrado!';
    END IF;

    i := 0;
    tentativas := 0;

    WHILE i < 10000 AND tentativas < 50000 LOOP
        tentativas := tentativas + 1;

        v_solicitacao_id := ids_solicitacoes[1 + floor(random() * array_length(ids_solicitacoes, 1))::int];
        v_funcionario_id := ids_funcionarios[1 + floor(random() * array_length(ids_funcionarios, 1))::int];

        IF NOT EXISTS (
            SELECT 1 FROM visualiza
            WHERE solicitacoes_id = v_solicitacao_id
            AND funcionario_id = v_funcionario_id
        ) THEN
            INSERT INTO visualiza (solicitacoes_id, funcionario_id)
            VALUES (v_solicitacao_id, v_funcionario_id);
            i := i + 1;
        END IF;
    END LOOP;

    IF i < 10000 THEN
        RAISE NOTICE 'Atenção: só foi possível inserir % registros únicos.', i;
    END IF;
END;
$$ LANGUAGE plpgsql;

SELECT inserir_visualiza();


CREATE OR REPLACE FUNCTION inserir_doacoes()
RETURNS VOID AS $$
DECLARE
    ids_solicitacoes INT[];
    ids_tutores INT[];
    i INT;
BEGIN
    SELECT ARRAY(
        SELECT id FROM solicitacoes
        WHERE id NOT IN (SELECT solicitacoes_id FROM doacao)
        ORDER BY random()
        LIMIT 1500
    ) INTO ids_solicitacoes;

    SELECT ARRAY(SELECT pessoas_id FROM tutor ORDER BY random()) INTO ids_tutores;

    IF array_length(ids_solicitacoes, 1) IS NULL THEN
        RAISE EXCEPTION 'Nenhuma solicitação disponível!';
    END IF;

    IF array_length(ids_tutores, 1) IS NULL THEN
        RAISE EXCEPTION 'Nenhum tutor cadastrado!';
    END IF;

    FOR i IN 1..1500 LOOP
        INSERT INTO doacao (solicitacoes_id, tutor_id)
        VALUES (
            ids_solicitacoes[i],
            ids_tutores[1 + floor(random() * array_length(ids_tutores, 1))::int]
        );
    END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT inserir_doacoes();



CREATE OR REPLACE FUNCTION inserir_servicos()
RETURNS VOID AS $$
DECLARE
    tipos TEXT[] := ARRAY[
        'Consulta Geral', 'Castração', 'Microchipagem', 'Vacinação'
    ];
    ids_solicitacoes INT[];
    ids_tutores INT[];
    i INT;
BEGIN
    SELECT ARRAY(
        SELECT id FROM solicitacoes
        WHERE id NOT IN (SELECT solicitacoes_id FROM doacao)
        AND id NOT IN (SELECT solicitacoes_id FROM servicos)
        ORDER BY random()
        LIMIT 2500
    ) INTO ids_solicitacoes;

    SELECT ARRAY(SELECT pessoas_id FROM tutor ORDER BY random()) INTO ids_tutores;

    IF array_length(ids_solicitacoes, 1) IS NULL THEN
        RAISE EXCEPTION 'Nenhuma solicitação disponível!';
    END IF;

    IF array_length(ids_tutores, 1) IS NULL THEN
        RAISE EXCEPTION 'Nenhum tutor cadastrado!';
    END IF;

    FOR i IN 1..2500 LOOP
        INSERT INTO servicos (solicitacoes_id, tipo, tutor_id)
        VALUES (
            ids_solicitacoes[i],
            tipos[1 + floor(random() * array_length(tipos, 1))::int],
            ids_tutores[1 + floor(random() * array_length(ids_tutores, 1))::int]
        );
    END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT inserir_servicos();



CREATE OR REPLACE FUNCTION inserir_adocoes()
RETURNS VOID AS $$
DECLARE
    ids_solicitacoes INT[];
    ids_comuns INT[];
    i INT;
BEGIN
    SELECT ARRAY(
        SELECT id FROM solicitacoes
        WHERE id NOT IN (SELECT solicitacoes_id FROM doacao)
        AND id NOT IN (SELECT solicitacoes_id FROM servicos)
        AND id NOT IN (SELECT solicitacoes_id FROM adocao)
        ORDER BY random()
        LIMIT 4500
    ) INTO ids_solicitacoes;

    SELECT ARRAY(SELECT pessoas_id FROM comum ORDER BY random()) INTO ids_comuns;

    IF array_length(ids_solicitacoes, 1) IS NULL THEN
        RAISE EXCEPTION 'Nenhuma solicitação disponível!';
    END IF;

    IF array_length(ids_comuns, 1) IS NULL THEN
        RAISE EXCEPTION 'Nenhum comum cadastrado!';
    END IF;

    IF array_length(ids_solicitacoes, 1) < 4500 THEN
        RAISE EXCEPTION 'Solicitações insuficientes! Só há % disponíveis.', array_length(ids_solicitacoes, 1);
    END IF;

    FOR i IN 1..4500 LOOP
        INSERT INTO adocao (solicitacoes_id, comum_id)
        VALUES (
            ids_solicitacoes[i],
            ids_comuns[1 + floor(random() * array_length(ids_comuns, 1))::int]
        );
    END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT inserir_adocoes();



CREATE OR REPLACE FUNCTION inserir_denuncias()
RETURNS VOID AS $$
DECLARE
    ids_solicitacoes INT[];
    ids_enderecos INT[];
    i INT;
BEGIN
    SELECT ARRAY(
        SELECT id FROM solicitacoes
        WHERE id NOT IN (SELECT solicitacoes_id FROM doacao)
        AND id NOT IN (SELECT solicitacoes_id FROM servicos)
        AND id NOT IN (SELECT solicitacoes_id FROM adocao)
        AND id NOT IN (SELECT solicitacoes_id FROM denuncias)
        ORDER BY random()
        LIMIT 1500
    ) INTO ids_solicitacoes;

    SELECT ARRAY(SELECT id FROM endereco ORDER BY random()) INTO ids_enderecos;

    IF array_length(ids_solicitacoes, 1) IS NULL THEN
        RAISE EXCEPTION 'Nenhuma solicitação disponível!';
    END IF;

    IF array_length(ids_enderecos, 1) IS NULL THEN
        RAISE EXCEPTION 'Nenhum endereço cadastrado!';
    END IF;

    IF array_length(ids_solicitacoes, 1) < 1500 THEN
        RAISE EXCEPTION 'Solicitações insuficientes! Só há % disponíveis.', array_length(ids_solicitacoes, 1);
    END IF;

    FOR i IN 1..1500 LOOP
        INSERT INTO denuncias (solicitacoes_id, endereco_id)
        VALUES (
            ids_solicitacoes[i],
            ids_enderecos[1 + floor(random() * array_length(ids_enderecos, 1))::int]
        );
    END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT inserir_denuncias();



CREATE OR REPLACE FUNCTION inserir_resgates()
RETURNS VOID AS $$
DECLARE
    ids_denuncias INT[];
    ids_comuns INT[];
    i INT;
BEGIN
    SELECT ARRAY(
        SELECT solicitacoes_id FROM denuncias
        WHERE solicitacoes_id NOT IN (SELECT denuncias_id FROM resgate)
        ORDER BY random()
        LIMIT 750
    ) INTO ids_denuncias;

    SELECT ARRAY(SELECT pessoas_id FROM comum ORDER BY random()) INTO ids_comuns;

    IF array_length(ids_denuncias, 1) IS NULL THEN
        RAISE EXCEPTION 'Nenhuma denúncia disponível!';
    END IF;

    IF array_length(ids_comuns, 1) IS NULL THEN
        RAISE EXCEPTION 'Nenhum comum cadastrado!';
    END IF;

    FOR i IN 1..750 LOOP
        INSERT INTO resgate (denuncias_id, comum_id)
        VALUES (
            ids_denuncias[i],
            ids_comuns[1 + floor(random() * array_length(ids_comuns, 1))::int]
        );
    END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT inserir_resgates();



CREATE OR REPLACE FUNCTION inserir_maustratos()
RETURNS VOID AS $$
DECLARE
    ids_denuncias INT[];
    ids_comuns INT[];
    i INT;
BEGIN
    SELECT ARRAY(
        SELECT solicitacoes_id FROM denuncias
        WHERE solicitacoes_id NOT IN (SELECT denuncias_id FROM resgate)
        AND solicitacoes_id NOT IN (SELECT denuncias_id FROM maustratos)
        ORDER BY random()
        LIMIT 750
    ) INTO ids_denuncias;

    SELECT ARRAY(SELECT pessoas_id FROM comum ORDER BY random()) INTO ids_comuns;

    IF array_length(ids_denuncias, 1) IS NULL THEN
        RAISE EXCEPTION 'Nenhuma denúncia disponível!';
    END IF;

    IF array_length(ids_comuns, 1) IS NULL THEN
        RAISE EXCEPTION 'Nenhum comum cadastrado!';
    END IF;

    FOR i IN 1..750 LOOP
        INSERT INTO maustratos (denuncias_id, comum_id)
        VALUES (
            ids_denuncias[i],
            ids_comuns[1 + floor(random() * array_length(ids_comuns, 1))::int]
        );
    END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT inserir_maustratos();



CREATE OR REPLACE FUNCTION inserir_animais()
RETURNS VOID AS $$
DECLARE
    racas_cachorro TEXT[] := ARRAY[
        'Labrador', 'Golden Retriever', 'Bulldog', 'Poodle', 'Beagle',
        'Pastor Alemão', 'Husky Siberiano', 'Shih Tzu', 'Yorkshite', 'Vira-lata'
    ];
    racas_gato TEXT[] := ARRAY[
        'Siamês', 'Persa', 'Maine Coon', 'Ragdoll', 'Bengal',
        'Sphynx', 'Angorá', 'Abissínio', 'Vira-lata', 'Europeu'
    ];
    nomes TEXT[] := ARRAY[
        'Rex', 'Bob', 'Luna', 'Mel', 'Thor', 'Nina', 'Max', 'Bella',
        'Simba', 'Lola', 'Buddy', 'Lily', 'Charlie', 'Coco', 'Rocky',
        'Nala', 'Duke', 'Mia', 'Zeus', 'Zara'
    ];
    portes TEXT[] := ARRAY['pequeno', 'medio', 'grande'];
    ids_adocao INT[];
    ids_doacao INT[];
    ids_servicos INT[];
    ids_denuncias INT[];
    v_especie VARCHAR(8);
    v_raca VARCHAR(50);
    v_adocao_id INT;
    v_doacao_id INT;
    v_servicos_id INT;
    v_denuncias_id INT;
    i INT;
BEGIN
    SELECT ARRAY(SELECT solicitacoes_id FROM adocao ORDER BY random()) INTO ids_adocao;
    SELECT ARRAY(SELECT solicitacoes_id FROM doacao ORDER BY random()) INTO ids_doacao;
    SELECT ARRAY(SELECT solicitacoes_id FROM servicos ORDER BY random()) INTO ids_servicos;
    SELECT ARRAY(SELECT solicitacoes_id FROM denuncias ORDER BY random()) INTO ids_denuncias;

    FOR i IN 1..10000 LOOP
        IF random() > 0.5 THEN
            v_especie := 'cachorro';
            v_raca := racas_cachorro[1 + floor(random() * array_length(racas_cachorro, 1))::int];
        ELSE
            v_especie := 'gato';
            v_raca := racas_gato[1 + floor(random() * array_length(racas_gato, 1))::int];
        END IF;

        v_adocao_id := CASE WHEN random() > 0.5 
            THEN ids_adocao[1 + floor(random() * array_length(ids_adocao, 1))::int]
            ELSE NULL END;

        v_doacao_id := CASE WHEN random() > 0.5 
            THEN ids_doacao[1 + floor(random() * array_length(ids_doacao, 1))::int]
            ELSE NULL END;

        v_servicos_id := CASE WHEN random() > 0.5 
            THEN ids_servicos[1 + floor(random() * array_length(ids_servicos, 1))::int]
            ELSE NULL END;

        v_denuncias_id := CASE WHEN random() > 0.5 
            THEN ids_denuncias[1 + floor(random() * array_length(ids_denuncias, 1))::int]
            ELSE NULL END;

        INSERT INTO animal (
            raca, genero, nome, vacinado, idade, descricao,
            porte, necessidade_especial, microchipagem, especie,
            castrado, adocao_id, doacao_id, servicos_id, denuncias_id
        )
        VALUES (
            v_raca,
            CASE WHEN random() > 0.5 THEN 'M' ELSE 'F' END,
            nomes[1 + floor(random() * array_length(nomes, 1))::int],
            CASE WHEN random() > 0.5 THEN 'S' ELSE 'N' END,
            (floor(random() * 15) + 1)::int,
            'Animal resgatado em bom estado de saúde.',
            portes[1 + floor(random() * array_length(portes, 1))::int],
            CASE WHEN random() > 0.8 THEN 'Necessita cuidados especiais' ELSE NULL END,
            CASE WHEN random() > 0.5 THEN 'S' ELSE 'N' END,
            v_especie,
            CASE WHEN random() > 0.5 THEN 'S' ELSE 'N' END,
            v_adocao_id,
            v_doacao_id,
            v_servicos_id,
            v_denuncias_id
        );
    END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT inserir_animais();


CREATE OR REPLACE FUNCTION inserir_vacinas()
RETURNS VOID AS $$
DECLARE
    vacinas_cachorro TEXT[] := ARRAY[
        'Antirrábica', 'V8', 'V10', 'Polivalente', 'Giárdia',
        'Gripe Canina', 'Leishmaniose', 'Leptospirose', 'Coronavírus Canino'
    ];
    vacinas_gato TEXT[] := ARRAY[
        'Antirrábica', 'Tríplice Felina', 'Quádrupla Felina', 'Quíntupla Felina',
        'FeLV', 'Clamidiose', 'Bordetela Felina'
    ];
    ids_animais_cachorro INT[];
    ids_animais_gato INT[];
    v_animal_id INT;
    v_nome TEXT;
    i INT;
BEGIN
    SELECT ARRAY(SELECT id FROM animal WHERE especie = 'cachorro' ORDER BY random()) INTO ids_animais_cachorro;
    SELECT ARRAY(SELECT id FROM animal WHERE especie = 'gato' ORDER BY random()) INTO ids_animais_gato;

    IF array_length(ids_animais_cachorro, 1) IS NULL AND array_length(ids_animais_gato, 1) IS NULL THEN
        RAISE EXCEPTION 'Nenhum animal cadastrado!';
    END IF;

    FOR i IN 1..8000 LOOP
        IF random() > 0.5 AND array_length(ids_animais_cachorro, 1) > 0 THEN
            v_animal_id := ids_animais_cachorro[1 + floor(random() * array_length(ids_animais_cachorro, 1))::int];
            v_nome := vacinas_cachorro[1 + floor(random() * array_length(vacinas_cachorro, 1))::int];
        ELSE
            v_animal_id := ids_animais_gato[1 + floor(random() * array_length(ids_animais_gato, 1))::int];
            v_nome := vacinas_gato[1 + floor(random() * array_length(vacinas_gato, 1))::int];
        END IF;

        INSERT INTO vacinas (nome, animal_id)
        VALUES (v_nome, v_animal_id);
    END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT inserir_vacinas();

SELECT 'endereco' AS tabela, COUNT(*) AS registros FROM endereco
UNION ALL
SELECT 'pessoas', COUNT(*) FROM pessoas
UNION ALL
SELECT 'funcionario', COUNT(*) FROM funcionario
UNION ALL
SELECT 'tutor', COUNT(*) FROM tutor
UNION ALL
SELECT 'comum', COUNT(*) FROM comum
UNION ALL
SELECT 'solicitacoes', COUNT(*) FROM solicitacoes
UNION ALL
SELECT 'unidade', COUNT(*) FROM unidade
UNION ALL
SELECT 'visualiza', COUNT(*) FROM visualiza
UNION ALL
SELECT 'doacao', COUNT(*) FROM doacao
UNION ALL
SELECT 'servicos', COUNT(*) FROM servicos
UNION ALL
SELECT 'adocao', COUNT(*) FROM adocao
UNION ALL
SELECT 'denuncias', COUNT(*) FROM denuncias
UNION ALL
SELECT 'resgate', COUNT(*) FROM resgate
UNION ALL
SELECT 'maustratos', COUNT(*) FROM maustratos
UNION ALL
SELECT 'animal', COUNT(*) FROM animal
UNION ALL
SELECT 'vacinas', COUNT(*) FROM vacinas;