CREATE OR REPLACE FUNCTION REQPES.SP_DML_REQUISICAO_TRATAMENTO(COMANDO_SQL IN NVARCHAR2) RETURN NVARCHAR2 IS
    RETORNO    NVARCHAR2(30000);  
    v_cursor   SYS_REFCURSOR;  
    v_valor    nvarchar2(30000);
     p_query_string  VARCHAR2(100);
  BEGIN
   v_valor:='Vazio';
    p_query_string:=REPLACE(COMANDO_SQL,'"',CHR(39));
    OPEN v_cursor FOR p_query_string;
    LOOP
        FETCH v_cursor INTO v_valor;
        EXIT WHEN v_cursor%NOTFOUND;
    END LOOP;
    CLOSE v_cursor;

RETURN v_valor;
END SP_DML_REQUISICAO_TRATAMENTO;
/

