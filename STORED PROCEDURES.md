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

- 