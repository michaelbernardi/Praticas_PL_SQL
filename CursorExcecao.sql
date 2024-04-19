SET SERVEROUTPUT ON;

CREATE TABLE SEGMERCADO
(
ID NUMBER(5)
,DESCRICAO VARCHAR2(100)
);

CREATE TABLE CLIENTE
(
ID NUMBER(5)
,RAZAO_SOCIAL VARCHAR2(100)
,CNPJ VARCHAR2(20)
,SEGMERCADO_ID NUMBER(5)
,DATA_INCLUSAO DATE
,FATURAMENTO_PREVISTO NUMBER(10,2)
,CATEGORIA VARCHAR2(20)
);

ALTER TABLE SEGMERCADO ADD CONSTRAINT SEGMERCACO_ID_PK
PRIMARY KEY (ID);

ALTER TABLE CLIENTE ADD CONSTRAINT CLIENTE_ID_PK
PRIMARY KEY (ID);

ALTER TABLE CLIENTE ADD CONSTRAINT CLIENTE_SEGMERCADO_ID
FOREIGN KEY (SEGMERCADO_ID) REFERENCES SEGMERCADO (ID);


CREATE TABLE PRODUTO_EXERCICIO
(
COD VARCHAR2(5)
,DESCRICAO VARCHAR2(100)
,CATEGORIA VARCHAR2(100)
);

CREATE TABLE PRODUTO_VENDA_EXERCICIO
(
ID NUMBER(5)
,COD_PRODUTO VARCHAR2(5)
,DATA DATE
,QUANTIDADE FLOAT
,PRECO FLOAT
,VALOR_TOTAL FLOAT
,PERCENTUAL_IMPOSTO FLOAT
);

ALTER TABLE PRODUTO_EXERCICIO ADD CONSTRAINT PRODUTO_EXERCICIO_COD_PK
PRIMARY KEY (COD);

ALTER TABLE PRODUTO_VENDA_EXERCICIO ADD CONSTRAINT PRODUTO_VENDA_EXERCICIO_ID_PK
PRIMARY KEY (ID);

ALTER TABLE PRODUTO_VENDA_EXERCICIO ADD CONSTRAINT PRODUTO_VENDA_EXERCICIO_PRODUTO_EXERCICIO_COD
FOREIGN KEY (COD_PRODUTO) REFERENCES PRODUTO_EXERCICIO (COD);

Insert into SEGMERCADO (ID,DESCRICAO) values ('3','ATACADISTA');
Insert into SEGMERCADO (ID,DESCRICAO) values ('1','VAREJISTA');
Insert into SEGMERCADO (ID,DESCRICAO) values ('2','INDUSTRIAL');
Insert into SEGMERCADO (ID,DESCRICAO) values ('4','FARMACEUTICOS');

Insert into CLIENTE (ID,RAZAO_SOCIAL,CNPJ,SEGMERCADO_ID,DATA_INCLUSAO,FATURAMENTO_PREVISTO,CATEGORIA) values ('3','SUPERMERCADO CARIOCA','22222222222','1',to_date('13/06/22','DD/MM/RR'),'30000','M�DIO');
Insert into CLIENTE (ID,RAZAO_SOCIAL,CNPJ,SEGMERCADO_ID,DATA_INCLUSAO,FATURAMENTO_PREVISTO,CATEGORIA) values ('1','SUPERMERCADOS CAMPEAO','1234567890','1',to_date('12/06/22','DD/MM/RR'),'90000','MEDIO GRANDE');
Insert into CLIENTE (ID,RAZAO_SOCIAL,CNPJ,SEGMERCADO_ID,DATA_INCLUSAO,FATURAMENTO_PREVISTO,CATEGORIA) values ('2','SUPERMERCADO DO VALE','11111111111','1',to_date('13/06/22','DD/MM/RR'),'90000','M�DIO GRANDE');

Insert into PRODUTO_EXERCICIO (COD,DESCRICAO,CATEGORIA) values ('41232','Sabor de Ver�o > Laranja > 1 Litro','Sucos de Frutas');
Insert into PRODUTO_EXERCICIO (COD,DESCRICAO,CATEGORIA) values ('32223','Sabor de Ver�o > Uva > 1 Litro','Sucos de Frutas');
Insert into PRODUTO_EXERCICIO (COD,DESCRICAO,CATEGORIA) values ('67120','Frescor da Montanha > Aroma Lim�o > 1 Litro','�guas');
Insert into PRODUTO_EXERCICIO (COD,DESCRICAO,CATEGORIA) values ('92347','Aroma do Campo > Mate > 1 Litro','Mate');
Insert into PRODUTO_EXERCICIO (COD,DESCRICAO,CATEGORIA) values ('33854','Frescor da Montanha > Aroma Laranja > 1 Litro','�guas');

