create table endereco(
	id serial, bairro varchar(40), logradouro varchar(40), numero varchar(10), complemento text, constraint pk_endereco primary key(id)
);
create table pessoas(
	id serial, CPF char(11), nome varchar(50), email varchar(60), telefone char(11), endereco_id int, constraint pk_pessoas primary key (id), constraint 
	fk_pessoas foreign key (endereco_id) references endereco (id)
);
create table funcionario(
	pessoas_id int, cargo varchar(40), login varchar(50), senha varchar(20), constraint pk_funcionario primary key (pessoas_id), constraint fk_funcionario foreign
	key (pessoas_id) references pessoas (id)
);
create table solicitacoes(
	id serial, data date, hora time, status varchar(20), constraint pk_solicitacoes primary key (id)
);
create table unidade(
	id serial, nome varchar(50), solicitacoes_id int, constraint pk_unidade primary key (id), constraint fk_unidade foreign key (solicitacoes_id) references
	solicitacoes (id)
);
create table visualiza(
	solicitacoes_id int, funcionario_id int, constraint pk_visualiza primary key (solicitacoes_id, funcionario_id), constraint fk_visualiza_solicitacoes foreign key
	(solicitacoes_id) references solicitacoes (id), constraint fk_visualiza_funcionario foreign key (funcionario_id) references funcionario (pessoas_id)
);
create table tutor(
	pessoas_id int, constraint pk_tutor primary key (pessoas_id), constraint fk_tutor foreign key (pessoas_id) references pessoas (id)
);
create table doacao(
	solicitacoes_id int, tutor_id int, constraint pk_solicitacoes_tutor primary key (solicitacoes_id), constraint fk_solicitacoes foreign key
	(solicitacoes_id) references solicitacoes (id), constraint fk_tutor foreign key (tutor_id) references tutor (pessoas_id)
);
create table servicos(
	solicitacoes_id int, tipo varchar(20), tutor_id int, constraint pk_servicos primary key (solicitacoes_id), constraint fk_solicitacoes foreign key
	(solicitacoes_id) references solicitacoes (id), constraint fk_tutor foreign key (tutor_id) references tutor (pessoas_id)
);
create table comum(
	pessoas_id int, constraint pk_comum primary key (pessoas_id), constraint fk_pessoas foreign key (pessoas_id) references pessoas (id)
);
create table adocao(
	solicitacoes_id int, comum_id int, constraint pk_adocao primary key (solicitacoes_id), constraint fk_solicitacoes foreign key (solicitacoes_id)
	references solicitacoes (id), constraint fk_comum foreign key (comum_id) references comum (pessoas_id)
);
create table denuncias(
	solicitacoes_id int, endereco_id int, constraint pk_denuncias primary key (solicitacoes_id), constraint fk_solicitacoes foreign key (solicitacoes_id)
	references solicitacoes (id), constraint fk_endereco foreign key (endereco_id) references endereco (id)
);
create table resgate(
	denuncias_id int, comum_id int, constraint pk_resgate primary key (denuncias_id), constraint fk_denuncias foreign key (denuncias_id) references denuncias 
	(solicitacoes_id), constraint fk_comum foreign key (comum_id) references comum (pessoas_id)
);
create table maustratos(
	denuncias_id int, comum_id int, constraint pk_maustratos primary key (denuncias_id), constraint fk_denuncias foreign key (denuncias_id) references denuncias 
	(solicitacoes_id), constraint fk_comum foreign key (comum_id) references comum (pessoas_id)
);
create table animal(
	id serial, raca varchar(50), genero char(1), nome varchar(50), vacinado char(1), idade int, descricao text, porte varchar(7), necessidade_especial text,
	microchipagem char(1), especie varchar(8), castrado char(1), adocao_id int, doacao_id int, servicos_id int, denuncias_id int, constraint pk_animal
	primary key (id), constraint fk_adocao foreign key (adocao_id) references adocao (solicitacoes_id), constraint fk_doacao foreign key (doacao_id)
	references doacao (solicitacoes_id), constraint fk_servicos foreign key (servicos_id) references servicos (solicitacoes_id),
	constraint fk_denuncias foreign key (denuncias_id) references denuncias (solicitacoes_id)
);
create table vacinas(
	id serial, nome varchar(60), animal_id int, constraint pk_vacinas primary key (id), constraint fk_animal foreign key (animal_id) references animal (id)
);