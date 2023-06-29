CREATE DATABASE bd_pesquisa

USE bd_pesquisa12

-- DROP DATABASE bd_pesquisa

CREATE TABLE titulacao 
(
	id_titulacao		SMALLINT NOT NULL,
	nom_titulacao		VARCHAR(50) NOT NULL,

	PRIMARY KEY (id_titulacao),
	UNIQUE (nom_titulacao)
);

CREATE TABLE professor 
(
	id_prof				INT NOT NULL,
	nom_prof			VARCHAR(100) NOT NULL,
	id_titulacao		SMALLINT NOT NULL,

	PRIMARY KEY (id_prof),
	UNIQUE (nom_prof),
	FOREIGN KEY (id_titulacao)
		REFERENCES titulacao (id_titulacao)
);

CREATE TABLE departamento
(
	id_depto			SMALLINT NOT NULL,
	nom_depto			VARCHAR(100) NOT NULL,
	id_prof				INT NOT NULL,

	PRIMARY KEY (id_depto),
	UNIQUE (nom_depto),
	FOREIGN KEY (id_prof)
		REFERENCES professor (id_prof)
);

CREATE TABLE curso 
(
	id_curso			SMALLINT NOT NULL,
	nom_curso			VARCHAR(100) NOT NULL,
	id_depto			SMALLINT NOT NULL,

	PRIMARY KEY (id_curso),
	UNIQUE (nom_curso),
	FOREIGN KEY (id_depto)
		REFERENCES departamento (id_depto)
);

CREATE TABLE bolsista 
(
	id_bolsista			INT NOT NULL,
	nom_bolsista		VARCHAR(100) NOT NULL,
	id_curso			SMALLINT NOT NULL,
	dsc_email			VARCHAR(50) NOT NULL,
	num_telefone		VARCHAR(25),
	sex_bolsista		CHAR(1) CHECK (sex_bolsista = 'M' OR sex_bolsista = 'F'),

	PRIMARY KEY (id_bolsista),
	UNIQUE (nom_bolsista),
	FOREIGN KEY (id_curso)
		REFERENCES curso (id_curso) 
);

CREATE TABLE projeto 
(
	id_projeto			SMALLINT NOT NULL IDENTITY(1, 1),
	nom_projeto			VARCHAR(100) NOT NULL,
	dsc_projeto			VARCHAR(MAX),
	dat_inicio			SMALLDATETIME NOT NULL DEFAULT GETDATE(),
	dat_fim				SMALLDATETIME,
	val_orcamento		NUMERIC(7, 2) NOT NULL,
	id_prof				INT NOT NULL,

	CONSTRAINT ck
		CHECK ( dat_inicio <= dat_fim ),
	PRIMARY KEY (id_projeto),
	UNIQUE (nom_projeto),
	FOREIGN KEY (id_prof)
		REFERENCES professor (id_prof)
	
);

CREATE TABLE equipe
(
	id_projeto			SMALLINT NOT NULL,
	id_bolsista			INT NOT NULL,
	val_bolsa			NUMERIC(7, 2) NOT NULL CHECK(val_bolsa >= 100),

	CONSTRAINT pk
		PRIMARY KEY (id_projeto, id_bolsista),
	FOREIGN KEY (id_projeto)
		REFERENCES projeto (id_projeto),
	FOREIGN KEY (id_bolsista)
		REFERENCES bolsista (id_bolsista)
);

SELECT * FROM curso 

SP_HELP curso

/*
3.2. Acrescentar na tabela “professor”, usando o comando ALTER TABLE, o campo “sex_prof”
que não permite nulos e é do tipo char(1).
*/

ALTER TABLE professor ADD sex_prof CHAR(1) -- NULL
ALTER TABLE professor ALTER COLUMN sex_prof CHAR(1) NOT NULL 

/*
3.3. Acrescentar, usando o comando ALTER TABLE, uma restrição de CHECK para verificar os
valores (‘M’ ou ‘F’) no campo “sex_prof” criado.
*/

ALTER TABLE professor 
ADD CONSTRAINT CK_sex_prof 
	CHECK(sex_prof = 'M' OR sex_prof = 'F')

/*
3.4. Criar uma tabela de área de conhecimento “area_conhecimento” com os campos
“id_area_conhecimento” (smallint, NOT NULL, PRIMARY KEY) e “dsc_area_conhecimento”
(varchar(100), NOT NULL, UNIQUE).
*/

CREATE TABLE area_conhecimento
(
	id_area_conhecimento		SMALLINT NOT NULL,
	dsc_area_conhecimento		VARCHAR(100) NOT NULL,

	CONSTRAINT pk_id_area_conhecimento PRIMARY KEY (id_area_conhecimento),
	CONSTRAINT un_dsc_area_conhecimento UNIQUE (dsc_area_conhecimento)
);

/*
3.5. Acrescentar na tabela “curso”, usando o comando ALTER TABLE, o campo
“id_area_conhecimento”, que permite nulos, com uma restrição de FOREIGN KEY para o
campo correspondente na tabela “area_conhecimento”.
*/

ALTER TABLE curso ADD id_area_conhecimento SMALLINT
ALTER TABLE curso ALTER COLUMN id_area_conhecimento SMALLINT NOT NULL
ALTER TABLE curso ADD 
CONSTRAINT fk_id_area_conhecimento 
	FOREIGN KEY (id_area_conhecimento)
		REFERENCES area_conhecimento (id_area_conhecimento)

/*
3.6. Salve o script com o nome “SeuNome_lab1.SQL” e submeta pelo SINEF.
*/