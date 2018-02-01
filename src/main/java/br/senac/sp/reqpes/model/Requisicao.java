package br.senac.sp.reqpes.model;

import java.sql.Date;

/**
 * @author Thiago Lima Coutinho
 * @since 15/09/2008
 */

public class Requisicao {

	private int codRequisicao;
	private String codUnidade;
	private String codMA;
	private String codSMA;
	private int numUsuarioSq;
	private int codCargo;
	private int cotaCargo;
	private String indTipoContratacao;
	private String nomSuperior;
	private String telUnidade;
	private double jornadaTrabalho;
	private String indLocalTrabalho;
	private String codRPPara;
	private String comentarios;
	private String indSupervisao;
	private int numFuncionariosSupervisao;
	private String dscTarefasDesempenhadas;
	private String indViagem;
	private String salario;
	private String outroLocal;
	private String nomIndicado;
	private Date datInicioContratacao;
	private Date datFimContratacao;
	private int codArea;
	private String codMotivoSolicitacao;
	private String indTipoIndicacao;
	private String dscMotivoSolicitacao; // CAMPO Justificativa
	private int codClassificacaoFuncional;
	private int idIndicado;
	private int idSubstitutoHist;
	private Date datTransferencia;
	private String indCartaConvite;
	private String indExCartaConvite;
	private String indExFuncionario;
	private long idCodeCombination;
	private String indTipoRequisicao;
	private int indStatus;
	private String segmento1;
	private String segmento2;
	private String segmento3;
	private String segmento4;
	private String segmento5;
	private String segmento6;
	private String segmento7;
	private String dscUnidade;
	private String dscCargo;
	private String datRequisicao;
	private String emailCriadorRP;
	private String codUODestino;
	private int nivelWorkflow;
	private int codRecrutamento;
	private String dscRecrutamento;
	private String indCaraterExcecao;
	private String versaoSistema;
	private String indCargoRegime;
	private int Tipoedicao;

	public Requisicao() {
	}

	public void setCodRequisicao(int codRequisicao) {
		this.codRequisicao = codRequisicao;
	}

	public int getCodRequisicao() {
		return codRequisicao;
	}

	public void setCodUnidade(String codUnidade) {
		this.codUnidade = codUnidade;
	}

	public String getCodUnidade() {
		return (codUnidade == null) ? "" : codUnidade;
	}

	public void setCodMA(String codMA) {
		this.codMA = codMA;
	}

	public String getCodMA() {
		return (codMA == null) ? "" : codMA;
	}

	public void setCodSMA(String codSMA) {
		this.codSMA = codSMA;
	}

	public String getCodSMA() {
		return (codSMA == null) ? "" : codSMA;
	}

	public void setNumUsuarioSq(int numUsuarioSq) {
		this.numUsuarioSq = numUsuarioSq;
	}

	public int getNumUsuarioSq() {
		return numUsuarioSq;
	}

	public void setCodCargo(int codCargo) {
		this.codCargo = codCargo;
	}

	public int getCodCargo() {
		return codCargo;
	}

	public void setCotaCargo(int cotaCargo) {
		this.cotaCargo = cotaCargo;
	}

	public int getCotaCargo() {
		return cotaCargo;
	}

	public void setIndTipoContratacao(String indTipoContratacao) {
		this.indTipoContratacao = indTipoContratacao;
	}

	public String getIndTipoContratacao() {
		return (indTipoContratacao == null) ? "" : indTipoContratacao;
	}

	public void setNomSuperior(String nomSuperior) {
		this.nomSuperior = nomSuperior;
	}

	public String getNomSuperior() {
		return (nomSuperior == null) ? "" : nomSuperior;
	}

	public void setTelUnidade(String telUnidade) {
		this.telUnidade = telUnidade;
	}

	public String getTelUnidade() {
		return (telUnidade == null) ? "" : telUnidade;
	}

	public void setJornadaTrabalho(double jornadaTrabalho) {
		this.jornadaTrabalho = jornadaTrabalho;
	}

	public double getJornadaTrabalho() {
		return jornadaTrabalho;
	}

	public void setIndLocalTrabalho(String indLocalTrabalho) {
		this.indLocalTrabalho = indLocalTrabalho;
	}

	public String getIndLocalTrabalho() {
		return (indLocalTrabalho == null) ? "" : indLocalTrabalho;
	}

	public void setCodRPPara(String codRPPara) {
		this.codRPPara = codRPPara;
	}

	public String getCodRPPara() {
		return (codRPPara == null) ? "" : codRPPara;
	}

	public void setComentarios(String comentarios) {
		this.comentarios = comentarios;
	}

	public String getComentarios() {
		return (comentarios == null) ? "" : comentarios;
	}