Insert into PRODUTO_VENDA_EXERCICIO (ID,COD_PRODUTO,DATA,QUANTIDADE,PRECO,VALOR_TOTAL,PERCENTUAL_IMPOSTO) values ('1','41232',to_date('01/01/22','DD/MM/RR'),'100','10','1000','100');
Insert into PRODUTO_VENDA_EXERCICIO (ID,COD_PRODUTO,DATA,QUANTIDADE,PRECO,VALOR_TOTAL,PERCENTUAL_IMPOSTO) values ('2','92347',to_date('01/01/22','DD/MM/RR'),'200','25','5000','15');
-----------------------------------------------------------------------------------------------

create or replace FUNCTION categoria_cliente
(p_FATURAMENTO IN CLIENTE.FATURAMENTO_PREVISTO%type)
RETURN CLIENTE.CATEGORIA%type
IS
   v_CATEGORIA CLIENTE.CATEGORIA%type;
BEGIN
   IF p_FATURAMENTO <= 10000 THEN
     v_CATEGORIA := 'PEQUENO';
  ELSIF p_FATURAMENTO <= 50000 THEN
     v_CATEGORIA := 'M�DIO';
  ELSIF p_FATURAMENTO <= 100000 THEN
     v_CATEGORIA := 'M�DIO GRANDE';
  ELSE
     v_CATEGORIA := 'GRANDE';
  END IF;
  RETURN v_CATEGORIA;
END;

create or replace FUNCTION obter_descricao_segmercado
(p_ID IN SEGMERCADO.ID%type)
RETURN SEGMERCADO.DESCRICAO%type
IS
   v_DESCRICAO SEGMERCADO.DESCRICAO%type;
BEGIN
    SELECT DESCRICAO INTO v_DESCRICAO FROM SEGMERCADO WHERE ID = p_ID;
    RETURN v_DESCRICAO;
END;

create or replace FUNCTION RETORNA_CATEGORIA
(p_COD IN produto_exercicio.cod%type)
RETURN produto_exercicio.categoria%type
IS
   v_CATEGORIA produto_exercicio.categoria%type;
BEGIN
    SELECT CATEGORIA INTO v_CATEGORIA FROM PRODUTO_EXERCICIO WHERE COD = p_COD;
    RETURN v_CATEGORIA;
END;

create or replace FUNCTION RETORNA_IMPOSTO 
(p_COD_PRODUTO produto_venda_exercicio.cod_produto%type)
RETURN produto_venda_exercicio.percentual_imposto%type
IS
   v_CATEGORIA produto_exercicio.categoria%type;
   v_IMPOSTO produto_venda_exercicio.percentual_imposto%type;
BEGIN
    v_CATEGORIA := retorna_categoria(p_COD_PRODUTO);
    IF TRIM(v_CATEGORIA) = 'Sucos de Frutas' THEN
        v_IMPOSTO := 10;
    ELSIF  TRIM(v_CATEGORIA) = '�guas' THEN
        v_IMPOSTO := 20;
    ELSIF  TRIM(v_CATEGORIA) = 'Mate' THEN
        v_IMPOSTO := 15;
    END IF;
    RETURN v_IMPOSTO;
END;

create or replace PROCEDURE ALTERANDO_CATEGORIA_PRODUTO 
(p_COD produto_exercicio.cod%type
, p_CATEGORIA produto_exercicio.categoria%type)
IS
BEGIN
   UPDATE PRODUTO_EXERCICIO SET CATEGORIA = p_CATEGORIA WHERE COD = P_COD;
   COMMIT;
END;

create or replace PROCEDURE EXCLUINDO_PRODUTO  
(p_COD produto_exercicio.cod%type)
IS
BEGIN
   DELETE FROM PRODUTO_EXERCICIO WHERE COD = P_COD;
   COMMIT;
END;

create or replace PROCEDURE INCLUINDO_DADOS_VENDA 
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

create or replace PROCEDURE INCLUINDO_PRODUTO 
(p_COD produto_exercicio.cod%type
, p_DESCRICAO produto_exercicio.descricao%type
, p_CATEGORIA produto_exercicio.categoria%type)
IS
BEGIN
   INSERT INTO PRODUTO_EXERCICIO (COD, DESCRICAO, CATEGORIA) VALUES (p_COD, REPLACE(p_DESCRICAO,'-','>')
   , p_CATEGORIA);
   COMMIT;
END;

create or replace PROCEDURE incluir_cliente
(
p_ID CLIENTE.ID%type,
p_RAZAO CLIENTE.RAZAO_SOCIAL%type,
p_CNPJ CLIENTE.CNPJ%type,
p_SEGMERCADO CLIENTE.SEGMERCADO_ID%type,
p_FATURAMENTO CLIENTE.FATURAMENTO_PREVISTO%type
)
IS
  v_CATEGORIA CLIENTE.CATEGORIA%type;
