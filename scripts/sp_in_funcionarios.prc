CREATE OR REPLACE PROCEDURE REQPES.SP_IN_FUNCIONARIOS(P_IN_NOME                      IN FUNCIONARIOS.NOME%TYPE
                                              ,P_IN_ENDERECO                  IN FUNCIONARIOS.ENDERECO%TYPE
                                              ,P_IN_NRO_END                   IN FUNCIONARIOS.NRO_END%TYPE
                                              ,P_IN_COMPLEMENTO_END           IN FUNCIONARIOS.COMPLEMENTO_END%TYPE
                                              ,P_IN_BAIRRO                    IN FUNCIONARIOS.BAIRRO%TYPE
                                              ,P_IN_CIDADE                    IN FUNCIONARIOS.CIDADE%TYPE
                                              ,P_IN_ESTADO                    IN FUNCIONARIOS.ESTADO%TYPE
                                              ,P_IN_CEP                       IN FUNCIONARIOS.CEP%TYPE
                                              ,P_IN_CODIGO_DDD                IN FUNCIONARIOS.CODIGO_DDD%TYPE
                                              ,P_IN_TELEFONE                  IN FUNCIONARIOS.TELEFONE%TYPE
                                              ,P_IN_RAMAL                     IN FUNCIONARIOS.RAMAL%TYPE
                                              ,P_IN_ESTADO_CIVIL              IN FUNCIONARIOS.ESTADO_CIVIL%TYPE
                                              ,P_IN_SEXO                      IN FUNCIONARIOS.SEXO%TYPE
                                              -- Nascimento
                                              ,P_IN_DATA_NASCIMENTO           IN FUNCIONARIOS.DATA_NASCIMENTO%TYPE
                                              ,P_IN_PAIS_NASCIMENTO           IN FUNCIONARIOS.PAIS_NASCIMENTO%TYPE
                                              ,P_IN_NACIONALIDADE             IN FUNCIONARIOS.NACIONALIDADE%TYPE
                                              ,P_IN_CIDADE_NASCIMENTO         IN FUNCIONARIOS.CIDADE_NASCIMENTO%TYPE
                                              ,P_IN_ESTADO_NASCIMENTO         IN FUNCIONARIOS.ESTADO_NASCIMENTO%TYPE
                                              ,P_IN_NOME_PAI                  IN FUNCIONARIOS.NOME_PAI%TYPE
                                              ,P_IN_NOME_MAE                  IN FUNCIONARIOS.NOME_MAE%TYPE
                                              ,P_IN_NACIONALIDADE_PAI         IN FUNCIONARIOS.NACIONALIDADE_PAI%TYPE
                                              ,P_IN_NACIONALIDADE_MAE         IN FUNCIONARIOS.NACIONALIDADE_MAE%TYPE
                                              -- Estrangeiro
                                              ,P_IN_NATURALIZADO              IN FUNCIONARIOS.NATURALIZADO%TYPE
                                              ,P_IN_DATA_CHEGADA_PAIS         IN FUNCIONARIOS.DATA_CHEGADA_PAIS%TYPE
                                              ,P_IN_NRO_NRE                   IN FUNCIONARIOS.NRO_CARTEIRA_MODELO_19%TYPE
                                              ,P_IN_TIPO_VISTO_ESTRANGEIRO    IN FUNCIONARIOS.TIPO_VISTO_ESTRANGEIRO%TYPE
                                              -- Carteira profissional
                                              ,P_IN_CART_PROFISSIONAL_NRO     IN FUNCIONARIOS.CART_PROFISSIONAL_NRO%TYPE
                                              ,P_IN_CART_PROFISSIONAL_SERIE   IN FUNCIONARIOS.CART_PROFISSIONAL_SERIE%TYPE
                                              ,P_IN_CART_PROFISSIONAL_LETRA   IN FUNCIONARIOS.CART_PROFISSIONAL_LETRA%TYPE
                                              ,P_IN_CART_PROFISSIONAL_EST_EM  IN FUNCIONARIOS.CART_PROFISSIONAL_EST_EMISSOR%TYPE
                                              ,P_IN_CART_PROFISSIONAL_DT_EXPE IN FUNCIONARIOS.CART_PROFISSIONAL_DATA_EXPED%TYPE
                                              ,P_IN_CART_PROFISSIONAL_DT_VALI IN FUNCIONARIOS.CART_PROFISSIONAL_DATA_VALID%TYPE
                                              -- PIS / PASEP
                                              ,P_IN_PIS_NRO                   IN FUNCIONARIOS.PIS_NRO%TYPE
                                              ,P_IN_PIS_PASEP_DATA_EXPED      IN FUNCIONARIOS.PIS_PASEP_DATA_EXPED%TYPE
                                              ,P_IN_TIPO_PROG_INTEGRACAO      IN FUNCIONARIOS.TIPO_PROG_INTEGRACAO%TYPE
                                              -- Reservista
                                              ,P_IN_CERT_RESERVISTA_NRO       IN FUNCIONARIOS.CERT_RESERVISTA_NRO%TYPE
                                              ,P_IN_CERT_RESERVISTA_COMPLEM   IN FUNCIONARIOS.COMPLEMENTO_CERT_RESERVISTA%TYPE
                                              -- RG
                                              ,P_IN_RG_NRO                    IN FUNCIONARIOS.RG_NRO%TYPE
                                              ,P_IN_RG_COMPLEMENTO            IN FUNCIONARIOS.RG_COMPLEMENTO%TYPE
                                              ,P_IN_RG_ORGAO_EMISSOR          IN FUNCIONARIOS.RG_ORGAO_EMISSOR%TYPE
                                              ,P_IN_RG_ESTADO_EMISSOR         IN FUNCIONARIOS.RG_ESTADO_EMISSOR%TYPE
                                              ,P_IN_RG_DATA_EXPEDICAO         IN FUNCIONARIOS.RG_DATA_EXPEDICAO%TYPE
                                              -- CPF
                                              ,P_IN_CIC_NRO                   IN FUNCIONARIOS.CIC_NRO%TYPE
                                              ,P_IN_COMPLEMENTO_CIC_NRO       IN FUNCIONARIOS.COMPLEMENTO_CIC_NRO%TYPE
                                              -- Título de eleitor
                                              ,P_IN_TITULO_ELEITOR_NRO        IN FUNCIONARIOS.TITULO_ELEITOR_NRO%TYPE
                                              ,P_IN_TITULO_ELEITOR_ZONA       IN FUNCIONARIOS.TITULO_ELEITOR_ZONA%TYPE
                                              ,P_IN_TITULO_ELEITOR_SECAO      IN FUNCIONARIOS.TITULO_ELEITOR_SECAO%TYPE
                                              -- Carteira de habilitação
                                              ,P_IN_CART_HABILITACAO_NRO      IN FUNCIONARIOS.CART_HABILITACAO_NRO%TYPE
                                              ,P_IN_CART_HABILITACAO_CATEG    IN FUNCIONARIOS.CART_HABILITACAO_CATEGORIA%TYPE
                                              -- Formação acadêmica
                                              ,P_IN_GRAU_ESCOLARIDADE         IN FUNCIONARIOS.GRAU_ESCOLARIDADE%TYPE
                                              ,P_IN_ORGAO_CLASSE              IN FUNCIONARIOS.ORGAO_CLASSE%TYPE
                                              ,P_IN_REGIAO_CLASSE             IN FUNCIONARIOS.REGIAO_CLASSE%TYPE
                                              ,P_IN_NRO_REGIAO_CLASSE         IN FUNCIONARIOS.NRO_REG_CLASSE%TYPE
                                              -- Dados complementares
                                              ,P_IN_REQUISICAO_SQ             IN REQUISICAO.REQUISICAO_SQ%TYPE
                                              ,P_IN_USUARIO_LOG               IN FUNCIONARIOS.ID%TYPE
                                              ,P_OUT_SUCESSO                  OUT NUMBER
                                              ,P_OUT_MSG                      OUT VARCHAR2
                                              ,P_IN_ID_FUNCIONARIO            IN FUNCIONARIOS.ID%TYPE
                                              ,P_IN_APOSENTADO                IN FUNCIONARIOS.APOSENTADO%TYPE) IS

  --========================================================================================--
  -- Data: 28/04/2011
  -- Autor: Thiago Lima Coutinho
  -- Descrição: Processo utilizado pelo sistema Banco de Talentos, com o objetivo de cadastrar
  --            o funcionário no RHEvolution e realizar a baixa da Requisição de Pessoal.
  --            Todos os dados do tipo "varchar" devem estar em maiúsculas e sem acentuação.
  --========================================================================================--
  V_REG_FUNCIONARIOS FUNCIONARIOS%ROWTYPE;
