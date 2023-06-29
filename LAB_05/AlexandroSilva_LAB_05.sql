
-- 1. Listar o n�mero de funcion�rios do departamento �vendas�.

SELECT COUNT(*) 'Total'
FROM empregado AS e
INNER JOIN departamento AS d
	ON d.cod_depto = e.cod_depto
	WHERE d.nom_depto = 'vendas'

-- 2. Listar o maior, o menor, a m�dia e a soma dos sal�rios do departamento �inform�tica�.

SELECT	MAX(e.val_salario) 'MAIOR',
		MIN(e.val_salario) 'MENOR',
		AVG(e.val_salario) 'MEDIA',
		SUM(e.val_salario) 'SOMA'
FROM empregado AS e
INNER JOIN departamento AS d
	ON d.cod_depto = e.cod_depto
WHERE d.nom_depto = 'inform�tica'

-- 3. Listar a m�dia de sal�rios por departamento.

SELECT d.nom_depto, AVG(e.val_salario) 'MEDIA'
FROM empregado AS e
INNER JOIN departamento AS d
	ON d.cod_depto = e.cod_depto
GROUP BY d.nom_depto

-- 4. Listar o total (soma) e a m�dia de horas alocadas por projeto.

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

-- 6. Listar a m�dia de sal�rios por departamento e o nome do gerente do departamento.

SELECT ger.nom_empregado 'GERENTE', d.nom_depto 'DEPARTAMENTO',  
AVG(e.val_salario) 'MEDIA'
FROM empregado AS e
INNER JOIN departamento AS d
	ON d.cod_depto = e.cod_depto
INNER JOIN empregado AS ger
	ON ger.num_matricula = d.num_matricula_gerente
GROUP BY ger.nom_empregado, d.nom_depto

-- 7. Listar os 2 departamentos com as maiores m�dias salariais da empresa.

SELECT TOP 2 d.nom_depto, AVG(e.val_salario) 'MEDIA'
FROM empregado AS e
INNER JOIN departamento AS d
	ON d.cod_depto = e.cod_depto
GROUP BY d.nom_depto
ORDER BY MEDIA DESC

-- 8. Listar o nome dos departamentos que possuem mais do que um funcion�rio.

SELECT d.nom_depto
FROM departamento AS d
INNER JOIN empregado AS e
	ON e.cod_depto = d.cod_depto
GROUP BY d.nom_depto
HAVING COUNT (*) > 1

-- 9. Listar a m�dia de sal�rios por departamento quando a media for maior do que 2000.

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

-- 11. Listar o nome do projeto cuja m�dia de horas alocadas � maior do que 8.

SELECT p.nom_projeto
FROM projeto AS p
INNER JOIN alocacao AS a
	ON a.cod_projeto = p.cod_projeto
GROUP BY p.nom_projeto
HAVING AVG(a.num_horas) > 8

-- 12. Listar os empregados, cujo sal�rio � maior do que o maior sal�rio do departamento de c�digo 2.

-- 1� resolu��o

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

-- 2� resolu��o

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

-- 13. Listar o nome e o sal�rio dos empregados que recebem abaixo da m�dia do seu departamento.

-- 1� resolu��o

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

-- 2� resolu��o

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
14. Listar o empregado, o nome do projeto e o n�mero de horas alocadas no projeto, quando
o n�mero de horas for maior do que a m�dia de aloca��o do referido projeto.
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