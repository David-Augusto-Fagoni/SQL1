
CREATE DATABASE fornecedor_produto
GO
USE fornecedor_produto
GO
CREATE TABLE cliente
(
	cpf CHAR(11) NOT NULL,
	nome VARCHAR(100) NOT NULL,
	telefone CHAR(13) NOT NULL
	PRIMARY KEY (cpf)
)
GO
CREATE TABLE fornecedor
(
	id INT IDENTITY(1, 1) NOT NULL,
	nome VARCHAR(100) NOT NULL,
	logr_end VARCHAR(50) NOT NULL,
	num_end INT NOT NULL,
	compl_end VARCHAR(50) NOT NULL,
	cidade_end VARCHAR(50) NOT NULL
	PRIMARY KEY (id)
)
GO
CREATE TABLE produto
(
	codigo INT IDENTITY(1, 1) NOT NULL,
	descricao VARCHAR(100) NOT NULL,
	fornecedor INT NOT NULL,
	preco DECIMAL(7, 2) NOT NULL
	PRIMARY KEY (codigo)
	FOREIGN KEY (fornecedor) REFERENCES fornecedor (id)
)
GO
CREATE TABLE venda
(
	codigo INT NOT NULL,
	produto INT NOT NULL,
	cliente CHAR(11) NOT NULL,
	quantidade INT NOT NULL,
	valor_total DECIMAL(7, 2) NOT NULL,
	data_venda DATE NOT NULL
	PRIMARY KEY (codigo, produto, cliente)
	FOREIGN KEY (produto) REFERENCES produto (codigo),
	FOREIGN KEY (cliente) REFERENCES cliente (cpf)
)
GO
INSERT INTO cliente 
VALUES 
('34578909290',	'Julio Cesar',	 '82736541'),
('25186533710',	'Maria Antonia', '87652314'),
('87627315416',	'Luiz Carlos',	 '61289012'),
('79182639800',	'Paulo Cesar',	 '90765273')
GO
INSERT INTO fornecedor
VALUES
('LG',	'Rod. Bandeirantes',	70000,	'Km 70',	'Itapeva'),
('Asus',	'Av. Nações Unidas',	10206,	'Sala 225',	'São Paulo'),
('AMD',	'Av. Nações Unidas',	10206,	'Sala 1095',	'São Paulo'),
('Leadership',	'Av. Nações Unidas',	10206,	'Sala 87',	'São Paulo'),
('Inno',	'Av. Nações Unidas',	10206,	'Sala 34',	'São Paulo')
GO
INSERT INTO produto
VALUES
('Monitor 19 pol.',	1,	449.99),
('Netbook 1GB Ram 4 Gb HD',	2,	699.99),
('Gravador de DVD - Sata',	1,	99.99),
('Leitor de CD',	1,	49.99),
('Processador - Phenom X3 - 2.1GHz',	3,	349.99),
('Mouse',	4,	19.99),
('Teclado',	4,	25.99),
('Placa de Video - Nvidia 9800 GTX - 256MB/256 bits',	5,	599.99)

INSERT INTO venda
VALUES
(1,	1,	'25186533710',	1,	449.99,	 '2009-09-03'),
(1,	4,	'25186533710',	1,	49.99,	 '2009-09-03'),
(1,	5,	'25186533710',	1,	349.99,	 '2009-09-03'),
(2,	6,	'79182639800',	4,	79.96,	 '2009-09-06'),
(3,	8,	'87627315416',	1,	599.99,  '2009-09-06'),
(3,	3,	'87627315416',	1,	99.99,	 '2009-09-06'),
(3,	7,	'87627315416',	1,	25.99,   '2009-09-06'),
(4,	2,	'34578909290',	2,	1399.98, '2009-09-08')
GO

ALTER TABLE fornecedor 
ADD telefone CHAR(13)
GO
UPDATE fornecedor 
SET telefone = '72165371'
WHERE id = 1

UPDATE fornecedor 
SET telefone = '87153738'
WHERE id = 2

UPDATE fornecedor 
SET telefone = '36546289'
WHERE id = 4

-- Data da Venda 4
SELECT CONVERT(varchar,data_venda, 103)
FROM venda
WHERE codigo = 4

-- Consultar por ordem alfabética de nome, o nome, o enderço concatenado e o telefone dos fornecedores
SELECT nome, cidade_end+' '+logr_end+' '+CAST(num_end AS varchar)+' '+compl_end AS endereco, telefone
FROM fornecedor
ORDER BY nome

-- Produto, quantidade e valor total do comprado por Julio Cesar
SELECT c.nome AS nome_cliente,p.descricao, CAST(v.quantidade AS varchar)AS quant,CAST(v.valor_total AS varchar) AS total
FROM cliente AS c, venda AS v, produto AS p
WHERE c.cpf = v.cliente AND v.produto = p.codigo  AND c.nome LIKE 'Julio%'

-- Data, no formato dd/mm/aaaa e valor total do produto comprado por  Paulo Cesar
SELECT c.nome, CONVERT(varchar,v.data_venda, 103) AS data_venda, CAST(v.valor_total AS varchar) AS total
FROM cliente AS c, venda AS v
WHERE c.cpf = v.cliente AND c.nome LIKE 'Paulo%'

-- Consultar, em ordem decrescente, o nome e o preço de todos os produtos 
SELECT descricao, CAST(preco AS varchar) AS preco
FROM produto
ORDER BY descricao DESC, preco DESC