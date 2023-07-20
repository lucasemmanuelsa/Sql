CREATE TABLE empregado (
matricula INT,
nome CHAR(80),
endereco CHAR(200),
salario NUMERIC(8,2),
supervisor INT,
depto INT,
PRIMARY KEY(matricula),
FOREIGN KEY(supervisor) REFERENCES empregado(matricula)
);


CREATE TABLE departamento (
coddep INT,
nome CHAR(30),
gerente INT,
datainit DATE,
PRIMARY KEY(coddep),
FOREIGN KEY (gerente) REFERENCES empregado(matricula)
);

ALTER TABLE empregado ADD CONSTRAINT depto_ref
FOREIGN KEY (depto) REFERENCES departamento(coddep)
INITIALLY DEFERRED DEFERRABLE;

CREATE TABLE projeto (
codproj INT,
nome VARCHAR(30),
localizacao VARCHAR(100),
depart INT,
PRIMARY KEY(codproj),
FOREIGN KEY(depart) REFERENCES departamento(coddep)
);

CREATE TABLE alocacao (
matric INT,
codproj INT,
horas INT,
PRIMARY KEY(matric, codproj),
FOREIGN KEY(matric) REFERENCES empregado(matricula),
FOREIGN KEY(codproj) REFERENCES projeto(codproj)
);

INSERT INTO EMPREGADO (Matricula, nome, endereco, salario, supervisor, depto) VALUES (1, 'João', 'Rua A, 123', 5000, 1, 1);
INSERT INTO EMPREGADO (Matricula, nome, endereco, salario, supervisor, depto) VALUES (2, 'Maria', 'Rua B, 456', 4000, 2, 2);
INSERT INTO EMPREGADO (Matricula, nome, endereco, salario, supervisor, depto) VALUES (3, 'Pedro', 'Rua C, 789', 4500, 3, 3);
INSERT INTO EMPREGADO (Matricula, nome, endereco, salario, supervisor, depto) VALUES (4, 'Ana', 'Rua D, 987', 5500, 4, 4);
INSERT INTO EMPREGADO (Matricula, nome, endereco, salario, supervisor, depto) VALUES (5, 'Lucas', 'Rua E, 654', 3800, 5, 5);
INSERT INTO EMPREGADO (Matricula, nome, endereco, salario, supervisor, depto) VALUES (6, 'Mariana', 'Rua F, 321', 4200, 6, 1);
INSERT INTO EMPREGADO (Matricula, nome, endereco, salario, supervisor, depto) VALUES (7, 'Carlos', 'Rua G, 135', 4800, 7, 2);
INSERT INTO EMPREGADO (Matricula, nome, endereco, salario, supervisor, depto) VALUES (8, 'Fernanda', 'Rua H, 579', 5100, 8, 3);
INSERT INTO EMPREGADO (Matricula, nome, endereco, salario, supervisor, depto) VALUES (9, 'Rodrigo', 'Rua I, 864', 4400, 9, 4);
INSERT INTO EMPREGADO (Matricula, nome, endereco, salario, supervisor, depto) VALUES (10, 'Julia', 'Rua J, 297', 4700, 10, 5);

INSERT INTO DEPARTAMENTO (Coddep, nome, gerente, datainit) VALUES (1, 'Vendas', 1, TO_DATE('2023-06-08', 'YYYY-MM-DD'));
INSERT INTO DEPARTAMENTO (Coddep, nome, gerente, datainit) VALUES (2, 'Marketing', 2, TO_DATE('2023-06-08', 'YYYY-MM-DD'));
INSERT INTO DEPARTAMENTO (Coddep, nome, gerente, datainit) VALUES (3, 'Recursos Humanos', 3, TO_DATE('2023-06-08', 'YYYY-MM-DD'));
INSERT INTO DEPARTAMENTO (Coddep, nome, gerente, datainit) VALUES (4, 'Finanças', 4, TO_DATE('2023-06-08', 'YYYY-MM-DD'));
INSERT INTO DEPARTAMENTO (Coddep, nome, gerente, datainit) VALUES (5, 'Tecnologia', 5, TO_DATE('2023-06-08', 'YYYY-MM-DD'));



