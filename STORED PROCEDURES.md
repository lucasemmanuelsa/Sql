# SQL PSM -  STORED PROCEDURES PL/SQL

> **PSM - PERSISTENT STORED MODULES**

> **TÓPICOS**

- `Blocos anônimos`
- `Declaração e Atribuições de variáveis`
- `Condicionais`
- `Cursores`
- `Iterações`
- `Funções`
- `Tratamento de erros`
- `Stored Procedures`

>**MOTIVAÇÃO**

- SQL é bom mas...
	- Como verificar condições?
	- Como iterar?
	- Como verificar erros durante a manipulação de dados?
	- Instruções SQL são passadas para o SGBD uma por vez
		- Fazer requisições de consultas complexas envolvendo junções com muitas tabelas se torna custoso.

- SQL - PSM (Persistent Storage Module)
	- Padrão SQL para elaboração de Procedures e Functions que são armazenadas e executam no SGBD

- Cada SGBD oferece sua própria linguagem (PL/SQL, Transact/SQL, PL/pgSQL, etc.)

- Em PSM, definimos Módulos que sçao coleções de definições de funções ou procedimentos, declarações de tabelas temporárias, dentre outros.

>**Vantagens**

- Aplicações eficientes para grandes volumes de dados
	- Processamento é feito do lado do servidor

- Não necessita de API'S intermediárias (JDBC, por exemplo)

- Custo de manutenção relativamente baixo

>**Desvantagens**

- Código fica preso ao SGBD

- Fica preso às limitações da implementação

- Difícil de portar rotinas entre SGBDs distintos


> **PL/SQL**

- Linguagem de desenvolvimento do SGBD Oracle que "Implementa" SQL/PSM (Não é fiel ao padrão)

- Significa "Procedural Language extensions to SQL"

- Permite
	- Variáveis locais
	- Laços
	- Condições
	- Procedures
	- Consulta à relações "One tuple at a time"
	- etc.

- **Forma geral**

```
DECLARE
	declarações (optativo)
BEGIN
	comandos executáveis; (obrigatórios)
	EXCEPTION
		comandos para manipular erros(optativo)
END;
```

- Código PL/SQL é feito de blocos com uma única estrutura

- Existem dois tipos de blocos em PL/SQL
	- `Blocos Anônimos` : Não possuem nomes (são como scripts)
		- *Podem ser escritos e executados imediatamente*
		- *Podem ser usados em um trigger (gatilho)*
	- `Blocos Nomeados` : São armazenados no banco de dados
		- *Procedures*
		- *Functions*
		- *Pacotes*

### Blocos anônimos

```
DECLARE (opcional)
/*Aqui se declaram as variáveis que serão usadas no bloco*/
BEGIN (obrigatório)
/*Define-se os comandos que dizem o que o bloco faz*/
EXCEPTION (opcional)
/*Define-se as ações que acontecem se uma exceção for lançada durante a execução deste bloco*/
END; (obrigatório)
```

>**DECLARE**

#Ex 

```
-- um comentário de uma linha
/* um comentário de 
mais de uma linha*/

DECLARE
	descricao VARCHAR(90);
	contador BINARY_INTEGER := 0;   -- o operador := é de atribuição
	total NUMBER(9,2) := 0;
	data_entrega DATE := SYSDATE + 7; -- SYSDATE é a data do sistema
	desconto_padrao CONSTANT NUMBER(3,2) := 8.25; --Constante
	brasileiro BOOLEAN NOT NULL := TRUE; -- Não permite Null
	fumante BOOLEAN DEFAULT TRUE; --Valor padrão
	...
```

```
SET SERVEROUTPUT ON -- ativa a saída de dados, nao precisa colocar no oracle apex
DECLARE
	meuNome VARCHAR2(20);
BEGIN
	DBMS_OUTPUT.PUT_LINE('meu nome eh: ' ||meuNome); -- O PUT_LINE imprime uma linha
	meuNome := 'Rita';
	DBMS_OUTPUT.PUT_LINE('meu nome eh' ||meuNome); -- o || Concatena string
END;
```

#Ex: `Bloco Anônimo`

