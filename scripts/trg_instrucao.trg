CREATE OR REPLACE TRIGGER REQPES.TRG_INSTRUCAO
  BEFORE INSERT OR UPDATE OR DELETE ON instrucao
  FOR EACH ROW

DECLARE
  /********************************************/
  /* Data: 30/06/2011                         */
  /* Autor: Thiago Coutinho                   */
  /* Objetivo: Auditar a tabela INSTRUCAO     */
  /********************************************/

  V_LOG          VARCHAR2(4000);
  V_IND_OPERACAO VARCHAR2(1);
  V_USER         VARCHAR2(1000);
  V_APPS         VARCHAR2(1000);
  V_ATRIBUICAO   VARCHAR2(4000);

BEGIN

  --=========================================================
  -- VERIFICANDO OPERAÇÃO QUE ESTÁ SENDO REALIZADA
  --=========================================================
    IF (INSERTING) THEN
      --=========================================================
      -- INSERT
      --=========================================================
       V_IND_OPERACAO := 'I';
       V_LOG := 'COD_TAB_SALARIAL: ' || :NEW.COD_TAB_SALARIAL || CHR(10);
       V_LOG := V_LOG || 'COD_CARGO: ' || :NEW.COD_CARGO || CHR(10);
       V_LOG := V_LOG || 'COTA: ' || :NEW.COTA  || CHR(10);
       V_LOG := V_LOG || 'COD_AREA_SUBAREA: ' || :NEW.COD_AREA_SUBAREA || CHR(10);

    ELSIF (UPDATING) THEN
      --=========================================================
      -- UPDATE
      --=========================================================
       V_IND_OPERACAO := 'U';
       V_LOG := '';

       IF (:NEW.COD_TAB_SALARIAL <> :OLD.COD_TAB_SALARIAL) THEN
          V_LOG := V_LOG || 'COD_TAB_SALARIAL: ' || 'OLD:' || :OLD.COD_TAB_SALARIAL || ' NEW:' || :NEW.COD_TAB_SALARIAL || CHR(10);
       END IF;

       IF (:NEW.COD_CARGO <> :OLD.COD_CARGO) THEN
          V_LOG := V_LOG || 'COD_CARGO: ' || 'OLD:' || :OLD.COD_CARGO || ' NEW:' || :NEW.COD_CARGO || CHR(10);
       END IF;

       IF (:NEW.COTA <> :OLD.COTA) THEN
          V_LOG := V_LOG || 'COTA: ' || 'OLD:' || :OLD.COTA || ' NEW:' || :NEW.COTA || CHR(10);
       END IF;

       IF (NVL(:NEW.COD_AREA_SUBAREA,'NULL') <> NVL(:OLD.COD_AREA_SUBAREA,'NULL')) THEN
          V_LOG := V_LOG || 'COD_AREA_SUBAREA: ' || 'OLD:' || :OLD.COD_AREA_SUBAREA || ' NEW:' || :NEW.COD_AREA_SUBAREA || CHR(10);
       END IF;

       SELECT SUBSTR(UNIDADES, (INSTR(UNIDADES, '#')+1), LENGTH(UNIDADES))
       INTO V_ATRIBUICAO
       FROM   (SELECT F_GET_LST_INSTRUCAO_ATRIBUICAO(:OLD.COD_INSTRUCAO) AS UNIDADES
               FROM   DUAL);

       V_LOG := V_LOG || 'INSTRUCAO_ATRIBUICAO: ' || V_ATRIBUICAO;

    ELSE
      --=========================================================
      -- DELETE
      --=========================================================
       V_IND_OPERACAO := 'D';
       V_LOG := 'REGISTRO EXCLUÍDO' || CHR(10);

    END IF;

  --=========================================================
  -- USUÁRIO DA SESSÃO
  --=========================================================
    BEGIN
      SELECT UPPER(PROGRAM)
            ,UPPER(OSUSER)
      INTO   V_APPS
            ,V_USER
      FROM   V$SESSION
      WHERE  AUDSID = USERENV('SESSIONID');

      -- Operação realizada pelo Sistema
      IF (V_APPS = 'JDBC THIN CLIENT' OR V_USER = 'ORACLE') THEN
          -- Busca o funcionário pelo ID salvo na tabela local
          BEGIN
            IF (V_IND_OPERACAO = 'D') THEN
              SELECT T.USUARIO || '-' || F.NOME
                    ,T.ATRIBUICAO
              INTO   V_USER
                    ,V_ATRIBUICAO
              FROM   AUDIT_TMP T
                    ,FUNCIONARIOS F
              WHERE  F.ID = T.USUARIO
              AND    T.SESSION_ID = USERENV('SESSIONID');
            ELSE
              SELECT F.ID || '-' || F.NOME
              INTO   V_USER
              FROM   FUNCIONARIOS F
              WHERE  F.ID = DECODE(V_IND_OPERACAO, 'I', :NEW.USER_CADASTRO, :NEW.USER_ALTERACAO);
            END IF;

          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              V_USER := 'FUNCIONÁRIO NÃO ENCONTRADO - ID: ' || V_USER;
            WHEN OTHERS THEN
              V_USER := 'ERRO AO PESQUISAR O FUNCIONARIO - ID: ' || V_USER;
          END;

      ELSE
        -- Salva o usuário de rede
        SELECT PROGRAM || ' ( '||OSUSER||' ) ' || MACHINE
        INTO   V_USER
        FROM   V$SESSION
        WHERE  AUDSID = USERENV('SESSIONID');
      END IF;

    EXCEPTION
      WHEN OTHERS THEN
        V_USER := 'ORACLE';
    END;

  --=========================================================
  -- GRAVANDO REGISTRO NA AUDITORIA
  --=========================================================
    IF (LENGTH(V_LOG) > 0) THEN
      INSERT INTO AUDIT_INSTRUCAO
        (COD_INSTRUCAO
        ,IND_OPERACAO
        ,LOG
        ,USR_OPERACAO)
      VALUES
        (DECODE(V_IND_OPERACAO,'I', :NEW.COD_INSTRUCAO, :OLD.COD_INSTRUCAO)
        ,V_IND_OPERACAO
        ,DECODE(V_IND_OPERACAO,'D', V_LOG || V_ATRIBUICAO, V_LOG)
        ,V_USER);
    END IF;
END;
/

