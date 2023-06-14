>Esquemas do BD Empresa

- **Empregado**(*matricula*, nome, sexo, endereco, salario, supervisor, depto)
- **Dependente**(*matricula*, nome, sexo)
- **Departamento**(*coddep*, nome, gerente, dataini)
- **Projeto**(*codproj*, nome, local, depart)
- **Alocacao**(*matric,codproj*, horas)

- Operações de manipulação sem cursor:
	- SELECT
	- INSERT
	- UPDATE
	- DELETE

## SELECT

>Sintaxe

```
SELECT lista-atributos
FROM lista-tabelas
WHERE condicao
```

#Ex1:

- Obtenha o salário de José

```
SELECT salario
FROM Empregado
WHERE nome = 'José'
```

- Podemos renomear o nome da coluna no resultado

```
SELECT salario as SalarioJose
FROM Empregado
WHERE nome='José'
```

- Podemos usar colunas como expressões:

```
SELECT matricula,salario, 0.15*salario as IR
FROM Empregado
```

==Estamos pegando uma coluna matricula de Empregado, uma coluna salario normal e uma coluna salario com uma operação aplicada em cima dela e atribuindo o nome dessa coluna como IR.==

- Podemos inserir constantes na cláusula select se necessário 

```
SELECT nome, 'marajá' as Marajá
FROM Empregado
WHERE salario > 10.000
```

#Ex2:

- Selecione o nome e o endereço de todos os empregados que trabalham no departamento de produção

```
SELECT e.nome, e.endereco
FROM Empregado e, Departamento d
WHERE d.nome = 'produção' and d.coddep = e.depto
```

==Preste atenção que 'e' e 'd' são aliases (variáveis de dupla), elas vão lhe auxiliar na hora de mostrar qual atributo você quer usar de quem, se deixasse apenas select nome e endereço, não saberia se seria de Empregado ou Departamento, pois ambos possuem o atributo 'nome'.==

#Ex3:

- Para cada projeto em 'Fortaleza', liste o código do projeto, o Departamento que controla o projeto e o nome do gerente com endereço e salário

```
SELECT p.codproj, d.nome, e.nome, e.endereco, e.salario
FROM Empregado e, Departamento d, Projeto p
WHERE p.local = 'Fortaleza' and p.depart = d.coddep and d.gerente = e.matricula
```

#Ex4:

- Para cada empregado, recupere seu nome e o nome do seu supervisor

```
SELECT e.nome, s.nome
FROM Empregado e, Empregado s
WHERE e.matricula = s.supervisor
```

#Ex5:

- Selecione a matrícula de todos os empregados

```
SELECT matricula
FROM Empregado
```

#Ex6:

- Faça o produto cartesiano, seguido de projeção de Empregados X Departamento retornando a matrícula do empregado e o nome do departamento

```
SELECT matricula, d.nome
FROM Empregado, Departamento d
```

#Ex7:

- Selecione todos os atributos de todos os empregados do departamento d5

```
SELECT *
FROM Empregado
WHERE depto = 'd5'
```

#Ex8:

- Selecione todos os atributos de todos os empregados do departamento Pessoal

```
SELECT e.*
FROM Empregado e, departamento d
WHERE d.nome = 'Pessoal' and d.coddep = e.depto
```

#Ex9:

- Recupere os salários de cada empregado

```
SELECT salario
FROM empregado
```


==Algumas vezes surgem duplicatas como resposta a uma query. Podemos eliminá-las usando o comando DISTINCT na cláusula SELECT=

#Ex10:

- Selecione os diferentes salários pagos pela empresa aos empregados

```
SELECT DISTINCT salario
FROM Empregado
```


## OPERAÇÕES DE CONJUNTOS

- union : ∪
- intersect : ∩
- except : −

==Essas Operações eliminam automaticamente duplicatas==

==Para reter todas as duplicatas use ALL==

- union all
- intersect all
- except all

- Suponha que uma tupla ocorre m vezes em r e n vezes em s, entao ela ocorre:
	- m + n vezes em r union all s
	- min(m, n) vezes em r instersect all s
	- max(0, m - n) vezes em r except all s

>No Oracle no lugar de usar EXCEPT se usa MINUS


#Ex11:

- Liste todos os nomes de projetos que envolvem o empregado 'Silva' como trabalhador ou como gerente do departamento que controla o projeto

