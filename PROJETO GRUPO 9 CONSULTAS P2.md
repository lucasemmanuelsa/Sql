> 4 - Crie uma visão que retorna o nome e pontos dos clientes que indicaram outros clientes e possuem mais que 10 pontos


```
CREATE VIEW cliIndicAndPoints AS SELECT cl.nome, cl.pontos FROM CLIENTE cl, CLIENTE cli_indic WHERE cl.cliente_indica = cli_indic.codcli and cl.pontos > 10 
```


> 5- Crie uma visão que retorna o nome do produto e a quantidade de fornecedores que fornecem esse produto

```
CREATE VIEW prodQntForn AS SELECT p.nome AS nomeProduto, COUNT(*) AS qntFornecedores
FROM fornecimento f, Produto p
WHERE p.codprod = f.codigo_produto
GROUP BY p.nome
```


>6- Crie uma visão que retorne o nome da transportadora, total de produtos transportados e o valor total pago por frete


```
CREATE VIEW transpGerencial AS WITH totalqntprod AS (SELECT cp.CODIGO_COMPRA, SUM(cp.QUANTIDADE) AS QUANTIDADETOTAL
FROM COMPRA_PRODUTO cp, ORDEM_DE_COMPRA ord
WHERE cp.CODIGO_COMPRA = ord.codordem
GROUP BY cp.CODIGO_COMPRA)
SELECT t.nome, SUM(tqp.QUANTIDADETOTAL) AS TOTALPRODTRANSPORTADO, SUM(ord.VALOR_FRETE) AS VALORTOTALFRETE
FROM TRANSPORTADORA t, ordem_de_compra ord, totalqntprod tqp
WHERE tqp.codigo_compra = ord.codordem and ord.codigo_transportadora = t.codtrans
GROUP BY t.nome
```