BEGIN

   v_CATEGORIA := categoria_cliente(p_FATURAMENTO);

   INSERT INTO CLIENTE
   VALUES 
   (p_ID, p_RAZAO, p_CNPJ, p_SEGMERCADO, SYSDATE, p_FATURAMENTO, v_CATEGORIA);
   COMMIT;
END;

create or replace PROCEDURE incluir_segmercado
(p_ID IN SEGMERCADO.ID%type, p_DESCRICAO IN SEGMERCADO.DESCRICAO%type)
IS
BEGIN
   INSERT INTO SEGMERCADO (ID, DESCRICAO) VALUES (p_ID, UPPER(p_DESCRICAO));
   COMMIT;
END;

-------------------------------------------------------------------------------------------

--Formata��o do CNPJ
SELECT CNPJ FROM CLIENTE;

SELECT CNPJ, SUBSTR(CNPJ, 1, 3), SUBSTR(CNPJ, 4, 2), SUBSTR(CNPJ, 6) FROM CLIENTE;

-------------------------------------------------------------------------------------------
/*  O par�metro IN somente pode atribuir seu valor a outras vari�veis e o OUT s� pode receber valores de outras vari�veis. Qualquer outro caso deve ser associado a uma vari�vel declarada entre o IS e o BEGIN.  
*/
--Par�metro IN e OUT

CREATE OR REPLACE PROCEDURE FORMATA_CNPJ
(p_CNPJ IN cliente.cnpj%type, p_CNPJ_SAIDA OUT cliente.cnpj%type)
IS
BEGIN
    p_CNPJ_SAIDA := SUBSTR(p_CNPJ, 1, 3) || '/' || SUBSTR(p_CNPJ, 4, 2) || '-' || SUBSTR(p_CNPJ,6);
END;

--Teste
SET SERVEROUTPUT ON;
DECLARE
    v_CNPJ cliente.cnpj%type;
    v_CNPJ_SAIDA cliente.cnpj%type;
BEGIN
    v_CNPJ := �1234567890�;
    v_CNPJ_SAIDA := �1234567890�;
    dbms_output.put_line(v_CNPJ || �        � || v_CNPJ_SAIDA)
    FORMATA_CNPJ(v_CNPJ, v_CNPJ_SAIDA);
    dbms_output.put_line(v_CNPJ || �        � || v_CNPJ_SAIDA)
END;

-------------------------------------------------------------------------------
--TESTES
CREATE OR REPLACE PROCEDURE FORMATA_CNPJ
(p_CNPJ IN cliente.cnpj%type, p_CNPJ_SAIDA OUT cliente.cnpj%type)
IS
BEGIN
  p_CNPJ_SAIDA := SUBSTR(P_CNPJ, 1, 3) || '/' || SUBSTR(P_CNPJ, 4, 2) || '-' || SUBSTR(p_CNPJ, 6);
END;

SET SERVEROUTPUT ON;
DECLARE
  v_CNPJ cliente.cnpj%type;
  v_CNPJ_SAIDA cliente.cnpj%type;
BEGIN
  v_CNPJ := '1234567890';
  v_CNPJ_SAIDA := '1234567890';
  dbms_output.put_line(v_CNPJ || ' ' || v_CNPJ_SAIDA);
  FORMATA_CNPJ(v_CNPJ, v_CNPJ_SAIDA);
  dbms_output.put_line(v_CNPJ || ' ' || v_CNPJ_SAIDA);
END;

CREATE OR REPLACE PROCEDURE FORMATA_CNPJ
(p_CNPJ IN cliente.cnpj%type, p_CNPJ_SAIDA OUT cliente.cnpj%type)
IS
BEGIN
  p_CNPJ_SAIDA := SUBSTR(P_CNPJ, 1, 3) || '/' || SUBSTR(P_CNPJ, 4, 2) || '-' || SUBSTR(p_CNPJ, 6);
    p_CNPJ := '0000';
END;

CREATE OR REPLACE PROCEDURE FORMATA_CNPJ
(p_CNPJ IN cliente.cnpj%type, p_CNPJ_SAIDA OUT cliente.cnpj%type)
IS
    v_CNPJ cliente.cnpj%type;
BEGIN
  p_CNPJ_SAIDA := SUBSTR(P_CNPJ, 1, 3) || '/' || SUBSTR(P_CNPJ, 4, 2) || '-' || SUBSTR(p_CNPJ, 6);
    v_CNPJ := p_CNPJ;
    v_CNPJ := '0000';
END;

--TESTE 2