```
-- Bloco Anonimo # 1 --
-- Exibe o dia da semana da data corrente --
BEGIN
	DBMS_OUTPUT.PUT_LINE('Hoje o dia da semana é:'|| CHR(10) || TO_CHAR(SYSDATE, 'DAY'));
END;
```

- `CHR(10)`: É uma função que retorna o caractere de nova linha (line feed). Nesse caso, está sendo usado para adicionar uma quebra de linha na mensagem, separando a frase inicial da informação do dia da semana.

```
-- Bloco Anonimo # 2 --
-- Exibe a data e hora correntes --
BEGIN
	DBMS_OUTPUT.PUT_LINE('Output:'|| CHR(10) || TO_CHAR(SYSDATE, 'DD,MON,YYYY hh24:mm'));
END;
```

- `DBMS_OUTPUT.PUT_LINE`: É um procedimento do pacote `DBMS_OUTPUT` no Oracle que exibe uma linha de texto no console de saída. O texto a ser exibido é fornecido como parâmetro para esse procedimento.

#### Declarando variáveis com %TYPE

#Sintaxe 

- Identificador `tabela.coluna%TYPE;` ou `variável%TYPE;`
- É uma boa prática utilizar %TYPE para declarar tipos das variáveis

```
DECLARE
	...
	descricao produto.desc%TYPE;
	balanco NUMBER(7,2);
	resumo_balanco balanco%TYPE := 1000;
	...
```

- Ao declarar uma variável utilizando `%TYPE`, você está associando o tipo de dados dessa variável a uma coluna específica de uma tabela existente no banco de dados. Em vez de especificar manualmente o tipo de dados da variável, você pode usar `%TYPE` para obter automaticamente o tipo de dados da coluna associada.

- No caso do exemplo `resumo_balanco balanco%TYPE := 1000;`, o compilador irá verificar o tipo de dados da coluna `balanco` em uma tabela existente e atribuirá esse tipo de dados à variável `resumo_balanco`. Em seguida, o valor `1000` será atribuído à variável.

- Essa abordagem é útil quando você deseja declarar uma variável com base no tipo de dados de uma coluna existente e inicializá-la com um valor específico. Com isso, você pode garantir que a variável terá o mesmo tipo de dados da coluna, facilitando a consistência e a integridade do código.

```
DECLARE
	nomeP pesquisador.nome%TYPE;
	instituicaoP pesquisador.instituicao%TYPE;
BEGIN
	SELECT nome, instituicao INTO nomeP,instituicaoP
	FROM pesquisador
	WHERE codPesquisador = 'p001';
	DBMS_OUTPUT.PUT_LINE('Nome, Inst: '||nomeP);
	DBMS_OUTPUT.PUT_LINE('Nome, Inst: '||instituicaoP);
END;
```

```
DECLARE
	nomeP produto.nome%TYPE;
	descP produto.descricao%TYPE;
BEGIN
	SELECT nome, descricao INTO nomeP,descP
	FROM produto
	WHERE codprod = 3;
	DBMS_OUTPUT.PUT_LINE('Nome: '||nomeP);
	DBMS_OUTPUT.PUT_LINE('Descrição: '||descP);
END;
```

#### Criando um Record (Registro)

> Um **Record** é um tipo de variável que podemos definir (como `struct` em `C` ou `object` em Java)

```
DECLARE
	TYPE sailor_record_type IS RECORD
		(sname VARCHAR2(10),
		 sid   VARCHAR2(9),
		 age   NUMBER(3),
		 rating NUMBER(3));
	sailor_record sailor_record_type;
...
BEGIN
	sailor_record.sname:='peter';
	sailor_record.age:=45;
...
```

#### Tipo %ROWTYPE

- Qualquer estrutura (e.g. cursores e nomes de tabela) que tem um tipo tupla pode ter seu tipo capturado com `%ROWTYPE`

- Pode-se criar variáveis temporárias tipo tupla e acessar seus componentes como variável.componente ("dot notation")

- Muito útil, principalmente se a tupla tem muitos componentes

>**DECLARANDO VARIÁVEIS COM %ROWTYPE**

#Ex

- Declare uma variável (registro) com o tipo de uma linha de uma tabela

