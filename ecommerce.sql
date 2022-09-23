-- criação do banco de dados para o cenário de e-commerce

create database	ecommerce;
use ecommerce;

/* deletando as tabelas
drop table pagamento;
drop table pedido;
drop table prod_ped;
drop table vendedor;
drop table prod_vend;
drop table prod_estoque;
drop table estoque;
*/

-- criar tabela cliente

create table cliente(
	idCliente int auto_increment primary key,
    Fname varchar(15),
    Mname varchar(10),
    Lname varchar(15),
    CPF char(11) not null,
    Endereco varchar(45),
    DataNasc date,
    constraint unique_cpf_cliente unique(CPF)
);

alter table cliente auto_increment=1;
insert into cliente(Fname,Mname,Lname,CPF,Endereco,DataNasc) values
('Maria','M','Silva',493747493,'Rua abc,124 Casa Amarela - São Paulo','1980-02-10'),
('Joao','Silva','Oliveira',390485903,'Rua xyz, 9374 apto 15 Limão - São Paulo','1995-03-25'),
('Pedro','','Santos',03745037,'Av paulista,1000 Curitiba - Paraná','1990-01-07'),
('Ana','Paula','Campos',0348590348,'Rua Aricanduva, 947 Aruja - Rio de Janeiro','2001-04-05')

-- select * from cliente

-- criar tabela produto

create table produto(
	idProduto int auto_increment primary key,
	Descricao varchar(45) not null,
    Categoria enum('Eletronico', 'Vestimenta','Brinquedos','Alimentos','Moveis') not null,
	Avaliacao float default 0,
    Dimensoes varchar(10),
    Valor decimal(18,2)
);

alter table produto auto_increment=1;
insert into produto(Descricao,Categoria,Avaliacao,Dimensoes,Valor) values
('Boneca','Brinquedos',4,'45x25x15',35.50),
('Mesa','Moveis',3,'80x145x80',435.50),
('Celular','Eletronico',4,'15x45x3.5',1029.9),
('Jogo','Brinquedos',5,'45x25x15',350.75)

-- select * from produto

-- criar tabela pagamento

create table pagamento(
	idPagamento int auto_increment,
    idPagamentoCliente int,
	tipoPagamento enum('Boleto','Pix','Cartão') default 'Cartão',
	NumeroCartao varchar(45),
    Nome varchar(45),
    Validade date,
    primary key (idPagamento, idPagamentoCliente,tipoPagamento,NumeroCartao),
    constraint fk_pagamento_cliente foreign key (idPagamentoCliente) references cliente(idCliente)
);

alter table pagamento auto_increment=1;

insert into pagamento(idPagamentoCliente,tipoPagamento,NumeroCartao,Nome,Validade) values
('1',default,'MariaMSilva','390994509348','2025-07-01'),
('1',default,'MariaSilva','398450938598','2023-10-10'),
('2','Boleto','','',null),
('3',default,'PedroS','9038459038','2024-04-01'),
('4',default,'AnaPCampos','304895034','2027-06-01')

select * from pagamento;

-- criar tabela pedido

create table pedido(
	idPedido int auto_increment primary key,
    idPedidoCliente int,
    PedidoStatus enum('Cancelado','Confirmado','Em Processamento') default 'Em Processamento',
    Descricao varchar(255),
    Frete float default 0,
    Rastreio varchar(45),
    idPedidoPagamento int,
    constraint fk_pedido_cliente foreign key (idPedidoCliente) references cliente(idCliente), 
	constraint fk_pedido_pagamento foreign key (idPedidoPagamento) references pagamento(idPagamento)
);

alter table pedido auto_increment=1;

insert into pedido(idPedidoCliente,PedidoStatus,Descricao,Frete,Rastreio,idPedidoPagamento) values
('1','Confirmado','Compra via aplicativo',35,'ZB03045',6),
('2',default,'Compra via website',20,'',8),
('1','Confirmado','Compra via website',35,'ZB03045',7),
('4','Confirmado','Compra via aplicativo',35,'ZB03045',10)

select * from pedido

-- criar tabela fornecedor

create table fornecedor(
	idFornecedor int auto_increment primary key,
    RazaoSocial varchar(45),
	CNPJ char(16) not null,
    Endereco varchar(45),
    constraint unique_cnpj_fornecedor unique(CNPJ)
);

alter table fornecedor auto_increment=1;