CREATE OR REPLACE PROCEDURE FORMATA_CNPJ_SIMPLES
(p_CNPJ_SAIDA OUT cliente.cnpj%type)
IS
BEGIN
  p_CNPJ_SAIDA := SUBSTR(p_CNPJ_SAIDA, 1, 3) || '/' || SUBSTR(p_CNPJ_SAIDA, 4, 2) || '-' || SUBSTR(p_CNPJ_SAIDA, 6);
END;


SET SERVEROUTPUT ON;
DECLARE
  v_CNPJ cliente.cnpj%type;
BEGIN
  v_CNPJ := '1234567890';
  dbms_output.put_line(v_CNPJ);
  FORMATA_CNPJ_SIMPLES(v_CNPJ);
  dbms_output.put_line(v_CNPJ);
END;


CREATE OR REPLACE PROCEDURE FORMATA_CNPJ
(p_CNPJ IN cliente.cnpj%type, p_CNPJ_SAIDA OUT cliente.cnpj%type)
IS
BEGIN
  p_CNPJ_SAIDA := SUBSTR(P_CNPJ, 1, 3) || '/' || SUBSTR(P_CNPJ, 4, 2) || '-' || SUBSTR(p_CNPJ, 6);
END;

-------------------------------------------------------------------------------------

--PARAMETRO IN OUT
--N�o usaremos a vari�vel nem como OUT e nem como IN, mas como IN OUT:
CREATE OR REPLACE PROCEDURE FORMATA_CNPJ_SIMPLES
(p_CNPJ_SAIDA IN OUT cliente.cnpj%type)
IS
BEGIN
  p_CNPJ_SAIDA := SUBSTR(p_CNPJ_SAIDA, 1, 3) || '/' || SUBSTR(p_CNPJ_SAIDA, 4, 2) || '-' || SUBSTR(p_CNPJ_SAIDA, 6);
END;


---------------------------------------------------------------------------------------
--Fun��o de formata��o do CNPJ com chamada para procedure "INCLUIR_CLIENTE"

CREATE OR REPLACE NONEDITIONABLE PROCEDURE incluir_cliente 
(
  p_ID CLIENTE.ID%type,
  p_RAZAO CLIENTE.RAZAO_SOCIAL%type,
  p_CNPJ CLIENTE.CNPJ%type,
  p_SEGMERCADO CLIENTE.SEGMERCADO_ID%type,
  p_FATURAMENTO CLIENTE.FATURAMENTO_PREVISTO%type
)
IS
  v_CATEGORIA CLIENTE.CATEGORIA%type;
  v_CNPJ CLIENTE.CNPJ%type;
BEGIN

    v_CATEGORIA := categoria_cliente(p_FATURAMENTO);
    FORMATA_CNPJ(p_CNPJ, v_CNPJ);
    INSERT INTO CLIENTE 
    VALUES 
    (p_ID, p_RAZAO, v_CNPJ, p_SEGMERCADO, SYNDATE, p_FATURAMENTO, v_CATEGORIA); 
    COMMIT;
END;

SELECT * FROM CLIENTE
EXECUTE INCLUIR_CLIENTE(4, 'SUPERMERCADO REI DA COLINA', '9876543210', 1, 50000);

--------------------------------------------------------------------------------
--Testes

EXECUTE INCLUIR_CLIENTE (5, 'MERCEARIA XYZ', '9992992929', 1, 10000);
EXECUTE INCLUIR_CLIENTE (5, 'MERCEARIA XYZ', '999288292999', 1, 10000);
EXECUTE INCLUIR_CLIENTE (6, 'FARMACIA ABC', '999277292999', 1, 10000);
EXECUTE INCLUIR_CLIENTE (7, 'MERCADINHO QWE', '999266292999', 1, 10000);
EXECUTE INCLUIR_CLIENTE (8, 'TAVERNA POI', '999244292999', 1, 10000);
EXECUTE INCLUIR_CLIENTE (9, 'BAR 222', '999233292999', 1, 10000);


CREATE OR REPLACE PROCEDURE ATUALIZAR_SEGMERCADO
(p_ID CLIENTE.ID%type, p_SEGMERCADO_ID CLIENTE.SEGMERCADO_ID%type)
IS
BEGIN
    UPDATE CLIENTE SET SEGMERCADO_ID = p_SEGMERCADO_ID WHERE ID = p_ID;
    COMMIT;
END;

ATUALIZAR_SEGMERCADO(1,3) 
EXECUTE ATUALIZAR_SEGMERCADO(1,3);
EXECUTE ATUALIZAR_SEGMERCADO(2,3);
EXECUTE ATUALIZAR_SEGMERCADO(3,3); 
EXECUTE ATUALIZAR_SEGMERCADO(4,3);

--------------------------------------------------------------------------------


