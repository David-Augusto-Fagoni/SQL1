CREATE DATABASE hospital
GO
USE hospital
GO
CREATE TABLE paciente
(
	cpf CHAR(11) NOT NULL,
	nome VARCHAR(100) NOT NULL,
	rua_end VARCHAR(50) NOT NULL,
	num_end INT NOT NULL,
	bairro_end VARCHAR(30) NOT NULL,
	telefone CHAR(13) NULL,
	data_nasc DATE NOT NULL
	PRIMARY KEY (cpf)
)
GO
CREATE TABLE medico
(
	codigo INT IDENTITY(1, 1) NOT NULL,
	nome VARCHAR(100) NOT NULL,
	especialidade VARCHAR(30) NOT NULL
	PRIMARY KEY (codigo)
)
GO
CREATE TABLE prontuario
(
	data_pront DATE NOT NULL,
	cpf_paciente CHAR(11) NOT NULL,
	codigo_medico INT NOT NULL,
	diagnostico VARCHAR(100) NOT NULL,
	medicamento VARCHAR(30) NOT NULL
	PRIMARY KEY (data_pront, cpf_paciente, codigo_medico)
	FOREIGN KEY (cpf_paciente) REFERENCES paciente (cpf),
	FOREIGN KEY (codigo_medico) REFERENCES medico (codigo)
)
GO
INSERT INTO paciente
VALUES
('35454562890',	'Jos� Rubens',	'Campos Salles',	2750,	'Centro',	'21450998',	'1954-10-18'),
('29865439810',	'Ana Claudia',	'Sete de Setembro',	178,	'Centro',	'97382764',	'1960-05-29'),
('82176534800',	'Marcos Aur�lio',	'Tim�teo Penteado',	236,	'Vila Galv�o',	'68172651',	'1980-09-24'),
('12386758770',	'Maria Rita',	'Castello Branco',	7765,	'Vila Ros�lia',	NULL,	'1975-03-30'),
('92173458910',	'Joana de Souza',	'XV de Novembro',	298,	'Centro',	'21276578',	'1944-04-24')
GO
INSERT INTO medico
VALUES
('Wilson Cesar',	'Pediatra'),
('Marcia Matos',	'Geriatra'),
('Carolina Oliveira',	'Ortopedista'),
('Vinicius Araujo',	'Cl�nico Geral')
GO
INSERT INTO prontuario
VALUES
('2020-09-10',	'35454562890',	2,	'Reumatismo',	'Celebra'),
('2020-09-10',	'92173458910',	2,	'Renite', 'Al�rgica	Allegra'),
('2020-09-12',	'29865439810',	1,	'Inflama��o de garganta',	'Nimesulida'),
('2020-09-13',	'35454562890',	2,	'H1N1',	'Tamiflu'),
('2020-09-15',	'82176534800',	4,	'Gripe',	'Resprin'),
('2020-09-15',	'12386758770',	3,	'Bra�o Quebrado',	'Dorflex + Gesso')

-- Nome e Endere�o (concatenado) dos pacientes com mais de 50 anos
SELECT nome,rua_end+' '+CAST(num_end AS VARCHAR)+' '+bairro_end AS Endereco
FROM paciente
WHERE DATEDIFF(YEAR, data_nasc,GETDATE()) < 50

-- Qual a especialidade de Carolina Oliveira
SELECT nome, especialidade
FROM medico
WHERE nome = 'Carolina Oliveira'

-- Qual medicamento receitado para reumatismo
SELECT medicamento
FROM prontuario
WHERE diagnostico = 'reumatismo'

-- Diagn�stico e Medicamento do paciente Jos� Rubens em suas consultas
SELECT p.nome,pr.data_pront ,pr.diagnostico
FROM paciente as p
INNER JOIN prontuario AS pr ON p.cpf = pr.cpf_paciente
WHERE p.nome LIKE 'Jos�%'

-- Nome e especialidade do(s) M�dico(s) que atenderam Jos� Rubens. Caso a especialidade tenha mais de 3 letras, mostrar apenas as 3 primeiras letras concatenada com um ponto final (.)
SELECT m.nome,
CASE WHEN LEN(m.especialidade) > 3
	THEN
		SUBSTRING(m.especialidade,1,3) +'.'
	ELSE
	    m.especialidade
	END AS especialidade,
	pa.nome
FROM medico AS m, prontuario as p, paciente as pa
WHERE m.codigo = p.codigo_medico AND p.cpf_paciente = pa.cpf AND pa.nome LIKE 'Jos�%'

-- CPF (Com a m�scara XXX.XXX.XXX-XX), Nome, Endere�o completo (Rua, n� - Bairro), Telefone (Caso nulo, mostrar um tra�o (-)) dos pacientes do m�dico Vinicius
SELECT m.nome AS nome_medico, 
SUBSTRING(pa.cpf,1,3)+'.'+SUBSTRING(pa.cpf,4,3)+'.'+SUBSTRING(pa.cpf,7,3)+'-'+SUBSTRING(pa.cpf,10,2) AS cpf, 
pa.nome AS nome_paciente,
pa.rua_end+', '+CAST(pa.num_end AS varchar)+'� - '+pa.bairro_end AS endereco,
CASE WHEN (pa.telefone IS NULL)
	THEN
		'-'
	ELSE
		pa.telefone
	END AS telefone
FROM medico AS m, prontuario as p, paciente as pa
WHERE m.codigo = p.codigo_medico AND p.cpf_paciente = pa.cpf AND m.nome LIKE 'Vinicius%'

-- Quantos dias fazem da consulta de Maria Rita at� hoje
SELECT pa.nome,DATEDIFF(DAY,p.data_pront,GETDATE()) AS dias
FROM paciente AS pa, prontuario AS p
WHERE pa.cpf = p.cpf_paciente AND pa.nome LIKE 'Maria%'

-- Alterar o telefone da paciente Maria Rita, para 98345621
UPDATE paciente
SET telefone = '98345621'
WHERE nome = 'Maria Rita'

-- Alterar o Endere�o de Joana de Souza para Volunt�rios da P�tria, 1980, Jd. Aeroporto
UPDATE paciente 
SET rua_end = 'Volunt�rios da P�tria', num_end = 1980, bairro_end = 'Jd. Aeroporto'
WHERE nome LIKE 'Joana de Souza'