```
reserves_record Reserves%ROWTYPE;
```

```
reserves_record.sid := 9;
reserves_record.bid := 877;
```

#Ex 

```
-- Bloco Anonimo # 3 --
-- Exibe dados de um funcionario da tabela empregado --
DECLARE
	emp empregado%ROWTYPE;
BEGIN
	SELECT * INTO emp FROM empregado WHERE mat = 1000;
	DBMS_OUTPUT.PUT_LINE('------------------------');
	DBMS_OUTPUT.PUT_LINE('ID:'||TO_CHAR(em.mat));
	DBMS_OUTPUT.PUT_LINE('Nome:'||TO_CHAR(emp.nome));
	DBMS_OUTPUT.PUT_LINE('Salário:'||TO_CHAR(emp.salario));
	DBMS_OUTPUT.PUT_LINE('------------------------');
END;
```

```
DECLARE
	cli cliente%ROWTYPE;
BEGIN
	SELECT * INTO cli FROM cliente WHERE codcli = 1;
	DBMS_OUTPUT.PUT_LINE('------------------------');
	DBMS_OUTPUT.PUT_LINE('Id:'||TO_CHAR(cli.codcli));
	DBMS_OUTPUT.PUT_LINE('Nome:'||TO_CHAR(cli.nome));
	DBMS_OUTPUT.PUT_LINE('Pontos:'||TO_CHAR(cli.pontos));
	DBMS_OUTPUT.PUT_LINE('------------------------');
END;
```

- Não quebra se tirar o TO_CHAR, pode printar normalmente na tela se for um número

#### CONDICIONAIS

```
IF <condicao> THEN
				<comando(s)>
ELSIF <condicao> THEN
				<comando(s)>
ELSE
				<comando(s)>
END IF;
```

```
CASE [expressão]
	WHEN condicao_1 THEN resultado_1
	WHEN condicao_2 THEN resultado_2
	...
	WHEN condicao_n THEN resultado_n
	ELSE resultado
END;
```

#Ex 

```
DECLARE
	x number:=10;
BEGIN
	IF x <> 0 THEN
		IF x <0 THEN
			DBMS_OUTPUT.PUT_LINE('x < 0');
		ELSE
			DBMS_OUTPUT.PUT_LINE('x > 0');
		END IF;
	ELSE
		DBMS_OUTPUT.PUT_LINE('x = 0');
	END IF;
END;

```

```
DECLARE
	p_ano int = 2010;
	studio char[15] = 'Marvel';
BEGIN
	IF NOT EXISTS (SELECT * FROM Filme WHERE ano = p_ano AND nomeStudio = studio) THEN 
	DBMS_OUTPUT.PUT_LINE('NO');
	ELSE
		DBMS_OUTPUT.PUT_LINE('YES');
	END IF;
END;
```

#### CURSORES

- Ponteiro para uma única tupla do resultado da consulta (result set)

- Cada cursor possui uma consulta associada, especificada como parte da operação que define o cursor

- A consulta é executada quando o cursor for aberto

- Em uma mesma transação, um cursor pode ser aberto ou fechado qualquer número de vezes

- Pode-se ter vários cursores abertos ao mesmo tempo

> Declaração

```
CURSOR <nome> IS
	comando select-from-where
```

- O cursor aponta para cada tupla por vez da **relação-resultado** da consulta `select-from-where`, usando um *fetch statement* dentro de um laço

	- *Fetch statement*
		```
		FETCH <nome_cursor> INTO
			lista_variáveis;
		```

- Um laço é interrompido por

```
EXIT WHEN <nome_cursor>%NOTFOUND;
/*O valor é TRUE se não houver mais tupla a apontar*/
```

- `OPEN` e `CLOSE` abrem e fecham um cursor

> Um cursor possui as seguintes operações

- **OPEN**
	- Executa a consulta especificada e põe o cursor para apontar para uma posição anterior à primeira tupla do resultado da consulta
- **FETCH**
	- Move o cursor para apontar para a próxima linha no resultado da consulta, tornando-a a tupla corrente e copiando todos os valores dos atributos para as variáveis da linguagem hospedeira usada
- **CLOSE**
	- Fecha o cursor