INSERT INTO PROJETO (Codproj, nome, localizacao, depart) VALUES (1, 'Projeto A', 'São Paulo', 1);
INSERT INTO PROJETO (Codproj, nome, localizacao, depart) VALUES (2, 'Projeto B', 'Rio de Janeiro', 2);
INSERT INTO PROJETO (Codproj, nome, localizacao, depart) VALUES (3, 'Projeto C', 'Belo Horizonte', 3);
INSERT INTO PROJETO (Codproj, nome, localizacao, depart) VALUES (4, 'Projeto D', 'Salvador', 4);
INSERT INTO PROJETO (Codproj, nome, localizacao, depart) VALUES (5, 'Projeto E', 'Brasília', 5);
INSERT INTO PROJETO (Codproj, nome, localizacao, depart) VALUES (6, 'Projeto F', 'Porto Alegre', 1);
INSERT INTO PROJETO (Codproj, nome, localizacao, depart) VALUES (7, 'Projeto G', 'Curitiba', 2);
INSERT INTO PROJETO (Codproj, nome, localizacao, depart) VALUES (8, 'Projeto H', 'Fortaleza', 3);
INSERT INTO PROJETO (Codproj, nome, localizacao, depart) VALUES (9, 'Projeto I', 'Manaus', 4);
INSERT INTO PROJETO (Codproj, nome, localizacao, depart) VALUES (10, 'Projeto J', 'Recife', 5);


INSERT INTO ALOCACAO (matric, codproj, horas) VALUES (1, 1, 40);
INSERT INTO ALOCACAO (matric, codproj, horas) VALUES (2, 2, 35);
INSERT INTO ALOCACAO (matric, codproj, horas) VALUES (3, 3, 30);
INSERT INTO ALOCACAO (matric, codproj, horas) VALUES (4, 4, 45);
INSERT INTO ALOCACAO (matric, codproj, horas) VALUES (5, 5, 20);
INSERT INTO ALOCACAO (matric, codproj, horas) VALUES (6, 6, 25);


	
	
CREATE TABLE dependente (
    matricula INT,
    nome char(80),
    sexo char(1),
    PRIMARY KEY (matricula,nome),
    FOREIGN KEY (matricula) REFERENCES empregado(matricula)
);

ALTER TABLE empregado ADD sexo char(1);


INSERT INTO DEPARTAMENTO(CODDEP, NOME, GERENTE, DATAINIT) VALUES (14, 'Produção', 7, TO_DATE('1998-03-24', 'YYYY-MM-DD'));

INSERT INTO DEPENDENTE (Matricula, nome, sexo) VALUES (1, 'Teteu', 'M');
INSERT INTO DEPENDENTE (Matricula, nome, sexo) VALUES (1, 'Fernanda', 'F');
INSERT INTO DEPENDENTE (Matricula, nome, sexo) VALUES (1, 'Jorge', 'M');
INSERT INTO DEPENDENTE (Matricula, nome, sexo) VALUES (2, 'Zezinho', 'M');
INSERT INTO DEPENDENTE (Matricula, nome, sexo) VALUES (3, 'Dany', 'F');
INSERT INTO DEPENDENTE (Matricula, nome, sexo) VALUES (5, 'Caio', 'M');
INSERT INTO DEPENDENTE (Matricula, nome, sexo) VALUES (8, 'Manoele', 'F');
INSERT INTO DEPENDENTE (Matricula, nome, sexo) VALUES (10, 'Julia jr', 'F');
    
    
UPDATE EMPREGADO SET sexo = 'M' WHERE Matricula = 1;
UPDATE EMPREGADO SET sexo = 'F' WHERE Matricula = 2;
UPDATE EMPREGADO SET sexo = 'M' WHERE Matricula = 3;
UPDATE EMPREGADO SET sexo = 'F' WHERE Matricula = 4;
UPDATE EMPREGADO SET sexo = 'M' WHERE Matricula = 5;
UPDATE EMPREGADO SET sexo = 'F' WHERE Matricula = 6;
UPDATE EMPREGADO SET sexo = 'M' WHERE Matricula = 7;
UPDATE EMPREGADO SET sexo = 'F' WHERE Matricula = 8;
UPDATE EMPREGADO SET sexo = 'M' WHERE Matricula = 9;
UPDATE EMPREGADO SET sexo = 'F' WHERE Matricula = 10;


ALTER TABLE empregado ADD idade INT;
UPDATE EMPREGADO SET idade = 23 WHERE Matricula = 1;
UPDATE EMPREGADO SET idade = 25 WHERE Matricula = 2;
UPDATE EMPREGADO SET idade = 32 WHERE Matricula = 3;
UPDATE EMPREGADO SET idade = 40 WHERE Matricula = 4;
UPDATE EMPREGADO SET idade = 27 WHERE Matricula = 5;
UPDATE EMPREGADO SET idade = 19 WHERE Matricula = 6;
UPDATE EMPREGADO SET idade = 19 WHERE Matricula = 7;
UPDATE EMPREGADO SET idade = 40 WHERE Matricula = 8;
UPDATE EMPREGADO SET idade = 50 WHERE Matricula = 9;
UPDATE EMPREGADO SET idade = 53 WHERE Matricula = 10;