```
(SELECT p.nome
FROM Empregado e, Alocacao a, Projeto p
WHERE a.codproj = p.codproj and e.matricula = a.matric and e.nome = 'Silva')
UNION
(SELECT p.nome
FROM Empregado e, Departamento d, Projeto p
WHERE p.depart = d.coddep and d.gerente = e.matricula and e.nome = 'Silva')
```


>Consultas aninhadas

- Consultas que possuem consultas completas dentro de sua cláusula WHERE

#Ex12:

- A consulta ==11== poderia ser reescrita da seguinte forma:

```
SELECT DISTINCT nome
FROM Projeto
WHERE codproj IN (SELECT codproj
FROM Empregado e, Alocacao a, Projeto p
WHERE a.codproj = p.codproj and e.matricula = a.matric and e.nome = 'Silva')
OR
codproj IN (SELECT codproj
FROM Empregado e, Departamentod, Projeto p
WHERE p.depart = d.coddep and d.gerente = e.matricula and e.nome = 'Silva')
```

#Ex13:

- Recupere o nome de cada empregado que tem um dependente com o mesmo nome e mesmo sexo

```
SELECT e.nome
FROM Empregado e
WHERE e.matricula IN (SELECT matricula
FROM Dependente d
WHERE d.matricula = e.matricula and d.nome = e.nome and d.sexo = e.sexo)
```

==Perceba que e.nome, e.sexo e e.matricula são atributos de Empregado da consulta EXTERNA==

#Ex14:

- Reescrevendo a consulta acima sem usar aninhamento

>Fica mais simples de entender :)

```
SELECT e.nome
FROM Empregado e, Dependente d
WHERE d.matricula = e.matricula and d.nome = e.nome and d.sexo = e.sexo
```

## A CONSTRUÇÃO EXISTS

>Exists Retorna o valor true se o argumento da subquery é não vazio

- Seja R uma relação qualquer
	- exists R <-> R != Ø
	- not exists R <-> R = Ø

- A consulta ==13== poderia ser

```
SELECT e.nome
FROM Empregado e
WHERE EXISTS (SELECT *
FROM Dependente d
WHERE d.matricula = e.matricula and d.nome = e.nome and d.sexo = e.sexo)
```

==Podemos usar o not exists==


#Ex15:

- Recupere os nomes dos empregados que não têm dependentes

```
SELECT e.nome
FROM Empregado e
WHERE NOT EXISTS(SELECT *
FROM Dependentes d
WHERE e.matricula = d.matricula)
```

==Podemos usar um conjunto de valores explícitos==


#Ex16:

- Selecione a matrícula de todos os empregados que trabalham nos projetos 10, 20 ou 30

```
SELECT DISTINCT matric
FROM Alocacao
WHERE codproj IN (10, 20, 30)
```


#Ex17:

- Mostre os empregados que trabalham em todos os projetos do empregado com mat = 800

```
SELECT mat
FROM Empregado e
WHERE NOT EXISTS(
(SELECT codproj FROM Alocacao WHERE matric = 800)
EXCEPT
(SELECT codproj FROM alocacao a WHERE a.matric = e.matricula))
```

- X - Y = Vazio

>No Oracle o operador diferença é minus

- Essa consulta ta um pouco bugada // nao tenho certeza se é assim mesmo ou se tem algum erro


> Podemos verificar valores nulos através de IS NULL e IS NOT NULL


#Ex18:

- Selecione os nomes de todos os empregados que não têm supervisores

```
SELECT nome
FROM Empregado
WHERE supervisor IS NULL
```

## Funções

>SQL fornece 5 funções embutidas

- COUNT : Retorna o número de tuplas ou valores especificados numa query
- SUM : Retorna a soma dos valores de uma coluna
- AVG : Retorna a média dos valores de uma coluna
- MAX : Retorna o maior valor de uma coluna
- MIN : Identifica o menor valor de uma coluna

>Essas funções só podem ser usadas numa cláusula SELECT ou numa cláusula HAVING (a ser vista depois)

#Ex19:

- Encontre a soma total de salários, o maior salário, o menor salário e a média salarial da relação empregados

```
SELECT SUM(salario), MAX(salario), MIN(salario), AVG(salario)
FROM Empregado
```


