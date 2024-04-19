SELECT * FROM PRODUTO_EXERCICIO;

--INCLUSAO DE INFO DOS PRODUTOS
DECLARE
   v_COD PRODUTO_EXERCICIO.COD%type := '92347';
   v_DESCRICAO PRODUTO_EXERCICIO.DESCRICAO%type := 'Aroma do Campo - Mate - 1 Litro';
   v_CATEGORIA PRODUTO_EXERCICIO.CATEGORIA%type := 'Águas';
BEGIN
   INSERT INTO PRODUTO_EXERCICIO (COD, DESCRICAO, CATEGORIA) VALUES (v_COD, REPLACE(v_DESCRICAO,'-','>')
   , v_CATEGORIA);
   COMMIT;
END;

--ALTERAÇÃO INFO DOS PRODUTOS

DECLARE
   v_COD PRODUTO_EXERCICIO.COD%type := '67120';
   v_CATEGORIA PRODUTO_EXERCICIO.CATEGORIA%type := 'Mate';
BEGIN
   UPDATE PRODUTO_EXERCICIO SET CATEGORIA = UPPER(v_CATEGORIA) WHERE COD = v_COD;
   v_COD := '92347';
   v_CATEGORIA := 'Mate';
   UPDATE PRODUTO_EXERCICIO SET CATEGORIA = UPPER(v_CATEGORIA) WHERE COD = v_COD;
   COMMIT;
END;

--EXCLUSAO DE INFO DOS PRODUTOS
DECLARE
   v_COD PRODUTO_EXERCICIO.COD%type := 92347;
BEGIN
   DELETE FROM PRODUTO_EXERCICIO WHERE COD = v_COD;
   COMMIT;
END;


--Construa as seguintes procedures:

/* INCLUINDO_PRODUTO 
- Inclui um produto novo, passando como parâmetros todos os campos
para inclusão de um produto na tabela.  */
CREATE OR REPLACE PROCEDURE INCLUIR_PRODUTO 
(p_COD PRODUTO_EXERCICIO.COD%type
, p_DESCRICAO PRODUTO_EXERCICIO.DESCRICAO%type
, p_CATEGORIA PRODUTO_EXERCICIO.CATEGORIA%type)
IS
BEGIN
   INSERT INTO PRODUTO_EXERCICIO (COD, DESCRICAO, CATEGORIA) VALUES (p_COD, UPPER(p_DESCRICAO), UPPER(p_CATEGORIA));
   COMMIT;
END;

/* ALTERANDO_CATEGORIA_PRODUTO 
- Altera apenas a categoria do produto, dado um código.  */

CREATE OR REPLACE PROCEDURE ALTERAR_CATEGORIA_PRODUTO
(p_COD IN PRODUTO_EXERCICIO.COD%type
, p_CATEGORIA IN PRODUTO_EXERCICIO.CATEGORIA%type)
IS
BEGIN
    UPDATE PRODUTO_EXERCICIO SET CATEGORIA = p_CATEGORIA WHERE COD = p_COD;
    COMMIT;
END;

/* EXCLUINDO_PRODUTO
- Exclui um produto, passando como parâmetro o seu código.
Depois, teste as procedures acima:   */
CREATE OR REPLACE PROCEDURE EXCLUIR_PRODUTO
(p_COD IN PRODUTO_EXERCICIO.COD%type)
IS
BEGIN
    DELETE FROM PRODUTO_EXERCICIO WHERE COD = p_COD;
    COMMIT;
END;

/* a) Incluindo dois novos produto:
COD: 33854
DESCRICAO: Frescor da Montanha - Aroma Laranja - 1 Litro
CATEGORIA: Mate

COD: 89254
DESCRICAO: Frescor da Montanha - Aroma Uva - 1 Litro
CATEGORIA: Águas   */

EXECUTE INCLUIR_PRODUTO('33854', 'Frescor da Montanha - Aroma Laranja - 1 Litro', 'Mate');
EXECUTE INCLUIR_PRODUTO('89245', 'Frescor da Montanha - Aroma Uva - 1 Litro', 'Águas');


-- b) Alterando a categoria do produto 33854 para Águas.
EXECUTE ALTERAR_CATEGORIA_PRODUTO('33854', 'Águas');

-- c) Excluindo o produto 89254.
EXECUTE EXCLUIR_PRODUTO('89254');

/*  Construa uma função com o nome RETORNA_CATEGORIA que, passando o 
código do produto, teremos o retorno da categoria.    */

CREATE OR REPLACE FUNCTION RETORNAR_CATEGORIA
(p_COD IN PRODUTO_EXERCICIO.COD%type)
RETURN PRODUTO_EXERCICIO.CATEGORIA%type
IS
    v_CATEGORIA PRODUTO_EXERCICIO.CATEGORIA%type;
BEGIN
    SELECT CATEGORIA INTO v_CATEGORIA FROM PRODUTO_EXERCICIO WHERE COD = p_COD;
    RETURN v_CATEGORIA;
END;

/* Temos a tabela PRODUTO_VENDA_EXERCICIO,que ainda não teve
dados incluídos nela.

Faça uma procedure, chamada INCLUINDO_DADOS_VENDA, para incluir linhas 
nesta tabela. Os parâmetros, por enquanto, serão todos os campos da tabela.

Teste a procedure com o seguinte dado:

ID: 1
COD_PRODUTO: 41232
DATA: 1/1/2022
QUANTIDADE: 100
PRECO: 10
VALOR: 1000
IMPOSTO: 10     */

