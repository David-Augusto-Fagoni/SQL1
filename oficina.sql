CREATE DATABASE oficina
GO
USE oficina
GO
CREATE TABLE carro
(
	placa CHAR(7) NOT NULL,
	marca VARCHAR(20) NOT NULL,
	modelo VARCHAR(20) NOT NULL,
	cor VARCHAR(15) NOT NULL,
	ano INT NOT NULL
	PRIMARY KEY (placa)
)
GO
CREATE TABLE cliente
(
	nome VARCHAR(100) NOT NULL,
	logr_end VARCHAR(50) NOT NULL,
	num_end INT NOT NULL,
	bairro_end VARCHAR(25) NOT NULL,
	telefone CHAR(13) NOT NULL,
	carro CHAR(7) NOT NULL
	PRIMARY KEY(carro)
	FOREIGN KEY (carro) REFERENCES carro (placa)
)
GO
CREATE TABLE peca
(
	codigo INT IDENTITY(1, 1) NOT NULL,
	nome VARCHAR(30) NOT NULL,
	valor DECIMAL(7, 2) NOT NULL
	PRIMARY KEY(codigo)
)
GO
CREATE TABLE servico
(
	carro CHAR(7) NOT NULL,
	peca INT NOT NULL,
	quantidade INT NOT NULL,
	valor DECIMAL(7, 2) NOT NULL,
	data_servico DATE NOT NULL
	PRIMARY KEY (carro, peca, data_servico)
	FOREIGN KEY (carro) REFERENCES carro (placa),
	FOREIGN KEY (peca) REFERENCES peca (codigo)
)
GO
INSERT INTO carro 
VALUES
('AFT9087', 'VW', 'Gol'NN 'Preto', 2007),
('DXO9876', 'Ford', 'Ka', 'Azul', 2000),
('EGT4631', 'Renault', 'Clio', 'Verde', 2004),
('LKM7380', 'Fiat', 'Palio', 'Prata', 1997),
('BCD7521', 'Ford', 'Fiesta', 'Preto', 1999)
GO
INSERT INTO cliente 
VALUES
('Jo�o Alves', 'R. Pereira Barreto', 1258, 'Jd. Oliveiras', '21549658', 'DXO9876'),
('Ana Maria', 'R. 7 de Setembro',	259, 'Centro',	'96588541', 'LKM7380'),
('Clara Oliveira', 'Av. Na��es Unidas', 10254, 'Pinheiros', '24589658', 'EGT4631'),
('Jos� Sim�es', 'R. XV de Novembro', 36, '�gua Branca',	'78952459', 'BCD7521'),
('Paula Rocha', 'R. Anhaia', 548, 'Barra Funda', '69582548', 'AFT9087')
GO
INSERT INTO peca
VALUES 
('Vela',	70),
('Correia Dentada',	125),
('Trambulador',	90),
('Filtro de Ar',	30)
GO
INSERT INTO servico 
VALUES
('DXO9876',	1,	4,	280, '2020-08-01'),
('DXO9876',	4,	1,	30, '2020-08-01'),
('EGT4631',	3,	1,	90, '2020-08-02'),
('DXO9876',	2,	1,	125, '2020-08-07')

-- Telefone do dono do carro Ka, Azul
SELECT c.telefone, c.nome, ca.modelo
FROM cliente as c
INNER JOIN carro as ca ON c.carro = ca.placa
WHERE ca.modelo = 'Ka'

-- Endere�o concatenado do cliente que fez o servi�o do dia 2020-08-02
SELECT c.bairro_end + ' '+c.logr_end+' '+CAST(c.num_end AS varchar) AS Endereco
FROM cliente as c
INNER JOIN servico as s ON c.carro = s.carro
WHERE s.data_servico = '2020-08-02'

-- Placas dos carros de anos anteriores a 2001
SELECT placa, ano
FROM carro
WHERE ano < 2001

-- Marca, modelo e cor, concatenado dos carros posteriores a 2005
SELECT marca+' '+modelo+' '+cor
FROM carro
WHERE ano > 2005

-- C�digo e nome das pe�as que custam menos de R$80,00
SELECT codigo, nome, valor
FROM peca
WHERE valor < 80