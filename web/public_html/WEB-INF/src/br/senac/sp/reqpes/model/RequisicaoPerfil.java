package br.senac.sp.reqpes.model;

/**
* @author Thiago Lima COutinho
* @since 15/09/2008
*/


public class RequisicaoPerfil{

   private String tipoExperiencia;
   private String sexo;
   private String outrasCarateristica; //Competência e conhecimentos específicos
   private String descricaoFormacao;   //Escolaridade e experiência profissional desejável
   private String complementoEscolaridade; 
   private String comentarios;
   private int sqNivel;
   private int codRequisicao;
   private int faixaEtariaIni;
   private int faixaEtariaFim;
   private int experiencia;
   private int codArea;
   private int codFuncao;
   private int codNivelHierarquia;
   private String dscOportunidade;
   private String dscAtividadesCargo; 
   private String dscExperiencia;
   private String dscConhecimentos;
   private String listFuncao;

   public RequisicaoPerfil(){}

   public void setTipoExperiencia(String tipoExperiencia){
      this.tipoExperiencia = tipoExperiencia;
   }

   public void setSqNivel(int sqNivel){
      this.sqNivel = sqNivel;
   }

   public void setSexo(String sexo){
      this.sexo = sexo;
   }

   public void setCodRequisicao(int codRequisicao){
      this.codRequisicao = codRequisicao;
   }

   public void setOutrasCarateristica(String outrasCarateristica){
      this.outrasCarateristica = outrasCarateristica;
   }

   public void setFaixaEtariaIni(int faixaEtariaIni){
      this.faixaEtariaIni = faixaEtariaIni;
   }

   public void setFaixaEtariaFim(int faixaEtariaFim){
      this.faixaEtariaFim = faixaEtariaFim;
   }

   public void setExperiencia(int experiencia){
      this.experiencia = experiencia;
   }

   public void setDescricaoFormacao(String descricaoFormacao){
      this.descricaoFormacao = descricaoFormacao;
   }

   public void setComplementoEscolaridade(String complementoEscolaridade){
      this.complementoEscolaridade = complementoEscolaridade;
   }

   public void setComentarios(String comentarios){
      this.comentarios = comentarios;
   }

   public String getTipoExperiencia(){
      return (tipoExperiencia == null)?"":tipoExperiencia;
   }

   public String getSexo(){
      return (sexo == null)?"":sexo;
   }

   public String getOutrasCarateristica(){
      return (outrasCarateristica == null)?"":outrasCarateristica;
   }

   public String getDescricaoFormacao(){
      return (descricaoFormacao == null)?"":descricaoFormacao;
   }

   public String getComplementoEscolaridade(){
      return (complementoEscolaridade == null)?"":complementoEscolaridade;
   }

   public String getComentarios(){
      return (comentarios == null)?"":comentarios;
   }

   public int getSqNivel(){
      return sqNivel;
   }

   public int getCodRequisicao(){
      return codRequisicao;
   }

   public int getFaixaEtariaIni(){
      return faixaEtariaIni;
   }

   public int getFaixaEtariaFim(){
      return faixaEtariaFim;
   }

   public int getExperiencia(){
      return experiencia;
   }


  public void setCodArea(int codArea)
  {
    this.codArea = codArea;
  }


  public int getCodArea()
  {
    return codArea;
  }


  public void setCodFuncao(int codFuncao)
  {
    this.codFuncao = codFuncao;
  }


  public int getCodFuncao()
  {
    return codFuncao;
  }


  public void setCodNivelHierarquia(int codNivelHierarquia)
  {
    this.codNivelHierarquia = codNivelHierarquia;
  }


  public int getCodNivelHierarquia()
  {
    return codNivelHierarquia;
  }


  public void setDscOportunidade(String dscOportunidade)
  {
    this.dscOportunidade = dscOportunidade;
  }


  public String getDscOportunidade()
  {
    return (dscOportunidade==null)?"":dscOportunidade;
  }


  public void setDscAtividadesCargo(String dscAtividadesCargo)
  {
    this.dscAtividadesCargo = dscAtividadesCargo;
  }


  public String getDscAtividadesCargo()
  {
    return (dscAtividadesCargo==null)?"":dscAtividadesCargo;
  }


  public void setDscExperiencia(String dscExperiencia)
  {
    this.dscExperiencia = dscExperiencia;
  }


  public String getDscExperiencia()
  {
    return (dscExperiencia==null)?"":dscExperiencia;
  }

	public void setDscConhecimentos(String dscConhecimentos) {
		this.dscConhecimentos = dscConhecimentos;
	}
	
	public String getDscConhecimentos() {
		return (dscConhecimentos==null)?"":dscConhecimentos;
	}

	public void setListFuncao(String listFuncao) {
		this.listFuncao = listFuncao;
	}

	public String getListFuncao() {
		return listFuncao;
	}
}