```
DELETE FROM Empregado
WHERE matricula IN (SELECT gerente
FROM departamento
WHERE coddep = 789)
```

```
UPDATE Empregado SET salario = 5000 WHERE matricula = 12345
```

```
select e.depto, count(*), avg(e.salario)
from empregado e
GROUP BY e.depto
```

```
CREATE VIEW nome_informa(nome) AS 
select e.nome 
from empregado e, alocacao al, projeto p 
where e.matricula = al.matric and al.codproj = p.codproj and p.nome = 'informatizacao'
```

```
CREATE VIEW nome_informa(nome) AS 
select e.nome 
from empregado e, alocacao al, projeto p 
where e.matricula = al.matric and al.codproj = p.codproj and p.nome = 'informatizacao'
```

```
CREATE VIEW detalhesEmpregado(matricula, nome, salario) AS
select matricula, nome, salario
from empregado
```

```
CREATE VIEW AlocacoesProjeto(nomep, nomeemp, horas) AS
select p.nome, e.nome, al.horas
from alocacao al, projeto p, empregado e
where e.matricula = al.matric and p.codproj = al.codproj
```

> Triggers

```
CREATE TRIGGER verificaSaldo AFTER UPDATE OF saldo ON Conta
REFERENCING
    OLD ROW AS antigo,
    NEW ROW AS novo
    FOR EACH ROW
    WHEN (novo.saldo > 2*antigo.saldo)
BEGIN
    UPDATE conta SET status = status + 1 WHERE numero = novo.numero;
END;
```

```

CREATE TRIGGER verificaSalario AFTER UPDATE OF salario ON empregado
REFERENCING
    OLD ROW AS antigo,
    NEW ROW AS novo
    FOR EACH ROW
    WHEN (novo.salario > 2*antigo.salario)
BEGIN
    UPDATE empregado SET idade = idade + 1 WHERE matricula = novo.matricula;
END;

```

```
CREATE TRIGGER verificaSalario AFTER UPDATE OF salario ON empregado
    FOR EACH ROW
    WHEN (new.salario > 2*old.salario)
BEGIN
    UPDATE empregado SET idade = idade + 1 WHERE matricula = :new.matricula;
END;
```

```

CREATE OR REPLACE TRIGGER verificaSalario
BEFORE UPDATE OF salario ON empregado
FOR EACH ROW
WHEN (NEW.salario > 2*OLD.salario)
BEGIN
    :NEW.idade := :NEW.idade + 1;
END;

```

deve ser assim, para evitar erro de mutacao

questao da prova

```
CREATE TRIGGER att_estoque AFTER UPDATE OF estoque ON Produto
FOR EACH ROW
WHEN(NEW.estoque < 5)
BEGIN
    INSERT INTO Compra (idProduto, quantidade) VALUES(:OLD.idProduto, 50);
END;
```


```
CREATE TRIGGER atua_prod AFTER UPDATE ON PRODUTO
FOR EACH ROW
WHEN(NEW.estoque < 5)
BEGIN
	INSERT INTO COMPRA VALUES(:NEW.IDPRODUTO, 50);
END;
```


```
CREATE VIEW nomeq (categoria, totaldin) AS
SELECT categoria, sum(preco*estoque)
FROM produto
GROUP BY categoria
HAVING sum(preco*estoque) > 3000
```

```
DELETE FROM COMPRA 
WHERE idProduto IN (SELECT idproduto FROM produto where categoria = 'Limpeza') and quantidade < 10
```

```
