>É uma relação virtual que não faz parte do esquema conceitual mas que é visível a um grupo de usuários

>Não é desejável que todos os usuários tenham acesso a todo o esquema, visões precisam ser definidas


- A visão é definida por uma DDL e é computada cada vez que são realizadas consultas aos dados daquela visão.
- O catálogo do SGBD é o repositório que armazena as definições das visões.
- Uma visão possui nome, uma lista de atributos e uma query que computa a visão.

> É uma tabela virtual que é definida a partir de outras tabelas, contendo sempre os dados atualizados

#Sintaxe

```
CREATE VIEW nomeVisão AS expressão_de_consulta
```

```
CREATE VIEW Alocacao1(nomeE, nomeP, Horas) AS SELECT e.nome, p.nome, horas
FROM Empregado e, Projeto p, Alocacao a
WHERE e.matricula = a.matricula and p.codproj = a.codproj
```

- Cria uma relação virtual - **Alocacao1**(nomeE, nomeP, horas)

- Podemos escrever consultas na visão definida

#Ex1:

- Obter o nome dos empregados que trabalham no projeto 'Projeto A'

```
SELECT nomeE
FROM Alocacao1
WHERE nomeP = 'Projeto A'
```

#Ex2:

- Criar uma visão que contém informações gerenciais sobre um departamento, contendo o nome do depto, total de empregado e total de salários.

```
CREATE VIEW deptGerencial(nomeD, totalEmp, totalSal) AS SELECT d.nome, COUNT(*) AS totalEmp, SUM(salario) AS totalSal
FROM departamento d, Empregado e
WHERE d.coddep = e.depto
GROUP BY d.nome
```

> Eliminando uma visão

- Usamos o comando **DROP VIEW**

#Sintaxe 

```
DROP VIEW nomeVisão
```

#Ex:

```
DROP VIEW Alocacao1
```

```
DROP VIEW deptGerencial
```

>Atualizando uma visão

- Para ilustrarmos alguns problemas, considere a visão Alocacao1 e suponha que queiramos atualizar o atributo nomeP da tupla que contém 'João' de 'Projeto A' para 'Projeto B'

#Ex:

```
UPDATE Alocacao1 SET nomeP = 'Projeto B'
WHERE nomeE = 'João' and nomeP = 'Projeto A'
```

- Dá erro na Oracle, se a view não tiver uma chave primária

- O update anterior pode ser mapeado em vários updates nas relações base.

- Dois possíveis Updates, com resultados diferentes são

#Update1

```
UPDATE Projeto
SET nome = ‘Projeto B’
WHERE nome = ‘Projeto A’
```

- Código para reverter o update anterior, caso esteja usando o esquema no Oracle Apex

```
UPDATE Projeto
SET nome = 'Projeto A'
WHERE nome = 'Projeto B' AND codproj = 1
```

#Update2 

```
UPDATE Alocacao
SET codproj = (SELECT codproj FROM Projeto
WHERE nome = ‘Projeto B’)
WHERE matricula IN (SELECT matricula FROM Empregado
WHERE nome = ‘João’)
AND codproj IN (SELECT codproj FROM Projeto
WHERE nome = ‘Projeto A’)
```

- Considere a visão alocacao1 se tentarmos fazer 

```
INSERT INTO alocacao1 VALUES ('José', 'SIG', 10)
```

- Outro problema em update de visão: suponha a seguinte visão

```
CREATE VIEW Emp2  
AS SELECT matricula, nome  
FROM Empregado  
WHERE depto = 1
```

- O que aconteceria se fizéssemos:

```
INSERT INTO emp2 VALUES (100, 'Ana')
```

- depto terá valor nulo, portanto o que acontece com

```
SELECT * FROM emp2
```

> Não aparece, pois na definição da View, mostrará apenas pessoas que tem depto = 1

- Alguns updates de visões não fazem sentido para a relação base

#Ex 

```
UPDATE deptGerencial SET totalsal = 10000
WHERE nomeD = 'Tecnologia'
```

>**Observações**

- Uma visão definida numa única tabela é atualizável se os atributos da visão contém a chave primária
- Visões definidas sobre múltiplas tabelas usando junção geralmente não são atualizáveis
- Visões usando funções de agrupamento e agregados não são atualizáveis

- Por isso alguns dos updates acima não funcionam :)

## Valores Nulos

>**Interpretação de um valor nulo**

- O atributo não se aplica a tupla 
- O valor do atributo para esta tupla é desconhecido
- O valor é conhecido mas está ausente (Não foi posto ainda)

>**Problemas com valores nulos**

- Problemas com junções (Informações são perdidas)
- Problemas com funções aritméticas,  pois os resultados com nulos serão sempre nulos
- O ```COUNT(*)``` conta as linhas com null mas ```count(coluna)``` conta apenas os não null

> **Lógica de nulls**

- Terceiro valor booleano ```DESCONHECIDO```
- Uma consulta somente produz valores se a condição da cláusula ```WHERE``` for ```VERDADE``` (```DESCONHECIDO``` não é suficiente)

> **Cuidado**

- Se X é um atributo inteiro com valor null

```
X * 0 = NULL
X - X = NULL
X + X = NULL
```

- Quando comparamos um valor nulo com outro  valor nulo usando um operador relacional o resultado é desconhecido

```
X = 3 => DESCONHECIDO (UNKNOWN)
X > 2 => DESCONHECIDO (UNKNOWN)
```

> Lógica de três valores

```
verdade = 1
falso = 0
desconhecido = 1/2
```

```
AND = min
OR = max
NOT(X) = 1 - X
```

- Algumas leis não funcionam

#Ex

```
p OR NOT p = verdade
```

- Para a lógica dos três valores: se p = desconhecido, então lado esquerdo = max(1/2, (1 - 1/2)) = 1/2 != 1

#Ex 

- Seja a tabela *Vende*

| Bar | Cerveja | Preco |
|-------|--------------|-----------|
| RubroNegro | Carlsberg | null |

```
SELECT bar
FROM Vende
WHERE preco < 2.00 OR preco >= 2.00
	desconhecido     desconhecido
```

- O bar ```RubroNegro``` não é selecionado mesmo se a cláusula ```WHERE``` é uma tautologia.

> Null representa valores UNKNOWN

- Uma operação artimética que envolve NULL retorna NULL

```
coluna minus null -> null
```

- Comparação booleana com NULL retorna UNKNOWN e não true/false

```
NULL = NULL -> UNKNOWN
VALOR > NULL -> UNKNOWN
VALOR < NULL -> UNKNOWN
VALOR <= NULL -> UNKNOWN
VALOR >= NULL -> UNKNOWN
VALOR <> NULL -> UNKNOWN // OBS o operador <> é de diferença
```

- Testar se um valor é NULL

```
WHERE valor is NULL
```

- Testar se um valor não é NULL

```
WHERE valor is not NULL
```

> **SELECT** retorna valores para consultas cujo `WHERE` seja `TRUE`

> **GROUP** retorna grupos para consultas cujo `HAVING` seja `TRUE`

> A função de agregação `COUNT(*)` conta todas as tuplas

> `COUNT(COLUNA)` conta as tuplas cujo valor para a coluna não seja `NULL`

