/*
1. Listar o nome dos empregados que estão alocados em projetos 
(OBS: apresentar 3 soluções: uma com IN/NOT IN, EXISTS/NOT EXISTS e JOIN/LEFT/RIGHT)
*/

-- JOIN

SELECT DISTINCT e.nom_empregado 
FROM empregado AS e
INNER JOIN alocacao AS a
	ON e.num_matricula = a.num_matricula

-- IN

SELECT e.nom_empregado 
FROM empregado AS e
WHERE e.num_matricula IN 
( 
	SELECT num_matricula
	FROM alocacao 
)
ORDER BY 1

-- EXISTS

SELECT e.nom_empregado 
FROM empregado AS e
WHERE EXISTS 
( 
	SELECT 1
	FROM alocacao AS a
	WHERE a.num_matricula = e.num_matricula
)
ORDER BY 1

/*
2. Listar o nome dos departamentos que controlam projetos 
(OBS: apresentar 3 soluções: uma com IN/NOT IN, EXISTS/NOT EXISTS e JOIN/LEFT/RIGHT)
*/

-- JOIN

SELECT DISTINCT d.nom_depto
FROM departamento AS d
INNER JOIN projeto AS p
	ON d.cod_depto = p.cod_depto

-- IN

SELECT nom_depto
FROM departamento 
WHERE cod_depto IN 
(
	SELECT cod_depto 
	FROM projeto
)

-- EXISTS

SELECT d.nom_depto
FROM departamento AS d
WHERE EXISTS
(
	SELECT 1
	FROM projeto AS p
	WHERE p.cod_depto = d.cod_depto
)

/*
3. Listar o nome dos supervisores (OBS: apresentar 3 soluções: 
uma com IN/NOT IN, EXISTS/NOT EXISTS e JOIN/LEFT/RIGHT)
*/

-- JOIN

SELECT DISTINCT sup.nom_empregado
FROM empregado AS e
INNER JOIN empregado AS sup
	ON sup.num_matricula = e.num_matricula_supervisor

-- IN

SELECT sup.nom_empregado
FROM empregado AS sup
WHERE sup.num_matricula IN
(
	SELECT e.num_matricula_supervisor
	FROM empregado AS e
)

-- EXISTS

SELECT sup.nom_empregado
FROM empregado AS sup
WHERE EXISTS
(
	SELECT 1
	FROM empregado AS e
	WHERE e.num_matricula_supervisor = sup.num_matricula
)

/*
4. Listar o nome dos dependentes dos empregados que são gerentes (OBS: 
apresentar 3 soluções: uma com IN/NOT IN, EXISTS/NOT EXISTS e JOIN/LEFT/RIGHT)
*/

-- JOIN
/*
SELECT nom_dependente
FROM dependente AS depe
INNER JOIN departamento AS d
	ON d.num_matricula_gerente = depe.num_matricula
*/

SELECT depe.nom_dependente
FROM dependente AS depe
INNER JOIN empregado AS e
	ON depe.num_matricula = e.num_matricula
INNER JOIN departamento AS d
	ON e.num_matricula = d.num_matricula_gerente

-- IN

/*
SELECT depe.nom_dependente
FROM dependente AS depe
INNER JOIN empregado AS e
	ON	 depe.num_matricula = e.num_matricula
WHERE e.num_matricula IN
(
	SELECT num_matricula_gerente
	FROM departamento
)
*/

SELECT nom_dependente
FROM dependente
WHERE num_matricula IN 
(
	SELECT num_matricula
	FROM empregado
	WHERE num_matricula IN
	(
		SELECT num_matricula_gerente
		FROM departamento
	)
)

-- EXISTS
/*
SELECT depe.nom_dependente
FROM dependente AS depe
INNER JOIN empregado AS e
	ON depe.num_matricula = e.num_matricula
WHERE EXISTS 
(
	SELECT 1
	FROM departamento AS d
	WHERE e.num_matricula = d.num_matricula_gerente
)
*/

SELECT depe.nom_dependente
FROM dependente AS depe
WHERE EXISTS
(
	SELECT 1
	FROM empregado AS e
	WHERE e.num_matricula = depe.num_matricula 
	AND EXISTS
	(
		SELECT 1
		FROM departamento AS d
		WHERE d.num_matricula_gerente = e.num_matricula
	)
)

/*
5. Listar todos os departamentos que não têm local cadastrado (OBS: 
apresentar 3 soluções: uma com IN/NOT IN, EXISTS/NOT EXISTS e JOIN/LEFT/RIGHT)
*/

-- JOIN 

SELECT d.nom_depto 
FROM departamento AS d
LEFT JOIN departamento_local AS l
	ON l.cod_depto = d.cod_depto
WHERE l.nom_local IS NULL

-- IN

