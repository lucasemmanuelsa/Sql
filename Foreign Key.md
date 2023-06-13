>Inclui regras de remoção/Atualização

>Supondo, T2 tem uma chave estrangeira para T1

## On Delete

- Restrict : remover uma linha de T1 da erro, pois alguma linha em T2 combina com a chave de T1 (Já que tem uma tabela T2 referenciando T1).
- Cascade :  se remover um atributo em T1, as linhas de T2 que combinarem com ela também serão removidas.
- SET NULL : remover T1, implica que valores da chave estrangeira em T2 nas linhas que combinam são postos par NULL.
- SET DEFAULT: remover T1, implica que valores da chave estrangeira em T2 nas linhas que combinam terão valores DEFAULT aplicados .

## On Update
- Restrict : update de atributo de T1 falha se existem linhas em T2 combinando.
- Cascade : update de atributo em T1 também atualiza linhas que combinam em T2.
- SET NULL : update de T1 fica NULL nas linhas de T2 que combinam com ele.
- SET DEFAUTLT : update de T1 fica DEFAULT nas linhas de T2 que combinam.


## CONSTRAINTS

- As restrições de integridade podem ter um nome e serem especificadas com a cláusula CONSTRAINT.

>Podemos eliminar (DROP) e alterar (ALTER) o constraint.

```
CONSTRAINT empCP PRIMARY KEY(matricula),
CONSTRAINT empSuperCE FOREIGN KEY(supervisor)
REFERENCES empregado(matricula) ON DELETE
SET NULL ON UPDATE CASCADE,
```

## ALTER TABLE

>Adicionar / remover / alterar os atributos de uma tabela

>Alterar restrições(Constraints)

- Adicionar coluna
	- Especificar o tipo de dado
	- Coluna não pode ser NOT NULL

```
ALTER TABLE tabela_base ADD [COLUMN] atributo tipo_dado
```

#OBS: No Oracle a cláusula opcional COLUMN não existe!

- Modificar uma coluna

```
ALTER TABLE tabela_base ALTER [COLUMN] atributo SET DEFAULT valor-default
```

- Removendo a configuração de valor DEFAULT da COLUNA

```
ALTER TABLE tabela_base ALTER [COLUMN] atributo DROP DEFAULT
```

- Removendo uma  restrição de uma TABELA

```
ALTER TABLE tabela_base DROP CONSTRAINT nome-constraint
```

- Remover uma coluna de uma tabela

```
ALTER TABLE tabela_base DROP [COLUMN] atributo
```

```
ALTER TABLE tabela_base DROP [COLUMN] atributo [CASCADE|RESTRICT]
```

- Adicionar restrições a uma tabela

```
ALTER TABLE tabela_base ADD CONSTRAINT ...
```

#ex:

```
ALTER TABLE tabela_base ADD CONSTRAINT empCP PRIMARY KEY(matricula)
```


### Exemplos Aleatórios para fixar:

- Resposta
	- Adiciona Coluna

```
ALTER TABLE Peca ADD espessura INT # adiciona uma coluna espessura na tabela Peca
```

- Resposta
	- Remove uma coluna e garante que se tiver dependências em outras tabelas,  seja removida em cascata.

```
ALTER TABLE empregado DROP endereco CASCADE
```

- Resposta
	- Remove a restrição DEFAULT da coluna

```
ALTER TABLE departamento ALTER gerente DROP DEFAULT
```

- Resposta
	- Adiciona uma configuração padrão para a coluna, definindo como default "333444555", Assim, caso não seja passado nenhuma valor na hora de criar uma linha, o valor padrão será esse.

```
ALTER TABLE departamento ALTER gerente SET DEFAULT "333444555"
```

- Resposta
	- Remove a restrição empsuperCE da tabela empregado e, se houver outras restrições dependentes dela, também serão removidas devido à opção CASCADE.

```
ALTER TABLE empregado DROP CONSTRAINT empsuperCE CASCADE
```

- Resposta
	- Adiciona uma restrição para a tabela empregado, no qual supervisor é uma chave estrangeira de empregado que referencia o atributo matricula.

```
ALTER TABLE empregado ADD CONSTRAINT empsuperCE FOREIGN KEY(supervisor) REFERENCES empregado(matricula)
```


## DROP TABLE

> Remove uma tabela base do banco de dados

> Remove os dados e a definição da tabela

```
DROP TABLE nomeTabela
```

## TRUNCATE TABLE

>Remove apenas os dados da tabela

>Metadados continuam intactos


```
TRUNCATE TABLE nomeTabela
```

## INDEX

>Criar e remover indices em colunas UNIQUE

#Ex:

- Criar um índice no atributo nome da relação Empregado

```
CREATE INDEX nome-indice ON Empregado(nome)
```

## SEQUÊNCIAS

>Gera valores numéricos de forma automática e sequencial

>Geralmente usado para gerar valores únicos em uma coluna de uma tabela.

```
CREATE SEQUENCE nome-sequencia START WITH valor-inteiro INCREMENT BY valor-do-incremento-inteiro [CYCLE|NOCYCLE]
```

#Ex1:

- Cria uma sequencia com valores padrão do SGBD.

```
CREATE SEQUENCE SEQ_1;
```

#Ex2:

- Cria uma sequencia com valores definidos

```
CREATE SEQUENCE SEQ_2 START WITH 500 INCREMENT BY -10 MAXVALUE 500 MINVALUE 0;
```

#Ex3:

- Cria uma sequencia com valores que começa em 500 e quando chegar em 0 começa a ciclar, reiniciando a contagem a partir do 500 e decrementando novamente.

```
CREATE SEQUENCE SEQ_3 START WITH 500 INCREMENT BY -10 MAXVALUE 500 MINVALUE 0 CYCLE
```

### ACESSANDO SEQUÊNCIAS - Oracle

- Mostra o valor corrente da sequencia SEQ1
- Dual é uma [[DUMMY TABLE]] no ORACLE

```
SELECT SEQ1.CURRVAL FROM DUAL
```

- Avança a SEQ1 e mostra seu VALOR

```
SELECT SEQ1.NEXTVAL FROM DUAL
```

## INSERINDO DADOS  NUMA TABLE

>Sintaxe

```
INSERT INTO EMPREGADO VALUES (SEQ2.NEXTVAL, 'MARIA DA PAZ', 9850.00, 'D1')
```

- Perceba, para melhor entendimento, que a sequência nesse caso, foi criada para criar chaves primarias automaticamente para a tabela EMPREGADO

## AUTO-INCREMENTO

>Implementação da ideia de gerar números automaticamente, sintaxe usada no MYSQL(Oracle)

```
CREATE TABLE Pessoas (ID INT AUTO_INCREMENT, Nome varchar(255) NOT NULL, Idade INT, PRIMARY KEY (ID));

INSERT INTO Pessoas (Nome, Idade) VALUES ('Larissa Silva', 42);
```

#OBS: Perceba que na inserção não se coloca o campo ID (do auto-incremento), pois a chave primaria já está sendo gerada automaticamente pela sequência.

## IDENTITY

>Implementação da ideia de gerar números automaticamente, sintaxe usada no MS SQL SERVER

```
CREATE TABLE Pessoas(ID INT IDENTITY(1,1) PRIMARY KEY, Nome varchar(255) NOT NULL, Idade INT);

INSERT INTO Pessoas(Nome, Idade) VALUES ('Larissa Silva',42);
```

#OBS: Perceba que na inserção não se coloca o campo ID (do identity), mesma coisa do Auto incremento do tópico anterior, porém com outra sintaxe.