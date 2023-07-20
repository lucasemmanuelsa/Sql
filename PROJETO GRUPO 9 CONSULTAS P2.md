> Implemente uma função PL/SQL chamada calcula_media_pontos, onde é recebido o cpf de um cliente e é calculado o valor médio de pontos baseado na quantidade de compras feitas por aquele cliente (pontos / total compras), e é retornado nome do cliente, total pontos, total compras e média calculada

```
CREATE FUNCTION calcula_media_pontos (cpf IN cliente.cpf%TYPE)
RETURN regis
IS
    TYPE regis IS RECORD
        (nome cliente.nome%TYPE,
        totalPontos cliente.pontos%TYPE,
        totalCompras compra_produto.quantidade%TYPE,
        mediaCalculada cliente.pontos%TYPE);
    clinf regis;
    codigocli cliente.codcli%TYPE;
BEGIN
    SELECT cli.codcli INTO codigocli FROM cliente cli WHERE cli.cpf = cpf;
    SELECT codigo_cliente, COUNT(*) INTO codigocli, clinf.totalCompras FROM ORDEM_DE_COMPRA WHERE codigocli = codigo_cliente GROUP BY CODIGO_CLIENTE;
    SELECT cli.nome, cli.pontos INTO clinf.nome, clinf.totalPontos FROM cliente cli WHERE cli.cpf = cpf;
    clinf.mediaCalculada := clinf.totalPontos / clinf.totalCompras;
    RETURN clinf;
END;
```

```
CREATE OR REPLACE FUNCTION calcula_media_pontos (p_cpf IN cliente.cpf%TYPE)
RETURN VARCHAR2
IS
    p_nome cliente.nome%TYPE;
    totalPontos cliente.pontos%TYPE;
    totalCompras compra_produto.quantidade%TYPE;
    mediaCalculada cliente.pontos%TYPE;
    
    codigocli cliente.codcli%TYPE;
    regis VARCHAR2(200);
    cod2 cliente.codcli%TYPE;
BEGIN
    SELECT cli.codcli INTO codigocli FROM cliente cli WHERE cli.cpf = p_cpf;
    SELECT codigo_cliente, COUNT(*) INTO cod2, totalCompras FROM ORDEM_DE_COMPRA WHERE codigocli = codigo_cliente GROUP BY CODIGO_CLIENTE;
    SELECT cli.nome, cli.pontos INTO p_nome, totalPontos FROM cliente cli WHERE cli.cpf = p_cpf;

    IF totalCompras <> 0 THEN
        mediaCalculada := totalPontos / totalCompras;
    ELSE
        mediaCalculada := 0;
    END IF;

    regis := 'Nome do cliente: ' || p_nome || 
            ', Total de pontos: ' || totalPontos ||
            ', Total de compras: ' || totalCompras ||
            ', Média calculada: ' || mediaCalculada;

    RETURN regis;
END;
```

> 2 - Implemente uma Função PL/SQL chamada roleta_aumenta_pontos, onde é recebido um número qualquer (de 0 a 9) e é somado 7 pontos para uma pessoa que possui este número em seu CPF

```
CREATE OR REPLACE PROCEDURE roleta_aumenta_pontos (p_num IN NUMBER)
IS
BEGIN
    UPDATE cliente
    SET pontos = pontos + 7
    WHERE INSTR(cpf, TO_CHAR(p_num)) > 0;
END;
```

> 3 - Implemente uma função PL/SQL chamada apaga_compras_antigas que recebe uma data de compra e apaga todas as compras que foram feitas antes de determinada data, note que também é necessário apagar as informações relacionadas.

```
teste
```


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

> 7 Crie um trigger que adiciona "LTDA" ao fim do nome do fornecedor, note que só é adicionado caso já não exista no nome.

```
CREATE OR REPLACE TRIGGER adiciona_ltda BEFORE INSERT ON FORNECEDOR
FOR EACH ROW
BEGIN
    IF :NEW.nome NOT LIKE '%LTDA' THEN
        :NEW.nome := :NEW.nome || ' LTDA';
    END IF;
END;
```

```
INSERT INTO FORNECEDOR(codforn, cnpj, nome, home_page, email, telefone, end_rua, end_num, end_bairro, end_cidade, end_cep) VALUES(90, '9993333-33', 'Moura', 'tiboca', 'moura@gmail.com', '999311322', 'zepa','22', 'univ', 'cg','55549234')
```


> 8 Crie um trigger que transforma o 'end_bairro' como "centro", "end_num" como null, 'end_rua' como null do cliente como o nome da cidade quando o 'end_cep' é finalizado com '000'.

```
CREATE OR REPLACE TRIGGER cli_mod BEFORE INSERT ON CLIENTE
FOR EACH ROW
BEGIN
    IF :NEW.end_cep LIKE '%000' THEN
    :NEW.end_bairro := 'centro';
    :NEW.end_num := null;
    :NEW.end_rua := null;
    :NEW.end_cidade := null;
    END IF;
END;
```


> 9 Crie um trigger que transforma o 'SITE' da transportadora como 'Não cadastrado' quando for criado como null
> 

```
CREATE OR REPLACE TRIGGER mod_trans BEFORE INSERT ON transportadora
FOR EACH ROW
BEGIN
    IF :NEW.site is null THEN
        :NEW.site := 'Não cadastrado';
    END IF;
END;
```


