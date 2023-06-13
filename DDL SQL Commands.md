### Create Table

- Table empregado

```
CREATE TABLE Empregado (
    matricula char(9),
    nome VARCHAR(15) NOT NULL,
    dataNasc DATE,
    endereco VARCHAR(30),
    sexo CHAR,
    salario NUMERIC(10,2),
    supervisor CHAR(9),
    depto INT NOT NULL,
    PRIMARY KEY (matricula),
    CHECK (salario >= 0), -- Restrição de integridade, o salario, nesta tabela, deve ser maior ou igual a 0
    FOREIGN KEY (supervisor) REFERENCES Empregado(matricula)
    
)
```

- Table Departamento
```
CREATE TABLE Departamento(
    codDep INT,
    nomeDep VARCHAR(15) NOT NULL UNIQUE,
    gerente CHAR(9) NOT NULL,
    dataInicioGer DATE,
    PRIMARY KEY(codDep),
    FOREIGN KEY(gerente) REFERENCES empregado(matricula)
)
```

> Problema do ovo e da galinha

-  `ALTER TABLE Empregado ADD CONSTRAINT empRefDepto FOREIGN KEY (depto) REFERENCES Departamento(codDep) INITIALLY DEFERRED DEFERRABLE`
- `ALTER TABLE Departamento ADD CONSTRAINT deptoRefEmp FOREIGN KEY (gerente) REFERENCES Empregado(matricula) INITIALLY DEFERRED DEFERRABLE`

>Povoando uma tabela

```
INSERT INTO chicken VALUES(1,2);
INSERT INTO egg VALUES(2,1);
COMMIT;
```

[[Foreign Key]]