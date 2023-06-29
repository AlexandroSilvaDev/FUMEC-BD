-- USE bd_empresa

SELECT * FROM empregado

-- 1. Listar o nome do projeto e o nome do departamento que o controla.

SELECT p.nom_projeto, d.nom_depto 
FROM projeto AS p INNER JOIN departamento AS d 
ON p.cod_depto = d.cod_depto

-- 2. Listar a matrícula, o nome dos empregados e o nome do departamento de cada um.

SELECT e.num_matricula, e.nom_empregado, d.nom_depto
FROM empregado AS e INNER JOIN departamento AS d
ON e.cod_depto = d.cod_depto

-- 3. Listar os gerentes e o departamento que eles gerenciam.

SELECT e.nom_empregado, d.nom_depto
FROM departamento AS d INNER JOIN empregado AS e
ON d.num_matricula_gerente = e.num_matricula

-- 4. Listar os empregados e os respectivos dependentes.

SELECT e.nom_empregado, d.nom_dependente
FROM dependente AS d INNER JOIN empregado AS e
ON d.num_matricula = e.num_matricula

-- 5. Listar o nome do empregado e o respectivo supervisor.

SELECT e.nom_empregado, sup.nom_empregado 'supervisor'
FROM empregado AS e INNER JOIN empregado AS sup
ON e.num_matricula_supervisor = sup.num_matricula

/*
6. Listar a matrícula, o nome dos empregados, o nome do departamento
de cada um e a matrícula do gerente do departamento.
*/

SELECT e.num_matricula, e.nom_empregado, d.nom_depto, d.num_matricula_gerente
FROM departamento AS d INNER JOIN empregado AS e
ON d.cod_depto = e.cod_depto

-- 7. Listar a matricula e o nome de todos os supervisores.

SELECT DISTINCT sup.num_matricula_supervisor, e.nom_empregado
FROM empregado AS e INNER JOIN empregado AS sup
ON sup.num_matricula_supervisor = e.num_matricula

/*
8. Listar todos os empregados e o nome do respectivo supervisor 
(para quem tiver supervisor, caso contrário, será listado NULL!).
*/

SELECT e.nom_empregado, sup.nom_empregado 'supervisor'
FROM empregado AS e LEFT JOIN empregado AS sup
ON e.num_matricula_supervisor = sup.num_matricula

/*
9. Listar todos os empregados e o departamento que ele gerencia se o empregado 
for gerente (usar função COALESCE para substituir NULL por “não encontrado”).
*/

SELECT * FROM empregado
SELECT * FROM departamento

SELECT e.nom_empregado, COALESCE( CONVERT( VARCHAR, d.nom_depto ), '(Não encontrado)' )
FROM departamento AS d RIGHT JOIN empregado AS e
ON d.num_matricula_gerente = e.num_matricula

/*
10. Listar todos os empregados e os dependentes se o empregado tiver dependente.
*/

SELECT e.nom_empregado, d.nom_dependente
FROM empregado AS e LEFT JOIN dependente AS d
ON e.num_matricula = d.num_matricula
ORDER BY e.nom_empregado

/*
11. Listar o nome de todos os departamentos. Para os departamentos 
que tiverem empregado, exibir também o nome dos empregados.
*/

SELECT d.nom_depto, e.nom_empregado
FROM departamento AS d LEFT JOIN empregado AS e
ON d.cod_depto = e.cod_depto

/*
12. Listar os projetos sem alocação (usar algum OUTER join – LEFT, RIGHT ou FULL).
*/

SELECT p.nom_projeto
FROM projeto AS p LEFT JOIN alocacao AS a
ON p.cod_projeto = a.cod_projeto
WHERE a.num_horas is NULL

/*
13. Listar os empregados que não são gerente (usar algum OUTER join).
*/

SELECT e.nom_empregado, e.num_matricula
FROM empregado AS e LEFT JOIN departamento AS d
ON e.num_matricula = d.num_matricula_gerente
WHERE d.num_matricula_gerente is NULL