<div style="display: flex;">
    <div style="border: 2px solid black; padding: 10px; width: fit-content;">
        <p style="text-align: center;">DECLARE</p>
    </div>
	
	<div style="display: flex; align-items: center;">
        <span style="font-size: 20px;">➔</span>
    </div>

    <div style="border: 2px solid black; padding: 10px; width: fit-content;">
        <p style="text-align: center;">OPEN</p>
    </div>
    
	<div style="display: flex; align-items: center;">
        <span style="font-size: 20px;">➔</span>
    </div>
    
    <div style="border: 2px solid black; padding: 10px; width: fit-content;">
        <p style="text-align: center;">FETCH</p>
    </div>
	 <div style="display: flex; align-items: center;">
        <span style="font-size: 20px;">➔</span>
    </div>
    <div style="border: 2px solid black; padding: 10px; width: fit-content;">
        <p style="text-align: center;">Vazio?</p>
    </div>
    <div style="display: flex; align-items: center;">
        <span style="font-size: 20px;">➔</span>
    </div>
    <div style="border: 2px solid black; padding: 10px; width: fit-content;">
        <p style="text-align: center;">CLOSE</p>
    </div>
</div>

- DECLARE
	- Cria um cursor
- OPEN
	- Abre o cursor
- FETCH
	- Carrega a linha atual em variáveis
- VAZIO?
	- Se não estiver vazio volta e o Fetch aponta para a próxima linha
	- Se estiver vazio, CLOSE
- CLOSE : Libera o cursor

#Ex 

```
DECLARE
    CURSOR c IS
    SELECT nome, pontos 
    FROM cliente;
    v_nome cliente.nome%TYPE;
    v_pontos cliente.pontos%TYPE;
BEGIN
	OPEN c;
	FETCH c INTO v_nome, v_pontos;
    DBMS_OUTPUT.PUT_LINE('Nome : '||v_nome);
    DBMS_OUTPUT.PUT_LINE('Pontos :'||v_pontos);
    CLOSE c;
END;

```

- Com `LOOP`

```
DECLARE
    numPon INT := 5;
    CURSOR c IS
    SELECT nome, pontos 
    FROM cliente
    WHERE pontos > numPon;
    v_nome cliente.nome%TYPE;
    v_pontos cliente.pontos%TYPE;
BEGIN
	OPEN c;
    LOOP
        FETCH c INTO v_nome, v_pontos;
        EXIT WHEN c%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Nome : '||v_nome);
        DBMS_OUTPUT.PUT_LINE('Pontos : '||v_pontos);
    END LOOP;
    CLOSE c;
END;
```

- Por `Default` os cursores movem-se do inicio do `result set` para frente (forward)
- Podemos também movê-lo para trás e/ou para qualquer posição no `result set`
- Devemos acrescentar `SCROLL` na definição do cursor

#Ex 

```
EXEC DECLARE
MeuCursor SCROLL CURSOR FOR Cliente;
```

> Pode ser adicionado no FETCH

- **NEXT ou PRIOR** : pega o próximo ou o anterior
- **FIRST ou LAST** : obtém o primeiro ou o ultimo
- **RELATIVE** Seguido de um inteiro: indica quantas tuplas mover para frente (se posivtivo) ou quantas tuplas mover para trás (se negativo).
- **ABSOLUTE** seguido de um inteiro : indica a posição da tupla contando do início (se positivo) ou do final(se negativo)

#Ex 

```
DECLARE
	pi CONSTANT NUMBER(8,7) := 3.1415926;
	area NUMBER(14,2);
	CURSOR rad_cursor IS SELECT * FROM rad_vals;
	rad_value rad_cursor%ROWTYPE;
BEGIN
	OPEN rad_cursor;
	LOOP
		FETCH rad_cursor INTO rad_value;
		EXIT WHEN rad_cursor%NOTFOUND;
		area := pi * power(rad_value.radius, 2);
		INSERT INTO areas VALUES(rad_value.radius, area);
	END LOOP;
	CLOSE rad_cursor
	COMMIT;
END;
```

- **Procedimento** que calcula a duração média dos filmes de um estúdio

