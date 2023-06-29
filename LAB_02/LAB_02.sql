USE bd_empresa

SELECT * FROM EMPREGADO

-- 1. Listar o nome dos empregados da UF=’MG’.

SELECT NOM_EMPREGADO FROM EMPREGADO WHERE SIG_UF = 'MG'

-- 2. Listar o nome e o local de todos os projetos.

SELECT NOM_PROJETO, NOM_LOCAL FROM PROJETO

-- 3. Listar todos os departamentos cujo gerente começou após ‘2007-01-01’.

SELECT * FROM DEPARTAMENTO WHERE DAT_INICIO_GERENTE > '2007-01-01'

-- 4. Listar o nome e o parentesco de todos os dependentes do sexo masculino.

SELECT NOM_DEPENDENTE, DSC_PARENTESCO FROM DEPENDENTE WHERE SEX_DEPENDENTE = 'M'

-- 5. Listar os empregados sem supervisor e da UF igual a ‘MG’