	public void setIndSupervisao(String indSupervisao) {
		this.indSupervisao = indSupervisao;
	}

	public String getIndSupervisao() {
		return (indSupervisao == null) ? "" : indSupervisao;
	}

	public void setNumFuncionariosSupervisao(int numFuncionariosSupervisao) {
		this.numFuncionariosSupervisao = numFuncionariosSupervisao;
	}

	public int getNumFuncionariosSupervisao() {
		return numFuncionariosSupervisao;
	}

	public void setDscTarefasDesempenhadas(String dscTarefasDesempenhadas) {
		this.dscTarefasDesempenhadas = dscTarefasDesempenhadas;
	}

	public String getDscTarefasDesempenhadas() {
		return (dscTarefasDesempenhadas == null) ? "" : dscTarefasDesempenhadas;
	}

	public void setIndViagem(String indViagem) {
		this.indViagem = indViagem;
	}

	public String getIndViagem() {
		return (indViagem == null) ? "" : indViagem;
	}

	public void setSalario(String salario) {
		this.salario = salario;
	}

	public String getSalario() {
		return (salario == null) ? "" : salario;
	}

	public void setOutroLocal(String outroLocal) {
		this.outroLocal = outroLocal;
	}

	public String getOutroLocal() {
		return (outroLocal == null) ? "" : outroLocal;
	}

	public void setNomIndicado(String nomIndicado) {
		this.nomIndicado = nomIndicado;
	}

	public String getNomIndicado() {
		return (nomIndicado == null) ? "" : nomIndicado;
	}

	public void setDatInicioContratacao(Date datInicioContratacao) {
		this.datInicioContratacao = datInicioContratacao;
	}

	public Date getDatInicioContratacao() {
		return datInicioContratacao;
	}

	public void setDatFimContratacao(Date datFimContratacao) {
		this.datFimContratacao = datFimContratacao;
	}

	public Date getDatFimContratacao() {
		return datFimContratacao;
	}

	public void setCodArea(int codArea) {
		this.codArea = codArea;
	}

	public int getCodArea() {
		return codArea;
	}

	public void setTipoedicao(int Tipoedicao) {
		this.Tipoedicao = Tipoedicao;
	}

	public int getTipoedicao() {
		return Tipoedicao;
	}

	public void setCodMotivoSolicitacao(String codMotivoSolicitacao) {
		this.codMotivoSolicitacao = codMotivoSolicitacao;
	}

	public String getCodMotivoSolicitacao() {
		return (codMotivoSolicitacao == null) ? "" : codMotivoSolicitacao;
	}

	public void setIndTipoIndicacao(String indTipoIndicacao) {
		this.indTipoIndicacao = indTipoIndicacao;
	}

	public String getIndTipoIndicacao() {
		return (indTipoIndicacao == null) ? "" : indTipoIndicacao;
	}

	public void setDscMotivoSolicitacao(String dscMotivoSolicitacao) {
		this.dscMotivoSolicitacao = dscMotivoSolicitacao;
	}

	public String getDscMotivoSolicitacao() {
		return (dscMotivoSolicitacao == null) ? "" : dscMotivoSolicitacao;
	}

	public void setCodClassificacaoFuncional(int codClassificacaoFuncional) {
		this.codClassificacaoFuncional = codClassificacaoFuncional;
	}

	public int getCodClassificacaoFuncional() {
		return codClassificacaoFuncional;
	}

	public void setIdIndicado(int idIndicado) {
		this.idIndicado = idIndicado;
	}

	public int getIdIndicado() {
		return idIndicado;
	}

	public void setIdSubstitutoHist(int idSubstitutoHist) {
		this.idSubstitutoHist = idSubstitutoHist;
	}

	public int getIdSubstitutoHist() {
		return idSubstitutoHist;
	}

	public void setDatTransferencia(Date datTransferencia) {
		this.datTransferencia = datTransferencia;
	}

	public Date getDatTransferencia() {
		return datTransferencia;
	}

	public void setIndCartaConvite(String indCartaConvite) {
		if (indCartaConvite != null) {
			this.indCartaConvite = (indCartaConvite.equals("on") || indCartaConvite.equals("S")) ? "S" : "N";
		} else {
			this.indCartaConvite = "N";
		}
	}

	public String getIndCartaConvite() {
		return (indCartaConvite == null) ? "N" : indCartaConvite;
	}

	public void setIndExCartaConvite(String indExCartaConvite) {
		if (indExCartaConvite != null) {
			this.indExCartaConvite = (indExCartaConvite.equals("on") || indExCartaConvite.equals("S")) ? "S" : "N";
		} else {
			this.indExCartaConvite = "N";
		}
	}