#Ex20:

- Encontre o maior e menor salário do departamento de produção

```
SELECT MAX(e.salario), MIN(e.salario)
FROM Empregado e, Departamento d
WHERE d.nome = 'Produção' and d.coddep = e.depto
```

#Ex21:

- Obtenha o número de empregados da empresa

```
SELECT COUNT(*)
FROM Empregado
```

#Ex22:

- Obter o número de salários distintos do departamento de Contabilidade

```
SELECT COUNT(DISTINCT e.salario)
FROM Empregado e, Departamento d
WHERE d.nome = 'Contabilidade' and d.coddep = e.depto
```

==O que aconteceria se escrevêssemos COUNT(salario) ao invés de COUNT(DISTINCT salario) ?==

#Ex23:

- Obter o nome dos empregados que tenham 2 ou mais dependentes

```
SELECT e.nome
FROM Empregado e
WHERE (SELECT COUNT(*)
FROM Dependente d
WHERE d.matricula = e.matricula) >= 2
```

>Uso da função max numa query dentro de um SELECT de outra query

```
SELECT matricula, salario, (SELECT MAX(salario) FROM Empregado)
FROM Empregado
```


## CLÁUSULA GROUP BY, HAVING

>Usadas para lidar com grupos

#Ex24:

- Para cada departamento, obter o código do departamento, o número de empregados e a média salarial

```
SELECT depto, COUNT(*), AVG(salario)
FROM Empregado
GROUP BY depto
```

>As tuplas de empregados são separadas em grupos (departamento) e as funções COUNT e AVG são aplicadas a cada grupo separadamente.

#Ex25:

- Para cada projeto, obter o código do projeto, seu nome e o número de empregados que trabalham naquele projeto

```
SELECT p.codproj, p.nome, COUNT(*)
FROM Projeto p, Alocacao a
WHERE p.codproj = a.codproj
GROUP BY p.codproj, p.nome
```

==O agrupamento e as funções são aplicadas após a junção==

>Exemplo Group By

- Como saber quantas pessoas estão em cada curso?

==Vamos pensar na lógica==

1 - Temos de contar os alunos
2 - Temos de contar separado por curso

![[Pasted image 20230604202111.png]]

- O Resultado seria este

```
SELECT Cr as Curso, COUNT(*) as NumeroAlunos 
FROM ALUNOS
GROUP BY Curso
```

| Curso | NumeroAlunos |
|-------|--------------|
| CC | 3 |
| MC | 2 |
| SI | 4 |
| ECA | 1 |

- **ALUNOS**
![[Pasted image 20230604202543.png]]               ![[Pasted image 20230604202636.png]]

> Exemplo Group By

```
SELECT Cr, Sexo, COUNT(*) as NumeroAlunos
FROM ALUNOS
GROUP BY Cr, Sexo
```


![[Pasted image 20230604203102.png]]             ![[Pasted image 20230604203122.png]]

### HAVING

>Usada em conjunto com GROUP BY para permitir inclusão de condições nos grupos


#Ex26:

- Para cada projeto que possui mais de 2 empregados trabalhando, obter o código do projeto, nome do projeto e número de empregados que trabalha neste projeto

```
SELECT p.codproj, p.nome, COUNT(*)
FROM Projeto p, Alocacao a
WHERE p.codproj = a.codproj
GROUP BY p.codproj, p.nome
HAVING COUNT(*) > 2
```

==Uma query é avaliada primeiro aplicando a cláusula WHERE e depois GROUP BY HAVING==


>Exemplo Group By com Having

- Como saber quantas pessoas estão em cada curso, Apenas cursos com mais de 3 matrículas???

```
SELECT Cr, COUNT(*) as NumeroAlunos
FROM ALUNOS
GROUP BY Cr
HAVING NumeroAlunos > 3
```

- Having adiciona uma condição para o grupo entrar no resultado da consulta!
- Apenas grupos com having true entram no resultado

## OPERADORES DE COMPARAÇÃO E ARITMÉTICOS

>**BETWEEN**

```
expressão [NOT] BETWEEN expressão AND expressão
```

- Ex:

```
y BETWEEN x AND Z         // equivale a x <= y <= z
```

#Ex27:

- Selecione os nomes dos empregados que ganham mais de 1000 e menos de 2000 reais

