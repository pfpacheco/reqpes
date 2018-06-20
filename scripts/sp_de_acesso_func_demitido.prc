CREATE OR REPLACE PROCEDURE REQPES.SP_DE_ACESSO_FUNC_DEMITIDO AS
-------------------------------------------------------------------------------------
-- PROCEDURE RESPONSAVEL POR REMOVER OS ACESSOS DOS USUÁRIOS DEMITIDOS
-- Processo executado todos os dias as 05:00hs AM, atraves do job 901
-- Author: Thiago Lima Coutinho
-- Date  : 23/09/2010
-------------------------------------------------------------------------------------

BEGIN
  --------------------------------------------------------
  -- Grupo de homologadores do NEC
  --------------------------------------------------------
  DELETE FROM GRUPO_NEC_USUARIOS T
  WHERE  EXISTS (SELECT 1
                 FROM   FUNCIONARIOS F
                 WHERE  F.ID = T.CHAPA
                 AND    F.ATIVO <> 'A');

  --------------------------------------------------------
  -- Grupo de usuarios que recebem e-mails apos a aprovacao final da RP
  --------------------------------------------------------
  DELETE FROM USUARIO_AVISO U
  WHERE  EXISTS (SELECT 1
                 FROM   FUNCIONARIOS F
                 WHERE  F.ID = U.CHAPA
                 AND    F.ATIVO <> 'A');

  -------
  COMMIT;
  -------
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;

END SP_DE_ACESSO_FUNC_DEMITIDO;
/
grant execute, debug on REQPES.SP_DE_ACESSO_FUNC_DEMITIDO to AN$RHEV;