```
DECLARE
	CURSOR filmeCursor IS 
	SELECT duracao 
	FROM Filme
	WHERE nomeStudio = 'Disney';
	novaDuracao INTEGER;
	contaFilmes INTEGER;
	mean REAL;
BEGIN
	mean := 0.0;
	contaFilmes := 0;
	OPEN filmeCursor;
	LOOP
		FETCH filmeCursor INTO novaDuracao;
		EXIT WHEN filmeCursor%NOTFOUND;
		contaFilmes := contaFilmes + 1;
		mean := mean + novaDuracao;
	END LOOP;
	mean := mean / contaFilmes;
	CLOSE filmeCursor;
END;
```

> Atributos explícitos de cursores

- Obtém informações de status sobre um cursor

| Atributo | Tipo | Descrição |
|---------------|---------|-----------------|
| %**ISOPEN** | Boolean | Retorna TRUE se o cursor estiver aberto |
| %**NOTFOUND** | Boolean | Retorna TRUE se o fetch mais recente não retorna uma tupla |
| %**FOUND** | Boolean | Retorna TRUE se o fetch mais recente retorna uma tupla (complemento de %NOTFOUND)|
| %**ROWCOUNT** | Number | Retorna o total de tuplas acessadas **até o momento** |


#Ex 

- Usando o %ROWCOUNT

```
DECLARE
    numPon INT := 5;
    CURSOR c IS
    SELECT nome, pontos 
    FROM cliente
    WHERE pontos > numPon;
    v_nome cliente.nome%TYPE;
    v_pontos cliente.pontos%TYPE;
BEGIN
	OPEN c;
    LOOP
        FETCH c INTO v_nome, v_pontos;
        EXIT WHEN c%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Nome : '||v_nome);
        DBMS_OUTPUT.PUT_LINE('Pontos : '||v_pontos);
        DBMS_OUTPUT.PUT_LINE('Tupla numero '|| c%ROWCOUNT);
    END LOOP;
    CLOSE c;
END;
```

#### **ITERAÇÕES**

- Laços **FOR**

```
FOR <counter> in <lower_bound>..<higher_bound>
LOOP
	...<<set of statements>>...
END LOOP;
```

#Ex 

```
BEGIN
	FOR i IN 1..10
	LOOP
		DBMS_OUTPUT.PUT_LINE('i ='||i);
	END LOOP;
END;
```

#Ex 

```
DECLARE
	contaFilmes INTEGER;
	mean REAL;
BEGIN
	mean := 0.0;
	contaFilmes := 0;
	FOR filme IN (SELECT duracao FROM Filme WHERE nomeStudio = 'Disney');
	LOOP
		contaFilmes := contaFilmes + 1;
		mean := mean + duracao;
	END LOOP;
	mean := mean / contaFilmes;
END;
```

- OBS : veja que não precisa de OPEN, FETCH e CLOSE do cursor

> Cursor implícito com **FOR**

```
CREATE OR REPLACE PROCEDURE imprime_grandes_salarios
IS
BEGIN
	FOR emp_rec IN (SELECT last_name, salary FROM employees WHERE salary >=10000)
	LOOP
	DBMS_OUTPUT.PUT_LINE(emp_rec.last_name||'ganha'||emp_rec.salary||'Dólares por mês');
	END LOOP;
END;

```

```
CREATE OR REPLACE PROCEDURE imprime_cliente_pontos IS
BEGIN
	FOR cli IN (SELECT nome, pontos FROM cliente WHERE pontos >= 5) 
    LOOP
        DBMS_OUTPUT.PUT_LINE(cli.nome||' possui '||cli.pontos||'Pontos');
    END LOOP;
END;
```

- Para chamar a procedure que acabamos de criar

```
BEGIN
    imprime_cliente_pontos;
END;
```

> Outros tipos de laços em PSM

- Laço **WHILE**

```
WHILE <condicao> DO
	<comandos>
END WHILE;
```

- **REPEAT**

```
REPEAT
	<comandos>
UNTIL <condição>
END REPEAT;
```

#Ex 

```
DECLARE
	TEN number:=10;
	i number_table.num%TYPE:=1;
BEGIN
	WHILE i <= TEN LOOP
		INSERT INTO number_table VALUES (i);
		i := i+1;
	END LOOP;
END;
```