/*
14. Listar a matrícula, o nome dos empregados, o nome do departamento 
de cada um, a matrícula e o nome do gerente do departamento.
*/

SELECT e.num_matricula, e.nom_empregado, d.nom_depto, 
d.num_matricula_gerente, ger.nom_empregado 'gerente'
FROM empregado AS e 
LEFT JOIN departamento AS d
	ON e.cod_depto = d.cod_depto
LEFT JOIN empregado AS ger
	ON ger.num_matricula = d.num_matricula_gerente

/*
15. Listar os departamentos, o gerente do departamento e os locais do departamento.
*/

SELECT d.nom_depto, ger.nom_empregado 'gerente', l.nom_local
FROM departamento AS d
INNER JOIN empregado AS ger
	ON d.num_matricula_gerente = ger.num_matricula
INNER JOIN departamento_local AS l
	ON l.cod_depto = d.cod_depto

/*
16. Listar os projetos, o nome do departamento que controla o projeto, 
os funcionários alocados no projeto e o número de horas de cada um deles.
*/

SELECT p.nom_projeto 'Nome do projeto', d.nom_depto 'Departamento que controla o projeto',
e.nom_empregado 'Nome do empregado', a.num_horas 'Horas alocadas'
FROM projeto AS p
LEFT JOIN departamento AS d
	ON d.cod_depto = p.cod_depto
RIGHT JOIN alocacao AS a
	ON a.cod_projeto = p.cod_projeto
LEFT JOIN empregado AS e
	ON e.num_matricula = a.num_matricula

/*
17. Listar o empregado, o respectivo departamento, o gerente do departamento, 
as horas alocadas em projetos (do empregado), o nome do projeto e o respectivo 
departamento do projeto.
*/


SELECT e.nom_empregado 'Nome do empregado', d.nom_depto 'Nome do departamento do empregado',
ger.nom_empregado 'Nome do gerente do departamento', a.num_horas 'Horas alocadas',
p.nom_projeto 'Nome do projeto', dep.nom_depto 'Nome do departamento do projeto'
FROM departamento AS d
INNER JOIN empregado AS e
	ON d.cod_depto = e.cod_depto 
INNER JOIN empregado AS ger
	ON ger.num_matricula = d.num_matricula_gerente
INNER JOIN alocacao AS a
	ON a.num_matricula = e.num_matricula
INNER JOIN projeto AS p 
	ON a.cod_projeto = p.cod_projeto
INNER JOIN departamento AS dep
	ON dep.cod_depto = p.cod_depto

/*
18. Listar o empregado, o respectivo departamento, o gerente do departamento, 
as horas alocadas em projetos (do empregado), o nome do projeto e o respectivo 
departamento do projeto para os empregados que estão alocados em projetos 
controlados por outros departamentos.
*/

SELECT e.nom_empregado 'Nome empregado', d.nom_depto 'Departamento',
ger.nom_empregado 'Gerente', a.num_horas 'Horas alocadas', 
p.nom_projeto 'Projeto', dep.nom_depto 'Departamento do Projeto'
FROM departamento AS d
INNER JOIN empregado AS e
	ON e.cod_depto = d.cod_depto
INNER JOIN empregado AS ger
	ON ger.num_matricula = d.num_matricula_gerente
INNER JOIN alocacao AS a
	ON a.num_matricula = e.num_matricula
INNER JOIN projeto AS p
	ON a.cod_projeto = p.cod_projeto
INNER JOIN departamento AS dep
	ON dep.cod_depto = p.cod_depto
WHERE d.cod_depto != dep.cod_depto

/*
19. DESAFIO EXTRA: Listar o nome de todos os empregados e o respectivo supervisor 
(se o nome do supervisor NÃO começar com 'José%').
*/

SELECT e.nom_empregado 'Nome empregado', sup.nom_empregado 'Supervisor'
FROM empregado AS sup
RIGHT JOIN empregado AS e
	ON sup.num_matricula = e.num_matricula_supervisor
	AND sup.nom_empregado NOT LIKE 'José%'
