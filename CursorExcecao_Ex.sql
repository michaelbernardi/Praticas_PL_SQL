/*  No �ltimo v�deo, ocorreu a seguinte transforma��o do CNPJ:

De: 68090
Para: 680/90

Usando o seu conhecimento de Oracle, e sabendo que o CNPJ sempre 
ser� de 5 d�gitos, como deve ser a procedure, que criamos no curso, 
para transformar o CNPJ em 68/09-0?
*/

CREATE OR REPLACE PROCEDURE formata_cnpj (
    p_CNPJ IN CLIENTE.CNPJ%type, 
    p_CNPJ_SAIDA OUT CLIENTE.CNPJ%type
)
IS
BEGIN
    p_CNPJ_SAIDA := SUBSTR(p_CNPJ,1,2) || '/' || SUBSTR(p_CNPJ,3,2) || '-' || SUBSTR(p_CNPJ,5,1);
END;
------------------------------------------------------------------------------------

/* Na base de dados carregada para este curso, temos o seguinte 
esquema de dados:


Crie uma procedure que, dado um identificador da venda (ID ),
da tabela PRODUTO_VENDA_EXERCICIO, temos como retorno o valor 
financeiro do imposto. O par�metro referente ao resultado do 
imposto deve ser passado para essa procedure como um par�metro OUT.

A f�rmula do imposto ser�: (PRECO * QUANTIDADE)*(PERCENTUAL_IMPOSTO/100) */

--Os seguintes comandos abaixo criam a procedure pedida no enunciado:
create or replace PROCEDURE CALCULA_IMPOSTO
(p_ID IN produto_venda_exercicio.id%type, p_VALOR_IMPOSTO OUT FLOAT)
IS
   v_PRECO produto_venda_exercicio.preco%type;
   v_QUANTIDADE produto_venda_exercicio.quantidade%type;
   v_PERCENTUAL_IMPOSTO produto_venda_exercicio.percentual_imposto%type;
BEGIN
   SELECT PRECO, QUANTIDADE, PERCENTUAL_IMPOSTO INTO v_PRECO, v_QUANTIDADE, v_PERCENTUAL_IMPOSTO
   FROM PRODUTO_VENDA_EXERCICIO WHERE ID = p_ID;
   p_VALOR_IMPOSTO := (v_PRECO * v_QUANTIDADE) * (v_PERCENTUAL_IMPOSTO/100);
END;

/*  Observa��o: a atividade mostrou uma forma de associar a v�rias vari�veis,
usando um �nico SQL, atrav�s da cl�usula INTO   */
SELECT PRECO, QUANTIDADE, PERCENTUAL_IMPOSTO INTO v_PRECO, v_QUANTIDADE, v_PERCENTUAL_IMPOSTO FROM PRODUTO_VENDA_EXERCICIO WHERE ID = p_ID;

---------------------------------------------------------------------------------------

--Veja a procedure abaixo:

create or replace PROCEDURE DUPLICA_VALOR
(p_VALOR IN FLOAT)
IS
BEGIN
  p_VALOR := p_VALOR * 2;
END;

--Ao tentar compilar essa procedure, temos:
--PLS-00363: a express�o 'P_VALOR' n�o pode ser usada como um destino de designa��o

/*  Altere essa procedure para que possamos usar a vari�vel p_VALOR tanto como 
entrada quanto como sa�da. */

create or replace PROCEDURE DUPLICA_VALOR
(p_VALOR IN OUT FLOAT)
IS
BEGIN
  p_VALOR := p_VALOR * 2;
END;

-------------------------------------------------------------------------------------

/*  Usando a procedure CALCULO_IMPOSTO, calcule o imposto da venda 2. Crie um 
programa em PL/SQL que exiba esse resultado.*/

SET SERVEROUTPUT ON;
DECLARE
   v_PERCENTUAL FLOAT;
BEGIN
   CALCULA_IMPOSTO(2, v_PERCENTUAL);
   dbms_output.put_line(v_PERCENTUAL); 
END;

--------------------------------------------------------------------------------