#### **Funções**

- Podemos definir uma função da seguinte forma

```
CREATE FUNCTION <name> (<param_list>)
RETURN <return_type>
IS ...
```

- No corpo da função, `RETURN <expression>;` sai (retorna) da função e retorna o valor de `<expression>`


#Ex 

```
CREATE FUNCTION P_Filmes(p_ano int, studio char[15])
RETURN BOOLEAN
IS
BEGIN
	IF EXISTS (SELECT * FROM Filme WHERE ano = p_ano AND nomeStudio = studio) THEN RETURN TRUE;
	ELSE RETURN FALSE;
	END IF;
END;
```

- O exists da erro assim, pois deve ser usado dentro de consultas apenas


```
CREATE FUNCTION p_cliente_alternative(cod CHAR) RETURN BOOLEAN IS
    v_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM cliente WHERE cod = end_num;
    
    IF v_count > 0 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
```

```
CREATE FUNCTION get_descricao_produto (p_ID IN produto.codprod%TYPE)
RETURN produto.descricao%TYPE
IS
	v_descricao Produto.descricao%TYPE;
BEGIN
	SELECT descricao INTO v_descricao FROM produto WHERE codprod = p_ID;
	RETURN v_descricao;
END;
```

- Invocando a função acima a partir de um select

```
SELECT CODPROD, get_descricao_produto(codprod) FROM produto WHERE codprod = 1;
```

```
DECLARE
	v_desc produto.descricao%TYPE;
	v_id produto.codprod%TYPE := 2;
BEGIN
	v_desc := get_descricao_produto(v_id);
	DBMS_OUTPUT.PUT_LINE('A descrição do produto é' || v_desc);
END;
```

> Para dropar uma function

```
DROP FUNCTION get_descricao_produto;
```

#### Tratamento de erros

- É possível testar o SQLSTATE para verificar a ocorrência de erros e tomar uma decisão, quando erros ocorram
- Isto é feito através do EXCEPTION HANDLER que é associado a blocos BEGIN END (o handler aparece dentro do bloco)
- Os componentes do handler são
	- Lista de exceções a serem tratadas
	- Código a ser executado quando exceção ocorrer
	- Indicação para onde ir depois que o handler concluir

#Sintaxe 

```
DECLARE <onde ir> HANDLER FOR <condições>
	<comando>
```

- As escolhas de `<onde ir>` são 

`CONTINUE`
`EXIT` - Sai do bloco BEGIN .. END
`UNDO`

#Ex 

```
CREATE FUNCTION getSalario (mat integer)
RETURN FLOAT
DECLARE NotFound CONDITION FOR SQLSTATE '02000';
DECLARE TooMany CONDITION FOR SQLSTATE '21000'
BEGIN
	DECLARE EXIT HANDLER FOR NotFOund, TooMany
		RETURN NULL;
	RETURN (SELECT salario FROM Empregado WHERE matricula = mat);
END;
```

```
CREATE FUNCTION getSalario (mat integer)
RETURN FLOAT
DECLARE NotFound CONDITION FOR SQLSTATE '02000';
DECLARE TooMany CONDITION FOR SQLSTATE '21000'
BEGIN
	DECLARE EXIT HANDLER FOR NotFOund, TooMany
		RETURN NULL;
	RETURN (SELECT salario FROM Empregado WHERE matricula = mat);
END;
```

- TooMany -> muitas linhas retornadas pelo SELECT
- NotFound -> nenhuma linha retornada pelo SELECT

#Sintaxe 

```
EXCEPTION
WHEN nomeExcecao1 THEN
	comandos;
WHEN nomeExcecao2 THEN
	comandos;
WHEN others THEN
	comandos;
```

#Ex 

```
CREATE TABLE Pais (id NUMBER PRIMARY KEY, Nome VARCHAR2(20));

BEGIN
	INSERT INTO pais VALUES (100, 'Brasil');
	COMMIT;
	DBMS_OUTPUT.PUT_LINE('Inserção realizada com sucesso');
	EXCEPTION
		WHEN dup_val_on_index THEN
			DBMS_OUTPUT.PUT_LINE('País já cadastrado!');
		WHEN others THEN
			DBMS_OUTPUT.PUT_LINE('Erro ao cadastrar país');
END;
```