insert into fornecedor(RazaoSocial,CNPJ,Endereco) values
('Amazon',493747493,'Rua abc,124 Casa Amarela - São Paulo'),
('Armarinhos Fernando',390485903,'Rua xyz, 9374 apto 15 Limão - São Paulo'),
('Submarino',03745037,'Av paulista,1000 Curitiba - Paraná'),
('Americanas',0348590348,'Rua Aricanduva, 947 Aruja - Rio de Janeiro')

select * from fornecedor

-- criar tabela estoque

create table estoque(
	idEstoque int auto_increment primary key,
    Localizacao varchar(45) not null
);

alter table estoque auto_increment=1;

insert into estoque(Localizacao) values
('Santos - SP'),
('São Paulo - SP'),
('Curitiba - PR'),
('Rio de Janeiro - RJ')

select * from estoque;

-- criar tabela produto no estoque

create table prod_estoque(
	idEstoque int,
    idProduto int,
    Quantidade int,
    primary key (idEstoque, idProduto),
    constraint fk_estoque foreign key (idEstoque) references estoque(idEstoque),
    constraint fk_produto foreign key (idProduto) references produto(idProduto)
);

insert into prod_estoque(idEstoque,idProduto,Quantidade) values
(1,1,10),
(1,2,5),
(2,2,25),
(2,3,40),
(3,1,15),
(3,2,7),
(3,3,2),
(3,4,5),
(4,1,2),
(4,3,8)

select * from prod_estoque

-- criar tabela terceiro vendedor

create table vendedor(
	idVendedor int auto_increment primary key,
    RazaoSocial varchar(45),
	CNPJ char(16) not null,
    Endereco varchar(45),
    constraint unique_cnpj_vendedor unique(CNPJ)
);

alter table vendedor auto_increment=1;

insert into vendedor(RazaoSocial,CNPJ,Endereco) values
('Amazon 92974',493747493,'Rua abc,124 Casa Amarela - São Paulo'),
('Armarinhos Fernando 394',390485903,'Rua xyz, 9374 apto 15 Limão - São Paulo'),
('Submarino 0459',03745037,'Av paulista,1000 Curitiba - Paraná'),
('Americanas 0349',0348590348,'Rua Aricanduva, 947 Aruja - Rio de Janeiro')

select * from vendedor

-- criar tabela disponibilizando produto

create table disponivel(
    idProduto int,
    idFornecedor int,
    primary key (idProduto, idFornecedor),
    constraint fk_disponivel_produto foreign key (idProduto) references produto(idProduto),
    constraint fk_disponivel_fornecedor foreign key (idFornecedor) references fornecedor(idFornecedor)
);

insert into disponivel(idProduto,idFornecedor) values
(1,4),
(2,3),
(1,2),
(3,2)

-- criar tabela produtos por vendedor terceiro

create table prod_vend(
	idVendedor int,
    idProduto int,
    quantidade int,
    primary key (idVendedor, idProduto),
    constraint fk_prodvend_vendedor foreign key (idVendedor) references vendedor(idVendedor),
    constraint fk_prodvend_produto foreign key (idProduto) references produto(idProduto)
);

insert into prod_vend(idVendedor,idProduto,quantidade) values
(1,4,10),
(2,3,5),
(1,2,7),
(3,2,15)

select * from prod_vend

-- criar tabela produto por pedido

create table prod_ped(
	idPedido int,
    idProduto int,
    quantidade int,
    primary key (idPedido, idProduto),
    constraint fk_prodped_vendedor foreign key (idPedido) references pedido(idPedido),
    constraint fk_prodped_produto foreign key (idProduto) references produto(idProduto)
);

insert into prod_ped(idPedido,idProduto,quantidade) values
(5,4,3),
(6,3,1),
(7,2,2),
(8,2,1)

-- show tables
-- show databases
-- use information_schema
-- select * from referential_constraints where constraint_schema = 'ecommerce'

-- Questões --

-- 1. Demonstar quantidade de produtos vendidos - produto, quantidade

select p.descricao, SUM(ped.quantidade) 
from produto p
left join prod_ped ped
on p.idProduto = ped.idProduto
group by p.idProduto

-- 2. Tipo de pagamento mais utilizado

select pg.tipoPagamento, count(pg.tipoPagamento)
from pagamento pg
join pedido ped
on pg.idPagamento = ped.idPedidoPagamento
group by pg.tipoPagamento

-- 3. Clientes mais ativos a partir do segundo pedido

select concat(Fname, ' ', Mname, ' ', Lname) as nome, count(ped.idPedidoCliente) as 'Quantidade Pedidos'
from cliente c, pedido ped
where c.idCliente = ped.idPedidoCliente
group by c.idCliente
having count(ped.idPedidoCliente) > 1
