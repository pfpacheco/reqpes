package br.senac.sp.reqpes.util;

import br.senac.sp.Transacao;
import br.senac.sp.reqpes.Interface.InterfaceDataBase;

import java.util.HashMap;

import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.export.JRXlsExporter;
import net.sf.jasperreports.engine.export.JRXlsExporterParameter;

public class GerarRelatorioJasper  implements InterfaceDataBase{

  private String nomeArquivo;
  private String caminhoJasper;  
  private String caminhoOutput; 
  private HashMap parameters;
  private String tipoRelatorio;
  
  public final static String relatorioPDF="PDF";
  public final static String relatorioHTML="HTML";
  public final static String relatorioXLS="XLS";
  
  public GerarRelatorioJasper(){
  }
  
	public void gerar() throws Exception{		
  
    JasperPrint jasperPrint = null;		
    Transacao transacao = null;
    
    try {			
      transacao = new Transacao(DATA_BASE_NAME);
      jasperPrint = JasperFillManager.fillReport(caminhoJasper, parameters, transacao.getConexao());		
      
      if (tipoRelatorio.equals("PDF")){
        JasperExportManager.exportReportToPdfFile(jasperPrint, caminhoOutput + nomeArquivo);      
      }
      
      if (tipoRelatorio.equals("HTML")){
        JasperExportManager.exportReportToHtmlFile(jasperPrint, caminhoOutput + nomeArquivo);        
      }
      
      if (tipoRelatorio.equals("XLS")){
        JRXlsExporter exporter = new JRXlsExporter();
        exporter.setParameter(JRXlsExporterParameter.JASPER_PRINT, jasperPrint);
        exporter.setParameter(JRXlsExporterParameter.OUTPUT_FILE_NAME, caminhoOutput + nomeArquivo );
        exporter.setParameter(JRXlsExporterParameter.IS_DETECT_CELL_TYPE, Boolean.TRUE);
        exporter.setParameter(JRXlsExporterParameter.IS_ONE_PAGE_PER_SHEET, Boolean.FALSE);
        exporter.setParameter(JRXlsExporterParameter.IS_REMOVE_EMPTY_SPACE_BETWEEN_ROWS, Boolean.TRUE);
        exporter.setParameter(JRXlsExporterParameter.IS_WHITE_PAGE_BACKGROUND, Boolean.FALSE);
        exporter.exportReport();
      }
      
    }catch (JRException e) {
      System.out.println(e.getMessage());
      throw new Exception (e.getMessage());
    }finally{
      transacao.end();
    }
  }

  public void gerar(String dataBaseName) throws Exception{		
    this.gerar(dataBaseName, null);
  }

	public void gerar(String dataBaseName, String[] arrayDados) throws Exception{		
  
    JasperPrint jasperPrint = null;		
    Transacao transacao = null;
    
    try {			
      transacao = new Transacao(dataBaseName);
      jasperPrint = JasperFillManager.fillReport(caminhoJasper, parameters, transacao.getConexao());		
      
      if (tipoRelatorio.equals("PDF")){
        JasperExportManager.exportReportToPdfFile(jasperPrint, caminhoOutput + nomeArquivo);      
      }
      
      if (tipoRelatorio.equals("HTML")){
        JasperExportManager.exportReportToHtmlFile(jasperPrint, caminhoOutput + nomeArquivo);        
      }
      
      if (tipoRelatorio.equals("XLS")){
        JRXlsExporter exporter = new JRXlsExporter();
        exporter.setParameter(JRXlsExporterParameter.JASPER_PRINT, jasperPrint);
        exporter.setParameter(JRXlsExporterParameter.OUTPUT_FILE_NAME, caminhoOutput + nomeArquivo );
        exporter.setParameter(JRXlsExporterParameter.IS_DETECT_CELL_TYPE, Boolean.TRUE);
        exporter.setParameter(JRXlsExporterParameter.IS_ONE_PAGE_PER_SHEET, Boolean.FALSE);
        exporter.setParameter(JRXlsExporterParameter.IS_REMOVE_EMPTY_SPACE_BETWEEN_ROWS, Boolean.TRUE);
        exporter.setParameter(JRXlsExporterParameter.IS_WHITE_PAGE_BACKGROUND, Boolean.FALSE);
        exporter.exportReport();
      }
      
      if(tipoRelatorio.equals("CSV")){  
        if(arrayDados != null){
          for(int i=0; i<arrayDados.length; i++){
          Logger.setPathServidor(this.caminhoOutput);
          Logger.setFileName(nomeArquivo);          
          Logger.addLog(arrayDados[i]+"\n\n",(i==0)?false:true);
          }        
        }
      }      
      
    }catch (JRException e) {
      System.out.println(e.getMessage());
      throw new Exception (e.getMessage());
    }finally{
      transacao.end();
    }
  }

  public void setNomeArquivo(String nomeArquivo){
    this.nomeArquivo = nomeArquivo;
  }

  public String getNomeArquivo(){
    return nomeArquivo;
  }

  public void setCaminhoJasper(String caminhoJasper){
    this.caminhoJasper = caminhoJasper;
  }

  public String getCaminhoJasper(){
    return caminhoJasper;
  }

  public void setCaminhoOutput(String caminhoOutput){
    this.caminhoOutput = caminhoOutput;
  }

  public String getCaminhoOutput(){
    return caminhoOutput;
  }

  public void setParameters(HashMap parameters){
    this.parameters = parameters;
  }

  public HashMap getParameters(){
    return parameters;
  }

  public void setTipoRelatorio(String tipoRelatorio){
    this.tipoRelatorio = tipoRelatorio;
  }

  public String getTipoRelatorio(){
    return tipoRelatorio;
  } 
}