SELECT nom_depto
FROM departamento
WHERE cod_depto NOT IN
(
	SELECT cod_depto
	FROM departamento_local
)

-- EXISTS

SELECT d.nom_depto
FROM departamento AS d
WHERE NOT EXISTS 
(
	SELECT 1
	FROM departamento_local AS l
	WHERE l.cod_depto = d.cod_depto
)

/*
6. Listar o nome do empregado e o nome do respectivo departamento 
para todos os empregados que não estão alocados em projetos.
*/

-- JOIN 

SELECT e.nom_empregado, d.nom_depto
FROM departamento AS d
INNER JOIN empregado AS e
	ON d.cod_depto = e.cod_depto
LEFT JOIN alocacao AS a
	ON e.num_matricula = a.num_matricula
WHERE a.num_matricula IS NULL

/*
7. Listar os projetos nos quais cada alocação de funcionário em 
projeto é maior do que 5 horas
*/

SELECT DISTINCT p.nom_projeto 
FROM projeto AS p
INNER JOIN alocacao AS a
	ON p.cod_projeto = a.cod_projeto
WHERE EXISTS
(
	SELECT 1
	WHERE a.num_horas > 5
)

/*
8. Listar o nome e a matrícula dos empregados que não têm 
dependentes e que são supervisores
*/

SELECT e.num_matricula, e.nom_empregado
FROM empregado AS e
WHERE e.num_matricula NOT IN
(
	SELECT num_matricula
	FROM dependente
)
AND EXISTS
(
	SELECT num_matricula_supervisor
	FROM empregado
	WHERE e.num_matricula = num_matricula_supervisor
)

/*
9. Listar o nome dos departamentos que tem empregados
e que controlam projetos
*/

SELECT d.nom_depto
FROM departamento AS d
WHERE d.cod_depto IN 
(
	SELECT cod_depto
	FROM empregado
) 
AND d.cod_depto IN
(
	SELECT cod_depto
	FROM projeto
)

/*
10. Listar o nome, o salário e a UF dos empregados que possuem o salário 
maior ou igual do que todos os empregados cuja UF é 'MG'
*/

SELECT e.nom_empregado, e.val_salario, e.sig_uf
FROM empregado AS e
WHERE e.val_salario >= ALL
(
	SELECT val_salario
	FROM empregado
	WHERE sig_uf = 'MG'
)

/*
11. Listar o nome, o salário e a UF dos empregados que não são de 'MG' e que 
possuem o salário maior ou igual do que todos os empregados cuja UF é 'MG'
*/

SELECT e.nom_empregado, e.val_salario, e.sig_uf
FROM empregado AS e
WHERE e.sig_uf != 'MG' 
AND e.val_salario >= ALL
(
	SELECT val_salario
	FROM empregado
	WHERE sig_uf = 'MG'
)

/*
12. Listar o nome do empregado, o nome do projeto e o número de horas alocadas, cujas
horas de um empregado alocado em um projeto seja maior do que todas as horas alocadas
de empregados no projeto 2
*/

SELECT e.nom_empregado, p.nom_projeto, a.num_horas 'Horas alocadas'
FROM empregado AS e
INNER JOIN alocacao AS a
	ON a.num_matricula = e.num_matricula
INNER JOIN projeto AS p
	ON p.cod_projeto = a.cod_projeto
WHERE a.num_horas > ALL
(
	SELECT num_horas
	FROM alocacao
	WHERE cod_projeto = 2
)
ORDER BY nom_empregado

/*
13. Listar o nome, o salário e a UF dos empregados do sexo masculino que possuem o 
salário maior do que todos os empregados do sexo feminino
*/

SELECT e.nom_empregado, e.val_salario, e.sig_uf
FROM empregado AS e
WHERE e.sex_empregado = 'M'
AND e.val_salario > ALL
(
	SELECT val_salario
	FROM empregado
	WHERE sex_empregado = 'F'
)

-- 14. Listar os empregados que são supervisores ou que possuem dependentes (utilizar UNION)

-- Primeira opção

SELECT DISTINCT e.nom_empregado--, 'SUPERVISOR'
FROM empregado AS e
INNER JOIN empregado AS sup
	ON  e.num_matricula = sup.num_matricula_supervisor

UNION

SELECT DISTINCT e.nom_empregado--, 'DEPENDENTE'
FROM empregado AS e
INNER JOIN dependente AS d
	ON d.num_matricula = e.num_matricula

-- Segunda opção

SELECT DISTINCT e.nom_empregado
FROM empregado AS e 
INNER JOIN empregado AS sup
	ON e.num_matricula = sup.num_matricula_supervisor

UNION

SELECT DISTINCT e.nom_empregado
FROM empregado AS e
WHERE EXISTS 
(
	SELECT num_matricula 
	FROM dependente AS d 
	WHERE e.num_matricula = d.num_matricula
)