CREATE OR REPLACE PROCEDURE INCLUINDO_DADOS_VENDA 
(
p_ID PRODUTO_VENDA_EX.ID%type,
p_COD_PRODUTO PRODUTO_VENDA_EX.COD_PRODUTO%type,
p_DATA PRODUTO_VENDA_EX.DATA%type,
p_QUANTIDADE PRODUTO_VENDA_EX.QUANTIDADE%type,
p_PRECO PRODUTO_VENDA_EX.PRECO%type,
p_VALOR PRODUTO_VENDA_EX.VALOR_TOTAL%type,
p_PERCENTUAL PRODUTO_VENDA_EX.PERCENTUAL_PREVISTO%type
)
IS
BEGIN
   INSERT INTO PRODUTO_VENDA_EX 
   (ID, COD_PRODUTO, DATA, QUANTIDADE, PRECO, VALOR_TOTAL, PERCENTUAL_IMPOSTO) 
   VALUES 
   (p_ID, p_COD_PRODUTO, p_DATA, p_QUANTIDADE, p_PRECO, p_VALOR, p_PERCENTUAL);
   COMMIT;
END;

EXECUTE INCLUINDO_DADOS_VENDA('1', '41232', TO_DATE('01/01/2022','DD/MM/YYYY')
,100, 10, 1000, 10);

--------------------------------------------------------------------------------

/*  O imposto está diretamente associado à categoria do produto, 
usando a seguinte tabela:

Sucos = 10%
Águas = 20%
Mate = 15%

Faça uma função, chamada RETORNA_IMPOSTO que, dado o ID do produto,
temos o retorno do imposto.     

Dica: Lembre-se que, baseado no ID, buscamos a categoria e depois com 
a categoria, obtemos o imposto. Já temos, inclusive, uma função que, 
dado o ID, temos a categoria. Ela foi criada em atividades anteriores. 
Use-a dentro desta nova função.      */

CREATE OR REPLACE FUNCTION RETORNA_IMPOSTO 
(p_COD_PRODUTO produto_venda_exercicio.cod_produto%type)
RETURN produto_venda_exercicio.percentual_imposto%type
IS
   v_CATEGORIA produto_exercicio.categoria%type;
   v_IMPOSTO produto_venda_exercicio.percentual_imposto%type;
BEGIN
    v_CATEGORIA := retorna_categoria(p_COD_PRODUTO);
    IF TRIM(v_CATEGORIA) = 'Sucos de Frutas' THEN
        v_IMPOSTO := 10;
    ELSIF  TRIM(v_CATEGORIA) = 'Águas' THEN
        v_IMPOSTO := 20;
    ELSIF  TRIM(v_CATEGORIA) = 'Mate' THEN
        v_IMPOSTO := 15;
    END IF;
    RETURN v_IMPOSTO;
END;

----------------------------------------------------------------------------

--Fizemos a seguinte procedure para incluir uma venda:

CREATE OR REPLACE PROCEDURE INCLUINDO_DADOS_VENDA 
(
p_ID produto_venda_exercicio.id%type,
p_COD_PRODUTO produto_venda_exercicio.cod_produto%type,
p_DATA produto_venda_exercicio.data%type,
p_QUANTIDADE produto_venda_exercicio.quantidade%type,
p_PRECO produto_venda_exercicio.preco%type,
p_VALOR produto_venda_exercicio.valor_total%type,
p_PERCENTUAL produto_venda_exercicio.percentual_imposto%type
)
IS
BEGIN
   INSERT INTO PRODUTO_VENDA_EXERCICIO 
   (id, cod_produto, data, quantidade, preco, valor_total, percentual_imposto) 
   VALUES 
   (p_ID, p_COD_PRODUTO, p_DATA, p_QUANTIDADE, p_PRECO, p_VALOR, p_PERCENTUAL);
    COMMIT;
END; 

/*  Modifique a rotina acima de tal maneira que:

1) O valor da venda será a quantidade * preco.

2) O percentual do imposto será obtido da função RETORNA_IMPOSTO, 
implementada na atividade anterior.

Depois inclua nova venda com apenas os seguintes dados:

ID: 2
COD_PRODUTO: 92347
DATA: 1/1/2022
QUANTIDADE: 200
PRECO: 25 */

CREATE OR REPLACE PROCEDURE INCLUINDO_DADOS_VENDA 
(
p_ID produto_venda_exercicio.id%type,
p_COD_PRODUTO produto_venda_exercicio.cod_produto%type,
p_DATA produto_venda_exercicio.data%type,
p_QUANTIDADE produto_venda_exercicio.quantidade%type,
p_PRECO produto_venda_exercicio.preco%type
)
IS
   v_VALOR produto_venda_exercicio.valor_total%type;
   v_PERCENTUAL produto_venda_exercicio.percentual_imposto%type;
BEGIN
   v_PERCENTUAL := retorna_imposto(p_COD_PRODUTO);
   v_VALOR := p_QUANTIDADE * p_PRECO;
   INSERT INTO PRODUTO_VENDA_EXERCICIO 
   (id, cod_produto, data, quantidade, preco, valor_total, percentual_imposto) 
   VALUES 
   (p_ID, p_COD_PRODUTO, p_DATA, p_QUANTIDADE, p_PRECO, v_VALOR, v_PERCENTUAL);
    COMMIT;
END; 

--E chamando a procedure:
EXECUTE INCLUINDO_DADOS_VENDA(2, '92347', TO_DATE('01/01/2022','DD/MM/YYYY'),200, 25);