```
SELECT nome
FROM Empregado
WHERE salario BETWEEN 1000 AND 2000
```

>**LIKE**

- Permite comparações de substrings. Usa dois caracteres reservados ``'%'`` (substitui um número arbitrário de caracteres) e `'_'` (substitui um único caracter).

#Ex28:

- Obter os nomes de empregados cujos endereços estão em Natal, RN

```
SELECT nome
FROM Empregado
WHERE endereco LIKE '%Natal, RN%'
```

- Existem várias outras funções para se trabalhar com Strings: SUBSTRING(), UPPER(), LOWER(),...


>**UPPER e LOWER**

- Os dados em SQL são Case sensitive
	- 'Zé' <> 'zé' <> 'ze' <> 'ZE'
- Colocam o string em maiúsculo e minúsculo

#Ex29:

- Obter os nomes de empregados cujos endereços estão em Natal, RN

```
SELECT nome
FROM Empregado
WHERE UPPER(endereco) LIKE '%NATAL, RN%'
```

```
SELECT nome
FROM Empregado
WHERE LOWER(endereco) LIKE '%natal, rn%'
```

>**REGEX**

- Implementam expressões regulares (busca por padrões em strings)
- Alguns SGBDS seguem o padrão POSIX de REGEX
- Podem usar
	- Metacaracteres (operadores que especificam o algoritmo de busca)
	- Literais (caracteres a serem buscados)
	- Ex: A expressão regular : ``(f|ht)tps?:`` casa com os strings: ``http:``, ``https:``, ``ftp:`` e ``ftps:``

> **REGEX NO ORACLE**

```
REGEXP_LIKE(condicao)
```

- Usado na cláusula WHERE (ou em um check), retorna as linhas que casam com a expressão regular passada na condição.

#Ex :

- Filtrar a coluna nome por 'Steven' ou 'Stephen'

```
SELECT ...
...
WHERE REGEXP_LIKE(nome, '^Ste[v|ph]en$')
```


```
REGEXP_REPLACE(funcao)
```

- Troca a ocorrência de um padrão em um string por um novo padrão passado como parâmetro
- pode ser usado num SELECT

#Ex:

- Colocar um espaço entra caada caracter da coluna nome_país

```
SELECT REGEXP_REPLACE(nome_pais, '(.)', '\1')
FROM Paises
```

==Veja que o '.' significa qualquer caracter==
==O '\1' substitui a primeira subexpressão (o primeiro grupo de parêntesis no padrão).==

#Ex:

- Forçando que os números de telefones tenham o formato (XXX) XXX-XXXX

```
CREATE TABLE Contatos(
nome VARCHAR(30),
telefone VARCHAR(30),
CONSTRAINT formato_fone CHECK (REGEXP_LIKE(telefone, '^\(\d{3}\)\d{3}-\d{4}$'))
)
```

#Ex30:

- Queremos ver o efeito de dar aos empregados que trabalham no projeto ProdutoX um aumento de 10%

```
SELECT e.nome, e.salario * 1.1
FROM Empregado e, Projeto p, Alocacao a
WHERE  p.codproj = a.codproj and p.nome = 'ProdutoX' and a.matric = e.matricula
```


>**ORDENAÇÃO**

- O operador ORDER BY permite ordenar o resultado de uma query por um ou mais atributos

#Ex31:

- Obter uma lista de empregados e seus respectivos departamentos e projetos, listando ordenado pelo nome do departamento

```
SELECT e.nome, d.nome, p.nome
FROM Empregado e, Departamento d, Projeto p, Alocacao a
WHERE p.codproj = a.codproj and d.coddep = e.depto and e.matricula = a.matric
ORDER BY d.nome, e.nome
```

==Pode tirar o e.nome do order by para satisfazer fielmente a consulta==

>A Ordem DEFAULT é ascendente (ASC) caso queiramos ordem decresente usamos DESC

#Ex:

```
ORDER BY d.nome DESC, e.nome ASC
```


## QUANTIFICADORES

>**ANY (OU SOME) E ALL (OU EVERY)**

- Comportam-se como quantificadores existencial ("ao menos um") e universal, respectivamente.

#Ex:

```
SELECT mat, salario
FROM Empregado
WHERE salario >= all (SELECT salario FROM empregado)
```

