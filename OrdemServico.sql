-- show tables
-- show databases
-- drop table tabela
-- use information_schema
-- select * from referential_constraints where constraint_schema = 'ordemservico'

-- criação do banco de dados para o cenário de ordem de serviço

create database	ordemservico;
use ordemservico;

-- criar tabela cliente

create table cliente(
	idCliente int auto_increment primary key,
    Nome varchar(45),
    CPF char(11) not null,
    Endereco varchar(45),
    constraint unique_cpf_cliente unique(CPF)
);

alter table cliente auto_increment=1;

insert into cliente(Nome,CPF,Endereco) values
('Maria M Silva',493747493,'Rua abc,124 Casa Amarela - São Paulo'),
('Joao Silva Oliveira',390485903,'Rua xyz, 9374 apto 15 Limão - São Paulo'),
('Pedro Santos',03745037,'Av paulista,1000 Curitiba - Paraná'),
('Ana Paula Campos',0348590348,'Rua Aricanduva, 947 Aruja - Rio de Janeiro')

select * from cliente

-- criar tabela veiculo

create table veiculo(
	idVeiculo int auto_increment primary key,
    idCliente int,
    Placa varchar(10) not null,
    Marca varchar(15),
    Modelo varchar(15),
    Ano int,
    Cor varchar(10),
    constraint unique_carro_Placa unique(Placa),
    constraint fk_carro_cliente foreign key (idCliente) references cliente(idCliente)
);

alter table veiculo auto_increment=1;

insert into veiculo(idCliente,Placa,Marca,Modelo,Ano,Cor) values
(1,'ZYB9473','GM','Celta',2015,'Azul'),
(1,'ABC1244','GM','Onix',2020,'Branco'),
(2,'A45CB94','Vokswagen','Gol',2017,'Preto'),
(3,'ABC9474','Nissan','Versa',2022,'Prata'),
(4,'C94CB97','BMW','I3',2021,'Vermelho')

select * from veiculo

-- criar tabela cliente_veiculo_ordem

create table cliordem(
	idVeiculo int,
    idCliente int,
	idOrdem int,
    constraint fk_cliordem_veiculo foreign key (idVeiculo) references veiculo(idVeiculo),
    constraint fk_cliordem_cliente foreign key (idCliente) references cliente(idCliente),
    constraint fk_cliordem_ordem foreign key (idVeiculo) references ordemservico(idOrdem)
);

insert into cliordem(idVeiculo,idCliente,idOrdem) values
(1,1,1),
(2,2,2),
(3,4,3),
(4,2,4),
(5,1,5),
(1,2,6),
(2,1,7);

select * from cliordem;

-- criar tabela ordem de serviço

create table ordemservico(
	idOrdem int auto_increment primary key,
    DataEmissao date,
    Valor float,
    Situacao enum('Em avaliação','Em atendimento','Aguardando aprovacao do orçamento','Concluído') default 'Em avaliação',
    DataEntrega date,
    IdEquipe int,
    constraint fk_ordem_equipe foreign key (idEquipe) references equipe(idEquipe)
);

alter table ordemservico auto_increment=1;

insert into ordemservico(DataEmissao,Valor,Situacao,DataEntrega,IdEquipe) values
('2022-09-12',650,'Em atendimento','2022-09-12',1),
('2022-05-11',1520,'Concluído','2022-05-12',2),
('2022-09-10',750,'Concluído','2022-09-07',3),
('2022-09-09',350,'Concluído','2022-09-03',2),
('2022-09-09',1250,'Em atendimento','2022-09-10',4),
('2022-09-09',400,'Em avaliação','2022-09-08',4),
('2022-09-07',550,'Aguardando aprovacao do orçamento','2022-09-05',2);

/*
update ordemservico
set idEquipe = 4 where
idOrdem = 5 or idOrdem = 6
*/

select * from ordemservico;

-- criar tabela mão de obra

create table maodeobra(
	idServicos int auto_increment primary key,
    Descricao varchar(45) not null,
    Valor float,
    constraint unique_descser unique(Descricao)
);

alter table maodeobra auto_increment=1;

insert into maodeobra(Descricao,Valor) values
('Alinhamento', 235),
('Balanceamento', 100),
('Regulagem de freios', 75),
('Troca de oleo', 130),
('Vistoria', 150)

select * from maodeobra


