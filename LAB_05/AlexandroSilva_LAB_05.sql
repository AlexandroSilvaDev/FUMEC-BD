
-- 1. Listar o número de funcionários do departamento ‘vendas’.

SELECT COUNT(*) 'Total'
FROM empregado AS e
INNER JOIN departamento AS d
	ON d.cod_depto = e.cod_depto
	WHERE d.nom_depto = 'vendas'

-- 2. Listar o maior, o menor, a média e a soma dos salários do departamento ‘informática’.

SELECT	MAX(e.val_salario) 'MAIOR',
		MIN(e.val_salario) 'MENOR',
		AVG(e.val_salario) 'MEDIA',
		SUM(e.val_salario) 'SOMA'
FROM empregado AS e
INNER JOIN departamento AS d
	ON d.cod_depto = e.cod_depto
WHERE d.nom_depto = 'informática'

-- 3. Listar a média de salários por departamento.

SELECT d.nom_depto, AVG(e.val_salario) 'MEDIA'
FROM empregado AS e
INNER JOIN departamento AS d
	ON d.cod_depto = e.cod_depto
GROUP BY d.nom_depto

-- 4. Listar o total (soma) e a média de horas alocadas por projeto.

SELECT p.nom_projeto,
	   SUM(a.num_horas) 'TOTAL',
	   AVG(a.num_horas) 'MEDIA'
FROM alocacao AS a
INNER JOIN projeto AS p
	ON p.cod_projeto = a.cod_projeto
GROUP BY p.nom_projeto

-- 5. Listar o total de empregados por UF e sexo.

SELECT e.sig_uf, e.sex_empregado, COUNT(e.num_matricula) 'TOTAL'
FROM empregado AS e
GROUP BY e.sig_uf, e.sex_empregado
ORDER BY 1, 2 DESC

-- 6. Listar a média de salários por departamento e o nome do gerente do departamento.

SELECT ger.nom_empregado 'GERENTE', d.nom_depto 'DEPARTAMENTO',  
AVG(e.val_salario) 'MEDIA'
FROM empregado AS e
INNER JOIN departamento AS d
	ON d.cod_depto = e.cod_depto
INNER JOIN empregado AS ger
	ON ger.num_matricula = d.num_matricula_gerente
GROUP BY ger.nom_empregado, d.nom_depto

-- 7. Listar os 2 departamentos com as maiores médias salariais da empresa.

SELECT TOP 2 d.nom_depto, AVG(e.val_salario) 'MEDIA'
FROM empregado AS e
INNER JOIN departamento AS d
	ON d.cod_depto = e.cod_depto
GROUP BY d.nom_depto
ORDER BY MEDIA DESC

-- 8. Listar o nome dos departamentos que possuem mais do que um funcionário.

SELECT d.nom_depto
FROM departamento AS d
INNER JOIN empregado AS e
	ON e.cod_depto = d.cod_depto
GROUP BY d.nom_depto
HAVING COUNT (*) > 1

-- 9. Listar a média de salários por departamento quando a media for maior do que 2000.

SELECT d.nom_depto, AVG(e.val_salario) 'MEDIA'
FROM empregado AS e
INNER JOIN departamento AS d
	ON d.cod_depto = e.cod_depto
GROUP BY d.nom_depto
HAVING AVG(e.val_salario) > 2000
ORDER BY MEDIA DESC

-- 10. Listar o nome dos departamentos que possuem media salarial acima de R$ 2.200,00.

SELECT d.nom_depto
FROM empregado AS e
INNER JOIN departamento AS d
	ON d.cod_depto = e.cod_depto
GROUP BY d.nom_depto
HAVING AVG(e.val_salario) > 2200

-- 11. Listar o nome do projeto cuja média de horas alocadas é maior do que 8.

SELECT p.nom_projeto
FROM projeto AS p
INNER JOIN alocacao AS a
	ON a.cod_projeto = p.cod_projeto
GROUP BY p.nom_projeto
HAVING AVG(a.num_horas) > 8

-- 12. Listar os empregados, cujo salário é maior do que o maior salário do departamento de código 2.

-- 1º resolução

SELECT e.nom_empregado, e.val_salario
FROM empregado AS e
INNER JOIN departamento AS d
	ON d.cod_depto = e.cod_depto
GROUP BY e.nom_empregado, e.val_salario
HAVING e.val_salario > 
( 
	SELECT MAX(val_salario)
	FROM empregado
	WHERE cod_depto = 2 
)

-- 2º resolução

SELECT e.nom_empregado, e.val_salario
FROM empregado AS e
INNER JOIN departamento AS d
	ON d.cod_depto = e.cod_depto
WHERE e.val_salario >
(
	SELECT MAX(val_salario)
	FROM empregado
	WHERE cod_depto = 2 
)

-- 13. Listar o nome e o salário dos empregados que recebem abaixo da média do seu departamento.

-- 1º resolução

SELECT e.nom_empregado, e.val_salario
FROM empregado AS e
INNER JOIN departamento AS d
	ON d.cod_depto = e.cod_depto
GROUP BY e.nom_empregado, e.val_salario, d.cod_depto
HAVING e.val_salario <
(
	SELECT AVG(val_salario)
	FROM empregado
	WHERE cod_depto = d.cod_depto
)

-- 2º resolução

SELECT e.nom_empregado, e.val_salario
FROM empregado AS e
INNER JOIN departamento AS d
	ON d.cod_depto = e.cod_depto
WHERE e.val_salario <
(
	SELECT AVG(val_salario)
	FROM empregado
	WHERE cod_depto = d.cod_depto
)

/*
14. Listar o empregado, o nome do projeto e o número de horas alocadas no projeto, quando
o número de horas for maior do que a média de alocação do referido projeto.
*/

/*
SELECT e.nom_empregado 'NOME EMPREGADO', p.nom_projeto 'NOME PROJETO', a.num_horas 'HORAS ALOCADAS'
FROM empregado AS e
INNER JOIN alocacao AS a
	ON a.num_matricula = e.num_matricula
INNER JOIN projeto AS p
	ON p.cod_projeto = a.cod_projeto
GROUP BY p.cod_projeto, a.num_horas
HAVING a.num_horas >
(
	SELECT AVG(num_horas)
	FROM alocacao
	WHERE cod_projeto = p.cod_projeto
)
*/

SELECT e.nom_empregado 'NOME EMPREGADO', p.nom_projeto 'NOME PROJETO', a.num_horas 'HORAS ALOCADAS'
FROM empregado AS e
INNER JOIN alocacao AS a
	ON a.num_matricula = e.num_matricula
INNER JOIN projeto AS p
	ON p.cod_projeto = a.cod_projeto
WHERE a.num_horas > 
(
	SELECT AVG(num_horas)
	FROM alocacao
	WHERE cod_projeto = p.cod_projeto
)