> **DEFINIÇÃO DE ALL**

```
f <comp> all R  // comp pode ser  <, <=. >, =, !=
```

5 < all ![[Pasted image 20230606125001.png]] = false



5 < all ![[Pasted image 20230606125104.png]] = true


5 = all ![[Pasted image 20230606125122.png]] = false


5 != all ![[Pasted image 20230606125153.png]] = true (5 != 4 and 5 != 6)


>**DEFINIÇÃO DE ANY (SOME)**

```
f <comp> ANY R // comp pode ser <, <=, >, =, !=
```

5 < any ![[Pasted image 20230606133421.png]] = true  (lê-se: 5 < alguma tupla na relação)

5 < any ![[Pasted image 20230606133535.png]] = false

5 = any ![[Pasted image 20230606133554.png]] = true


5 != any ![[Pasted image 20230606133625.png]] = true ( 0 != 5)

#Ex: com agrupamento 

- Quais departamentos têm mais empregados?

```
SELECT depto
FROM Empregado
GROUP BY depto
HAVING COUNT(*) >= ALL (SELECT COUNT(*)
FROM Empregado
GROUP BY depto)
```

- Quais Empregados não ganham o menor salário pago pela empresa?

```
SELECT mat
FROM Empregado
WHERE salario > ANY (SELECT salario FROM Empregado)
```

- Quais Empregados ganham o menor salário pago pela empresa?

```
SELECT mat
FROM Empregado
WHERE salario < ANY (SELECT salario FROM Empregado)
```


## JUNÇÃO

- Clássica (tabelas separadas por vírgulas como vimos)
- Cross joins
- Natural joins
- Conditions joins
- Column name join
- Outer joins (left, right, ou full)

>Natural join 

- Tabelas T1 e T2

- T1

| C1 | C2 |
|------|------|
| **10** | 15 |
| **20** |  25 |

- T2

| C1 | C4 |
|------|------|
| **10** | BB |
| **15** |  DD |

- Junção natural de T1 com T2

| C1 | C2 | C4 |
|------|------|------|
| **10** | 15 | BB |


```
SELECT *
FROM T1 NATURAL JOIN T2
```

#Obs: A junção será feita por colunas de mesmo nome

>Cross Join

- Implementa o produto cartesiano

```
SELECT *
FROM T1 CROSS JOIN T2
```

>Condition Join

- Usa a cláusula  ON para especificar a condição de junção

```
SELECT *
FROM T1 JOIN T2
ON T1.C1 = T2.C1
```

- É equivalente a

```
SELECT *
FROM T1,T2
WHERE T1.C1 = T2.C1
```

>Outer join

- Preserva no resultado valores que não casam na comparação da junção

==Motivação== : As vezes precisamos mostrar esses valores que não casam

#Ex:

- Tabelas Empregado e Departamento onde o código do departamento em empregado é chave estrangeira, portanto, pode haver valores nulos. Se quisermos uma lista de todos os empregados com os nomes dos respectivos departamentos, usando uma junção natural **eliminaria os empregados sem departamento (com valores null)**


>Left Outer Join

- **T1**

| C1 | C2 |
|------|------|
| **10** | 15 |
| **20** |  25 |

- **T2**

| C3 | C4 |
|------|------|
| **10** | BB |
| **15** |  DD |

- Junção left outer join de T1 com T2

| C1 | C2 | C3 | C4 |
|------|------|-------|-------|
| **10** | 15 | 10 | BB |
| **20** |  25 | Null | Null |

```
SELECT *
FROM T1 LEFT OUTER JOIN T2
ON T1.C1 = T2.C3
```

> Right Outer Join

- **T1**

| C1 | C2 |
|------|------|
| **10** | 15 |
| **20** |  25 |

- **T2**

| C3 | C4 |
|------|------|
| **10** | BB |
| **15** |  DD |

- Junção Right Outer Join de T1 com T2

| C1 | C2 | C3 | C4 |
|------|------|-------|-------|
| **10** | 15 | 10 | BB |
| **Null** |  Null | 15 | DD |

```
SELECT *
FROM T1 RIGHT OUTER JOIN T2
ON T1.C1 = T2.C3
```

>Full Outer Join

- **T1**

| C1 | C2 |
|------|------|
| **10** | 15 |
| **20** |  25 |