-- criar tabela mão de obra da ordem serviço

create table ormaoobra(
	idOrdem int,
	idServicos int,
    constraint fk_ormaoobra_ordem foreign key (idOrdem) references ordemservico(idOrdem),
    constraint fk_ormaoobra_servicos foreign key (idServicos) references maodeobra(idServicos)
);

insert into ormaoobra(idOrdem,idServicos) values
(1,2),
(1,3),
(2,2),
(2,4),
(3,1),
(3,2),
(4,4),
(5,1),
(6,3),
(7,5)

select * from ormaoobra;

-- criar tabela peças

create table peca(
	idPeca int auto_increment primary key,
    Descricao varchar(45) not null,
    Valor float,
    constraint unique_descricao unique(Descricao)
);

alter table peca auto_increment=1;

insert into peca(Descricao,Valor) values
('cambio', 950),
('pastilha de freio', 50),
('oleo', 150),
('pneu', 200.5)

select * from peca

-- criar tabela peças da ordem de serviço

create table orpecas(
	idOrdem int,
    idPeca int,
    constraint fk_orpeca_ordem foreign key (idOrdem) references ordemservico(idOrdem),
    constraint fk_orpeca_peca foreign key (idPeca) references peca(idPeca)
);

insert into orpecas(idOrdem,idPeca) values
(1,2),
(1,3),
(2,2),
(2,4),
(3,1),
(3,2),
(4,4),
(5,1),
(6,3),
(7,3)

select * from orpecas;

-- criar tabela equipe

create table equipe(
	idEquipe int auto_increment primary key,
    Nome varchar(45) not null,
    constraint unique_nome unique(Nome)
);

alter table equipe auto_increment=1;

insert into equipe(Nome) values
('Equipe Atendimento'),
('Box 01'),
('Box 02'),
('Box 03')

select * from equipe

-- criar tabela mecanico

create table mecanico(
	idMecanico int auto_increment primary key,
    Nome varchar(45) not null,
    Endereco varchar(45) not null,
    idEspecialidade int, 
    idEquipe int,
    constraint fk_mecanico_especilidade foreign key (idEspecialidade) references especialidade(idEspecialidade),
    constraint fk_mecanico_equipe foreign key (idEquipe) references equipe(idEquipe)
);

alter table mecanico auto_increment=1;

insert into mecanico(Nome,Endereco,idEspecialidade,idEquipe) values
('João da Silva', 'Av Paulista, 274 - São Paulo - SP', 1, 2),
('Joaquim Oliveira', 'Rua teste, 1234 - São Paulo - SP', 1, 3),
('Ana Lucia', 'Av 24 de maio, 1274 - São Paulo - SP', 1, 4),
('Pedro Vicente', 'Rua Piratininga, 2947 - São Paulo - SP', 1, 1),
('Artur dos Santos', 'Av Paulista, 243 - São Paulo - SP', 1, 4),
('Antonio Xavier','Rua Joaquim Floriano, 1000 - São Paulo - SP', 2,3);

select * from mecanico

-- criar tabela especialidade

create table especialidade(
	idEspecialidade int auto_increment primary key,
    Descricao varchar(45) not null,
    constraint unique_descricao unique(Descricao)
);

alter table especialidade auto_increment=1;

insert into especialidade(Descricao) values
('Carros Classicos'),
('Motos'),
('Funilaria'),
('Veículos a Diesel')

select * from especialidade



-- Questões --

-- 1. Quais os veículos em atendimento?

select v.Modelo, v.Marca, v.Placa, os.situacao from veiculo as v
	inner join cliordem as c on c.idVeiculo = v.idVeiculo
	inner join ordemservico as os on c.idOrdem = os.idOrdem 
    having  os.situacao = 'Em atendimento'

-- 2. Em quantas ordem de serviço cada equipe atuou?

select e.nome, count(os.idOrdem) as 'Ordens' from equipe as e
	inner join ordemservico as os on os.idEquipe = e.idEquipe
    group by e.nome

-- 3. Mão de Obra mais solicitada

select mao.Descricao, count(ord.idOrdem) as 'Ordens' from maodeobra as mao 
	inner join ormaoobra as ord on ord.idServicos = mao.idServicos
    group by mao.Descricao 
    ORDER BY count(ord.idOrdem) desc
    LIMIT 1