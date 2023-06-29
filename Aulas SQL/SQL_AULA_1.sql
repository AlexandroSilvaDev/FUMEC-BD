--MINHA MAQUINA = 23

SELECT * FROM INFORMATION_SCHEMA.TABLES

CREATE TABLE SETOR 
(
	COD_SETOR	INT NOT NULL,
	NOM_SETOR	VARCHAR(100) NOT NULL,

	PRIMARY KEY (COD_SETOR),
	UNIQUE (NOM_SETOR)
);

CREATE TABLE FUNCIONARIO
(
	COD_FUNCIONARIO		INT NOT NULL,
	NOM_FUNCIONARIO		VARCHAR(100) NOT NULL,
	COD_SETOR			INT NOT NULL,

	PRIMARY KEY (COD_FUNCIONARIO),
	FOREIGN KEY (COD_SETOR)	
		REFERENCES SETOR(COD_SETOR)
);

CREATE TABLE SOLICITACAO 
(
	COD_SOLICITACAO		INT NOT NULL,
	COD_FUNCIONARIO		INT NOT NULL,
	DESC_ASSUNTO		VARCHAR(200) NOT NULL,
	DATA_ABERTURA		DATE NOT NULL,
	DATA_ENCERRAMENTO	DATE,
	DESC_SOLICITACAO	VARCHAR(200) NOT NULL,

	PRIMARY KEY (COD_SOLICITACAO),
	FOREIGN KEY (COD_FUNCIONARIO)
		REFERENCES FUNCIONARIO(COD_FUNCIONARIO)
);

CREATE TABLE ATENDIMENTO
(
	SEQ_ATENDIMENTO		INT NOT NULL,
	COD_ATENDENTE		INT NOT NULL,
	COD_SOLICITACAO		INT NOT NULL,
	DATA_ATENDIMENTO	DATE NOT NULL,
	NUM_HORAS			TIME NOT NULL,

	PRIMARY KEY (SEQ_ATENDIMENTO),
	UNIQUE (COD_ATENDENTE, COD_SOLICITACAO, DATA_ATENDIMENTO),
	FOREIGN KEY (COD_ATENDENTE)
		REFERENCES FUNCIONARIO(COD_FUNCIONARIO),
	FOREIGN KEY (COD_SOLICITACAO)
		REFERENCES SOLICITACAO(COD_SOLICITACAO)
);