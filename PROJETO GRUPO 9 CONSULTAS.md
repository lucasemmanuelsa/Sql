>Qual o sobrenome mais comum entre os clientes?

```
SELECT sobrenome
FROM cliente
GROUP BY sobrenome
HAVING COUNT(*) = (SELECT MAX(COUNT(*)) FROM cliente GROUP BY sobrenome)
```

>Liste o domínio do email que possui mais clientes cadastrados

```
SELECT SUBSTR(email, INSTR(email, '@') + 1) AS dominio
FROM cliente
GROUP BY SUBSTR(email, INSTR(email, '@') + 1)
HAVING COUNT(*) = (SELECT MAX(COUNT(*)) FROM cliente GROUP BY SUBSTR(email, INSTR(email, '@') + 1))
```

>Liste o top 5 produtos que possuem as piores médias de avaliação.

```
SELECT p.nome, AVG(cm.NOTA)
FROM PRODUTO p JOIN COMPRA_AVALIA_PRODUTO cm ON p.codprod = cm.codigo_produto
GROUP BY p.nome
ORDER BY AVG(cm.NOTA)
FETCH FIRST 5 ROWS ONLY

```

> Qual o produto que gerou mais lucro?

```
SELECT NOME, (VALOR_ATUAL - PRECO_COMPRA)*QNTP AS LUCRO
FROM PRODUTO p JOIN (SELECT CODIGO_PRODUTO,VALOR_ATUAL, SUM(QUANTIDADE) as QNTP FROM COMPRA_PRODUTO GROUP BY CODIGO_PRODUTO, valor_atual) com ON p.codprod = com.codigo_produto
WHERE (VALOR_ATUAL - PRECO_COMPRA)*QNTP = (SELECT MAX((VALOR_ATUAL - PRECO_COMPRA)*QNTP) FROM PRODUTO p JOIN (SELECT CODIGO_PRODUTO, VALOR_ATUAL, SUM(QUANTIDADE) as QNTP FROM COMPRA_PRODUTO GROUP BY CODIGO_PRODUTO,valor_atual) com ON p.codprod = com.codigo_produto)
```

>Liste todos os clientes que moram na cidade 'Paulista' e possuem mais de R$ 100 na soma dos valores de suas notas fiscais

```
WITH clientes_paulista AS (
    SELECT *
    FROM CLIENTE
    WHERE END_CIDADE = 'Paulista'
),
notas AS (
    SELECT n.VALOR_TOTAL, o.CODIGO_CLIENTE
    FROM NOTA_FISCAL n JOIN ORDEM_DE_COMPRA o ON n.COD_ORDEM_COMPRA = o.CODORDEM
)
SELECT cl.CODCLI, cl.NOME, cl.EMAIL, cl.END_CIDADE, SUM(VALOR_TOTAL) AS TOTAL_NOTAS_FISCAIS
FROM clientes_paulista cl, notas nt
WHERE cl.CODCLI = nt.CODIGO_CLIENTE
GROUP BY cl.CODCLI, cl.NOME, cl.EMAIL, cl.END_CIDADE
HAVING SUM(VALOR_TOTAL) > 100
```

>Liste os produtos e suas avaliações que possuem mais de 200 caracteres.

```
SELECT p.nome, com.descricao
FROM PRODUTO p, COMPRA_AVALIA_PRODUTO com
WHERE com.CODIGO_PRODUTO = p.CODPROD AND LENGTH(com.descricao) > 200
GROUP BY p.nome, com.descricao
```

> Qual(is) fornecedor(es) que fornece a menor quantidade de produtos? (note que ele precisa fornecer no mínimo 1 produto)

```
SELECT f.nome, COUNT(*) AS Produtos
FROM fornecedor f JOIN fornecimento fo ON f.codforn = fo.codigo_fornecedor
GROUP BY f.nome
HAVING COUNT(*) >= 1 and COUNT(*) <= ALL (SELECT COUNT(*) AS Produtos
FROM fornecedor j JOIN fornecimento k ON j.codforn = k.codigo_fornecedor
GROUP BY j.nome)
ORDER BY COUNT(*)
```


```
SELECT f.nome, COUNT(*) AS Produtos
FROM fornecedor f JOIN fornecimento fo ON f.codforn = fo.codigo_fornecedor
GROUP BY f.nome
HAVING COUNT(*) >= 1
ORDER BY COUNT(*)

```

```
SELECT NOME, COUNT(*) AS MINIMO
FROM FORNECEDOR fo JOIN FORNECIMENTO forne ON fo.codforn = forne.codigo_fornecedor
GROUP BY NOME
HAVING COUNT(*) = (SELECT MIN(COUNT(*)) AS MINIMO FROM  FORNECEDOR f JOIN FORNECIMENTO forn ON f.codforn = forn.codigo_fornecedor GROUP BY f.codforn)
```


> Liste o email e telefone de fornecedores que fornecem o produto 'Bola de golfe' abaixo de 20 reais.

```
SELECT f.EMAIL, f.TELEFONE
FROM FORNECEDOR f, FORNECIMENTO fo, PRODUTO p
WHERE f.codforn = fo.codigo_fornecedor AND p.codprod = fo.codigo_produto AND p.nome = 'Bola de golfe' AND p.preco_compra < 20
```

> Liste todos os produtos que foram fabricados na década de 2010

```
SELECT NOME, DATA_FABRICACAO
FROM PRODUTO
WHERE EXTRACT(YEAR FROM DATA_FABRICACAO) BETWEEN 2010 AND 2019
ORDER BY DATA_FABRICACAO
```

>Quais compras possuem um valor de frete maior que o valor da compra (valor atual x quantidade, de cada um)


```
WITH compras AS (SELECT comp.CODIGO_COMPRA ,(comp.valor_atual * comp.quantidade) AS somaTotalCompra
FROM COMPRA_PRODUTO comp),
total_de_compra AS (SELECT CODIGO_COMPRA, SUM(somaTotalCompra) AS Preco_Compra_Total
FROM compras
GROUP BY CODIGO_COMPRA)
SELECT o.CODORDEM, o.VALOR_FRETE, t.preco_compra_total
FROM ORDEM_DE_COMPRA o, total_de_compra t
WHERE o.codordem = t.codigo_compra and o.valor_frete > t.preco_compra_total
```

>Qual o código, data e nome do cliente que possui uma compra com a maior porcentagem de desconto?

```
WITH compras AS (SELECT comp.CODIGO_COMPRA ,(comp.valor_atual * comp.quantidade) AS somaTotalCompra
FROM COMPRA_PRODUTO comp),

total_de_compra AS (SELECT CODIGO_COMPRA, SUM(somaTotalCompra) AS Preco_Compra_Total
FROM compras
GROUP BY CODIGO_COMPRA)
SELECT cli.codcli, cli.NOME, cli.data_nascimento
FROM CLIENTE cli, ORDEM_DE_COMPRA ord, total_de_compra t
WHERE t.CODIGO_COMPRA = ord.codordem and cli.codcli = ord.codigo_cliente and (100* ord.desconto / t.Preco_Compra_Total) = (SELECT MAX((100* ord.desconto / t.Preco_Compra_Total))
FROM ORDEM_DE_COMPRA ord, total_de_compra t
WHERE t.CODIGO_COMPRA = ord.codordem)
```

