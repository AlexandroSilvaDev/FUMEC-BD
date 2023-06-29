USE bd_empresa

SELECT * FROM EMPREGADO

-- 1. Listar o nome dos empregados da UF=’MG’.

SELECT NOM_EMPREGADO FROM EMPREGADO 
WHERE SIG_UF = 'MG'

-- 2. Listar o nome e o local de todos os projetos.

SELECT NOM_PROJETO, NOM_LOCAL FROM PROJETO

-- 3. Listar todos os departamentos cujo gerente começou após ‘2007-01-01’.

SELECT * FROM DEPARTAMENTO 
WHERE DAT_INICIO_GERENTE > '2007-01-01'

-- 4. Listar o nome e o parentesco de todos os dependentes do sexo masculino.

SELECT NOM_DEPENDENTE, DSC_PARENTESCO FROM DEPENDENTE 
WHERE SEX_DEPENDENTE = 'M'

-- 5. Listar os empregados sem supervisor e da UF igual a ‘MG’

SELECT * FROM empregado 
WHERE sig_uf = 'MG' AND num_matricula_supervisor IS NULL

-- 6. Listar os departamentos sem gerente.

SELECT * FROM departamento 
WHERE num_matricula_gerente IS NULL

-- 7. Listar os empregados do sexo feminino e com salário maior do que R$ 1.500,00.

SELECT * FROM empregado 
WHERE sex_empregado = 'F' AND val_salario > 1500

-- 8. Listar o nome dos projetos controlados pelo departamento 2.

SELECT nom_projeto FROM projeto 
WHERE cod_depto = 2

-- 9. Listar o código e o nome dos projetos cujo local é 'BH', 'RJ' ou 'SP'.

SELECT cod_projeto, nom_projeto FROM projeto 
WHERE nom_local IN ('BH', 'RJ', 'SP')

-- 10. Listar o nome de todas as cidades e UFs distintas dos empregados.

SELECT DISTINCT sig_uf, nom_cidade FROM empregado 

/*
11. Listar o nome e a data de nascimento de todos os empregados em ordem ascendente de
data de nascimento.
*/

SELECT nom_empregado, dat_nascimento FROM empregado 
ORDER BY 2 ASC

/*
12. Listar o nome dos empregados e o salário ordenando por ordem decrescente de salário.
*/

SELECT nom_empregado, val_salario FROM empregado 
ORDER BY 2 DESC

/*
13. Listar o nome distintos dos locais dos projetos cujo nome do projeto possui o texto 'novo'
ou 'nova'.
*/

SELECT DISTINCT nom_local FROM projeto 
WHERE nom_projeto LIKE '%novo%' OR nom_projeto LIKE '%nova%'

/*
14. Listar o nome dos projetos cujo nome começa com 'criar' ou termina com '2005'
*/

SELECT nom_projeto FROM projeto 
WHERE nom_projeto LIKE 'criar%' OR nom_projeto LIKE '%2005'

/*
15. Listar o nome e o salário do empregado de 'MG' com o maior salário (obs: sem usar MAX)
*/

SELECT TOP 1 nom_empregado, val_salario FROM empregado 
WHERE sig_uf = 'MG' 
ORDER BY 2 DESC

/*
16. Criar uma nova tabela chamada “equipe” com as seguintes colunas (TABELA PDF LAB_02):
*/

CREATE TABLE equipe 
(
	cod_equipe			SMALLINT NOT NULL,
	nom_equipe			VARCHAR(100) NOT NULL,
	dat_criacao			SMALLDATETIME NOT NULL DEFAULT GETDATE(),

	CONSTRAINT pk PRIMARY KEY (cod_equipe),
	CONSTRAINT uk UNIQUE (nom_equipe)
);

/*
17. Incluir na tabela “equipe”, usando o comando ALTER TABLE, uma nova coluna “cod_depto”
(NOT NULL) com a respectiva restrição de integridade referencial (FK) para a tabela
departamento.
*/

SP_HELP equipe

SELECT * FROM equipe

ALTER TABLE equipe ADD cod_depto INT
ALTER TABLE equipe ALTER COLUMN cod_depto INT NOT NULL
ALTER TABLE equipe ADD
CONSTRAINT fk_cod_depto
	FOREIGN KEY (cod_depto) 
		REFERENCES departamento (cod_depto)

/*
18. Incluir as seguintes equipes abaixo na tabela (TABELA NO PDF LAB_02):
*/

INSERT INTO equipe VALUES(13, 'Verde', 2007-04-03, 2)
INSERT INTO equipe VALUES(22, 'Vermelha', 2008-02-02, 2)

/*
19. Incluir as seguintes equipes abaixo na tabela (usar valor DEFAULT para a data):
*/

INSERT INTO equipe VALUES(23, 'Azul', DEFAULT, 1)
INSERT INTO equipe VALUES(4, 'Marrom', DEFAULT, 3)

/*
20. Criar coluna “id_equipe” na tabela “equipe” com o tipo de dados “int” e as restrições “NOT
NULL” e “IDENTITY(1,1)”
*/

SELECT * FROM equipe

ALTER TABLE equipe ADD id_equipe INT IDENTITY
ALTER TABLE equipe ALTER COLUMN id_equipe INT NOT NULL 

/*
ALTER TABLE equipe ADD
CONSTRAINT uk_id_equipe UNIQUE (id_equipe)

ALTER TABLE equipe DROP COLUMN id_equipe
*/

/*
21. Incluir a seguinte equipe abaixo na tabela (verificar mensagem de erro ao informar um
valor para a coluna id_equipe que é IDENTITY):
*/

INSERT INTO equipe VALUES(55, 'Rosa', DEFAULT, 1)

/*
22. Alterar o departamento da equipe de nome “Rosa” para 3
*/

UPDATE equipe SET cod_depto = 3
WHERE nom_equipe LIKE 'Rosa'

/*
23. Excluir as equipes do departamento 2 e 3
*/

DELETE FROM equipe 
WHERE cod_depto = 2 OR cod_depto = 3