BEGIN
  -- Setando parâmetros
  V_REG_FUNCIONARIOS.ID                            := P_IN_ID_FUNCIONARIO;
  V_REG_FUNCIONARIOS.NOME                          := CORRIGE_TEXTO(P_IN_NOME);
  V_REG_FUNCIONARIOS.ENDERECO                      := CORRIGE_TEXTO(P_IN_ENDERECO);
  V_REG_FUNCIONARIOS.NRO_END                       := CORRIGE_TEXTO(P_IN_NRO_END);
  V_REG_FUNCIONARIOS.COMPLEMENTO_END               := CORRIGE_TEXTO(P_IN_COMPLEMENTO_END);
  V_REG_FUNCIONARIOS.BAIRRO                        := CORRIGE_TEXTO(P_IN_BAIRRO);
  V_REG_FUNCIONARIOS.CIDADE                        := CORRIGE_TEXTO(P_IN_CIDADE);
  V_REG_FUNCIONARIOS.ESTADO                        := P_IN_ESTADO; --FK
  V_REG_FUNCIONARIOS.CEP                           := P_IN_CEP;
  V_REG_FUNCIONARIOS.CODIGO_DDD                    := P_IN_CODIGO_DDD;
  V_REG_FUNCIONARIOS.TELEFONE                      := P_IN_TELEFONE;
  V_REG_FUNCIONARIOS.RAMAL                         := P_IN_RAMAL;
  V_REG_FUNCIONARIOS.ESTADO_CIVIL                  := P_IN_ESTADO_CIVIL; --FK
  V_REG_FUNCIONARIOS.SEXO                          := P_IN_SEXO;
  V_REG_FUNCIONARIOS.DATA_NASCIMENTO               := P_IN_DATA_NASCIMENTO;
  V_REG_FUNCIONARIOS.PAIS_NASCIMENTO               := P_IN_PAIS_NASCIMENTO; --FK
  V_REG_FUNCIONARIOS.NACIONALIDADE                 := P_IN_NACIONALIDADE; --FK
  V_REG_FUNCIONARIOS.CIDADE_NASCIMENTO             := CORRIGE_TEXTO(P_IN_CIDADE_NASCIMENTO);
  V_REG_FUNCIONARIOS.ESTADO_NASCIMENTO             := P_IN_ESTADO_NASCIMENTO; --FK
  V_REG_FUNCIONARIOS.NOME_PAI                      := CORRIGE_TEXTO(P_IN_NOME_PAI);
  V_REG_FUNCIONARIOS.NOME_MAE                      := CORRIGE_TEXTO(P_IN_NOME_MAE);
  V_REG_FUNCIONARIOS.NACIONALIDADE_PAI             := P_IN_NACIONALIDADE_PAI; --FK
  V_REG_FUNCIONARIOS.NACIONALIDADE_MAE             := P_IN_NACIONALIDADE_MAE; --FK
  V_REG_FUNCIONARIOS.NATURALIZADO                  := P_IN_NATURALIZADO;
  V_REG_FUNCIONARIOS.DATA_CHEGADA_PAIS             := P_IN_DATA_CHEGADA_PAIS;
  V_REG_FUNCIONARIOS.NRO_CARTEIRA_MODELO_19        := CORRIGE_TEXTO(P_IN_NRO_NRE);
  V_REG_FUNCIONARIOS.TIPO_VISTO_ESTRANGEIRO        := P_IN_TIPO_VISTO_ESTRANGEIRO;
  V_REG_FUNCIONARIOS.CART_PROFISSIONAL_NRO         := P_IN_CART_PROFISSIONAL_NRO;
  V_REG_FUNCIONARIOS.CART_PROFISSIONAL_SERIE       := P_IN_CART_PROFISSIONAL_SERIE;
  V_REG_FUNCIONARIOS.CART_PROFISSIONAL_LETRA       := CORRIGE_TEXTO(P_IN_CART_PROFISSIONAL_LETRA);
  V_REG_FUNCIONARIOS.CART_PROFISSIONAL_EST_EMISSOR := P_IN_CART_PROFISSIONAL_EST_EM; --FK
  V_REG_FUNCIONARIOS.CART_PROFISSIONAL_DATA_EXPED  := P_IN_CART_PROFISSIONAL_DT_EXPE;
  V_REG_FUNCIONARIOS.CART_PROFISSIONAL_DATA_VALID  := P_IN_CART_PROFISSIONAL_DT_VALI;
  V_REG_FUNCIONARIOS.PIS_NRO                       := P_IN_PIS_NRO;
  V_REG_FUNCIONARIOS.PIS_PASEP_DATA_EXPED          := P_IN_PIS_PASEP_DATA_EXPED;
  --CASO SEJA ENVIADO A OPÇÃO PRIMEIRO EMPREGO (4), INSERIR 1 
  V_REG_FUNCIONARIOS.TIPO_PROG_INTEGRACAO          := CASE WHEN P_IN_TIPO_PROG_INTEGRACAO = 4 THEN 1 ELSE P_IN_TIPO_PROG_INTEGRACAO END;
  --CASO SEJA PRIMEIRO EMPREGO (4) GRAVAR N NA COLUNA SEGUNDO_EMPREGO, CASO CONTRÁRIO GRAVAR S
  V_REG_FUNCIONARIOS.SEGUNDO_EMPREGO               := CASE WHEN P_IN_TIPO_PROG_INTEGRACAO = 4 THEN 'S' ELSE 'N' END;
  V_REG_FUNCIONARIOS.CERT_RESERVISTA_NRO           := CORRIGE_TEXTO(P_IN_CERT_RESERVISTA_NRO);
  V_REG_FUNCIONARIOS.COMPLEMENTO_CERT_RESERVISTA   := CORRIGE_TEXTO(P_IN_CERT_RESERVISTA_COMPLEM);
  V_REG_FUNCIONARIOS.RG_NRO                        := CORRIGE_TEXTO(P_IN_RG_NRO);
  V_REG_FUNCIONARIOS.RG_COMPLEMENTO                := CORRIGE_TEXTO(P_IN_RG_COMPLEMENTO);
  V_REG_FUNCIONARIOS.RG_ORGAO_EMISSOR              := CORRIGE_TEXTO(P_IN_RG_ORGAO_EMISSOR);
  V_REG_FUNCIONARIOS.RG_ESTADO_EMISSOR             := P_IN_RG_ESTADO_EMISSOR; --FK
  V_REG_FUNCIONARIOS.RG_DATA_EXPEDICAO             := P_IN_RG_DATA_EXPEDICAO;
  V_REG_FUNCIONARIOS.CIC_NRO                       := P_IN_CIC_NRO;
  V_REG_FUNCIONARIOS.COMPLEMENTO_CIC_NRO           := P_IN_COMPLEMENTO_CIC_NRO;
  V_REG_FUNCIONARIOS.TITULO_ELEITOR_NRO            := P_IN_TITULO_ELEITOR_NRO;
  V_REG_FUNCIONARIOS.TITULO_ELEITOR_ZONA           := P_IN_TITULO_ELEITOR_ZONA;
  V_REG_FUNCIONARIOS.TITULO_ELEITOR_SECAO          := P_IN_TITULO_ELEITOR_SECAO;
  V_REG_FUNCIONARIOS.CART_HABILITACAO_NRO          := P_IN_CART_HABILITACAO_NRO;
  V_REG_FUNCIONARIOS.CART_HABILITACAO_CATEGORIA    := CORRIGE_TEXTO(P_IN_CART_HABILITACAO_CATEG);
  V_REG_FUNCIONARIOS.GRAU_ESCOLARIDADE             := P_IN_GRAU_ESCOLARIDADE; --FK
  V_REG_FUNCIONARIOS.ORGAO_CLASSE                  := P_IN_ORGAO_CLASSE; --FK
  V_REG_FUNCIONARIOS.REGIAO_CLASSE                 := CORRIGE_TEXTO(P_IN_REGIAO_CLASSE);
  V_REG_FUNCIONARIOS.NRO_REG_CLASSE                := CORRIGE_TEXTO(P_IN_NRO_REGIAO_CLASSE);
  V_REG_FUNCIONARIOS.APOSENTADO                    := P_IN_APOSENTADO;

  -- Realizando chamada da interface para validação / inclusão
  INTEGRACAO_PKG.SP_INTEGRACAO(V_REG_FUNCIONARIOS,
                               P_IN_REQUISICAO_SQ,
                               P_IN_USUARIO_LOG,
                               P_OUT_SUCESSO,
                               P_OUT_MSG);

END SP_IN_FUNCIONARIOS;
/
grant execute, debug on REQPES.SP_IN_FUNCIONARIOS to AN$RHEV;