```
DROP TABLE PAIS
```

>Visualizando erros na criação de uma procedure/function

- Quando se cria uma procedure, se houver erros na sua definiçao, estes não serão mostrados

- Para ver os erros de procedure chamada myProcedure

```
SHOW ERRORS PROCEDURE myProcedure /*no ISQLPLUS prompt*/
```

- Para funções

```
SHOW ERRORS FUNCTION myFunction
```

#### STORED PROCEDURES

- São objetos armazenados no BD que usam comandos PL/SQL e SQL em seus corpos

`Sintaxe`

```
CREATE OR REPLACE PROCEDURE <nome> (<lista_argumentos>)
IS
	<declarações>
BEGIN
	<comandos PL/SQL e SQL>
END;
```

- `<Lista_argumentos>` tem triplas nome-modo-tipo.
	- Modo : IN, OUT ou  IN OUT para read-only, write-only, read/write, respectivamente
		- OBS : Se omitido o Modo, por default é IN (parâmetro de entrada read-only)
	- Tipos de Dados
		- Padrão SQL + tipos genéricos como NUMBER = qualquer tipo inteiro ou real
	- Como tipos nas procedures devem casar com tipos no esquema do bd, pode-se usar uma expressão da forma `tabela.campo%TYPE` para capturar o tipo corretamente

#Ex 

- Uma procedure que inclui uma nova cerveja e seu preço no menu do bar AlviRubro
- **Vende**(*bar, cerveja*, preco)

```
CREATE OR REPLACE PROCEDURE menuAlvi(p_cerva vende.cerveja%TYPE, p_preco vende.preco%TYPE)
IS
BEGIN
	INSERT INTO vende VALUES('AlviRubro', p_cerva, p_preco);
	COMMIT;
END;
```

- Pode ser testado no schema Empregado

```
CREATE OR REPLACE PROCEDURE p1 (p_empid IN NUMBER, p_sal OUT NUMBER)
IS
BEGIN
	SELECT salario
	INTO p_sal
	FROM empregado
	WHERE empregado.matricula = p_empid;
END;
```

```
CREATE OR REPLACE PROCEDURE p2
IS
	v_sal NUMBER;
	v_empid NUMBER :=101;
BEGIN
	p1(v_empid, v_sal);
	DBMS_OUTPUT.PUT_LINE('O empregado '||TO_CHAR(v_empid)||'recebe'||TO_CHAR(v_sal));
END;
```

```
BEGIN
    p2;
END;
```

- Procedure para incluir um segmento de mercado na tabela SEGMERCADO (ID, DESCRICAO)

```
CREATE OR REPLACE PROCEDURE incluir_segmercado (
	p_ID IN segmercado.ID%TYPE,
	p_DESCRICAO IN segmercado.descricao%TYPE
)
IS
BEGIN
	INSERT INTO SEGMERCADO VALUES (p_ID, UPPER(p_DESCRICAO));
	COMMIT;
END;
```

> Para remover uma Stored Procedure/Function

```
DROP PROCEDURE nome;
DROP FUNCTION nome;
```

> Como executar funções e Procedures

- **FUNCTION**

```
DECLARE
	texto VARCHAR2(1000);
BEGIN
	texto := func01(2);
	DBMS_OUTPUT.PUT_LINE(texto);
END;
```

- **PROCEDURE**

```
BEGIN
	menuAlvi('Bud', 2.50);
	menuAlvi('Carlsberg', 5.00);
END;
```

```
/*Fora de um bloco BEGIN...END; */

EXECUTE menuAlvi('Bud', 2.50);
```

> Exercício

**Empregado**(*id*, nome, salario, comissao, sal_total)

- Criar uma função (calc_sal_total) que calcule o salário total de um empregado (salário fixo + comissão). A função deve receber dois valores numéricos e devolver um valor numérico
- Criar uma procedure (update_sal) que atualize o salário total de todos os empregados usando a função calc_sal_total. Um cursor deve ser usado dentro da procedure