	public String getIndExCartaConvite() {
		return (indExCartaConvite == null) ? "N" : indExCartaConvite;
	}

	public void setIndExFuncionario(String indExFuncionario) {
		if (indExFuncionario != null) {
			this.indExFuncionario = (indExFuncionario.equals("on") || indExFuncionario.equals("S")) ? "S" : "N";
		} else {
			this.indExFuncionario = "N";
		}
	}

	public String getIndExFuncionario() {
		return (indExFuncionario == null) ? "N" : indExFuncionario;

	}

	public void setIdCodeCombination(long idCodeCombination) {
		this.idCodeCombination = idCodeCombination;
	}

	public long getIdCodeCombination() {
		return idCodeCombination;
	}

	public void setIndTipoRequisicao(String indTipoRequisicao) {
		this.indTipoRequisicao = indTipoRequisicao;
	}

	public String getIndTipoRequisicao() {
		return (indTipoRequisicao == null) ? "" : indTipoRequisicao;
	}

	public void setIndStatus(int indStatus) {
		this.indStatus = indStatus;
	}

	public int getIndStatus() {
		return indStatus;
	}

	public void setSegmento1(String segmento1) {
		this.segmento1 = segmento1;
	}

	public String getSegmento1() {
		return (segmento1 == null) ? "" : segmento1;
	}

	public void setSegmento2(String segmento2) {
		this.segmento2 = segmento2;
	}

	public String getSegmento2() {
		return (segmento2 == null) ? "" : segmento2;
	}

	public void setSegmento3(String segmento3) {
		this.segmento3 = segmento3;
	}

	public String getSegmento3() {
		return (segmento3 == null) ? "" : segmento3;
	}

	public void setSegmento4(String segmento4) {
		this.segmento4 = segmento4;
	}

	public String getSegmento4() {
		return (segmento4 == null) ? "" : segmento4;
	}

	public void setSegmento5(String segmento5) {
		this.segmento5 = segmento5;
	}

	public String getSegmento5() {
		return (segmento5 == null) ? "" : segmento5;
	}

	public void setSegmento6(String segmento6) {
		this.segmento6 = segmento6;
	}

	public String getSegmento6() {
		return (segmento6 == null) ? "" : segmento6;
	}

	public void setSegmento7(String segmento7) {
		this.segmento7 = segmento7;
	}

	public String getSegmento7() {
		return (segmento7 == null) ? "" : segmento7;
	}

	public void setDscUnidade(String dscUnidade) {
		this.dscUnidade = dscUnidade;
	}

	public String getDscUnidade() {
		return (dscUnidade == null) ? "" : dscUnidade;
	}

	public void setDscCargo(String dscCargo) {
		this.dscCargo = dscCargo;
	}

	public String getDscCargo() {
		return (dscCargo == null) ? "" : dscCargo;
	}

	public void setDatRequisicao(String datRequisicao) {
		this.datRequisicao = datRequisicao;
	}

	public String getDatRequisicao() {
		return (datRequisicao == null) ? "" : datRequisicao;
	}

	public void setEmailCriadorRP(String emailCriadorRP) {
		this.emailCriadorRP = emailCriadorRP;
	}

	public String getEmailCriadorRP() {
		return emailCriadorRP;
	}

	public void setCodUODestino(String codUODestino) {
		this.codUODestino = codUODestino;
	}

	public String getCodUODestino() {
		return (codUODestino == null) ? "" : codUODestino;
	}

	public void setNivelWorkflow(int nivelWorkflow) {
		this.nivelWorkflow = nivelWorkflow;
	}

	public int getNivelWorkflow() {
		return nivelWorkflow;
	}

	public void setCodRecrutamento(int codRecrutamento) {
		this.codRecrutamento = codRecrutamento;
	}

	public int getCodRecrutamento() {
		return codRecrutamento;
	}

	public void setDscRecrutamento(String dscRecrutamento) {
		this.dscRecrutamento = dscRecrutamento;
	}

	public String getDscRecrutamento() {
		return (dscRecrutamento == null) ? "" : dscRecrutamento;
	}

	public void setIndCaraterExcecao(String indCaraterExcecao) {
		this.indCaraterExcecao = indCaraterExcecao;
	}

	public String getIndCaraterExcecao() {
		return (indCaraterExcecao == null) ? "N" : indCaraterExcecao;
	}

	public void setVersaoSistema(String versaoSistema) {
		this.versaoSistema = versaoSistema;
	}

	public String getVersaoSistema() {
		return versaoSistema;
	}

	public void setIndCargoRegime(String indCargoRegime) {
		this.indCargoRegime = indCargoRegime;
	}

	public String getIndCargoRegime() {
		return (indCargoRegime == null) ? "" : indCargoRegime;
	}

}