- **T2**

| C3 | C4 |
|------|------|
| **10** | BB |
| **15** |  DD |

- Full outer join de T1 com T2

| C1 | C2 | C3 | C4 |
|------|------|-------|-------|
| **10** | 15 | 10 | BB |
| **20** | 25 | Null | Null |
| Null | Null | 15 | DD |

```
SELECT *
FROM T1 FULL OUTER JOIN T2
ON T1.C1 = T2.C3
```


## A CLÁUSULA WITH

> Permite visões serem definidas localmente a uma query, ao invés de globalmente como veremos adiante

#Ex:

- Mostre os funcionários que ganham o maior salário

```
WITH max_sal_temp(sal) as SELECT MAX(salario) FROM Empregado
SELECT mat
FROM Empregado e, max_sal_temp m
WHERE e.salario = m.sal
```


## Relações Diversas

```
SELECT dep
FROM(SELECT depto as dep, AVG(salario) as media FROM Empregado GROUP BY depto) Resultado
WHERE Resultado.media > 100
```

> O Comando INSERT

- Usado para adicionar uma tupla a uma relação

```
INSERT INTO tabela [(lista colunas)] fonte
```

- fonte pode ser uma especificação de pesquisa *SELECT* ou uma cláusula *VALUES* da forma

```
VALUES(lista de valores atômicos)
```

#OBS: 

- Se o comando *INSERT* incluir a cláusula *VALUES* então uma única tupla é inserida na relação

#Ex:

- Para a table

```
CREATE TABLE Empregado (
mat int,
nome char(50),
end char(150),
salario number(9,2),
depto int
)
```

```
INSERT INTO Empregado(mat, nome) VALUES(9491, 'Ana');
INSERT INTO Empregado VALUES (1000, 'Ana Silva', null, 8740, null)
```

#OBS:

- A inserção será rejeitada se tentarmos omitir um atributo que não permite valores nulos (NOT NULL)

#Ex:

```
INSERT INTO Empregado (nome, salario) VALUES ('Flávia', 960);
```

- Podemos inserir várias tuplas numa relação através de uma query

```
CREATE TABLE DEPTO_INFO (
nome character(15),
numemp integer,
totsal real
);

INSERT INTO DEPTO_INFO(nome, numemp, totsal)
SELECT d.nome, COUNT(*), SUM(salario)
FROM Departamento d JOIN Empregado e
ON d.coddep = e.depto
GROUP BY d.nome
```

>O Comando DELETE

- Remove tuplas de uma relação

```
DELETE FROM nometabela [WHERE condicao]
```

```
DELETE FROM Estudante WHERE sexo = 'M'
```

- Se omitirmos a cláusula WHERE, então o DELETE deve ser aplicado a todas as tuplas da relação. Porém, a relação permanece no BD como uma relação vazia.

> O comando UPDATE

- Modifica o valor de atributos de uma ou mais tuplas

```
UPDATE tabela
SET lista_atributos com atribuicoes de valores
[WHERE condicao]
```

#OBS:

- Omitir a cláusula WHERE implica que o UPDATE deve ser aplicado a todas as tuplas da relação

#Ex:

- Modifique o nome do Departamento de Computação para Departamento de informática, e o telefone

```
UPDATE Departamento
SET nome = 'Informatica', tel = 333222
WHERE nome = 'Computação'
```

#OBS:

- Se houver mais de um atributos a serem alterados, os separamos por vírgula (,) na cláusula *SET*

#Ex:

- Dê um aumento de 10% a todos os empregados do departamento de pesquisa

```
UPDATE Empregado
SET SALARIO = 1.1*SALARIO
WHERE depto in (SELECT coddep 
FROM Departamento
WHERE nome = 'Pesquisa')
```

>O comando CASE

- Permite mudar o valor de um dado, por exemplo, poderiamos ter codificado o atributo sexo como 1 = masculino,  2 = feminino, 0 = indefinido, e então ao fazermos um select queremos expressar os valores por extenso ao invés de usar código.

```
SELECT mat, nome,
CASE
WHEN sexo = 1 THEN 'Masculino'
WHEN sexo = 2 THEN 'Feminino'
WHEN sexo = 0 THEN 'Indefinido'
END,
endereco, salario
FROM Empregado
```


[[Visões]]