package br.senac.sp.reqpes.util;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.text.SimpleDateFormat;
import java.util.Date;

public class Logger{

  /* gerar em PRINT ( System.out.println() ) ou FILE (gera em arquivo)*/
  private static String LOGON="FILE";
  /* usado para setar caminho relativo*/
  private static String FOLDERLOG="";
  /* nome do arquivo a ser gerado*/
  private static String FOLDERLOGFILENAME="LOG";
  /* caso necessário escrever o logo em um arquivo temporario*/  
  private static String FOLDERLOGFILENAMETEMPORARIO="";
  /*caminho real do log*/  
  private static String FULLFOLDERLOG="";
  /*adiciona data no inicio no nome do arquivo*/  
  private static Boolean ADDDATEFILENAME=Boolean.FALSE;
    
  public Logger(String[] args){
  }

  public static void setPathServidor(String path){ 
   FULLFOLDERLOG=path;
  } 

  public static void setFolder (String folder){
    File appPath = new File(FULLFOLDERLOG+"/"+folder);
    if (appPath.isDirectory()==false){
      appPath.mkdir();
    }
    FOLDERLOG = folder;
  }

  public static void setTIPO (String tipo){ 
   LOGON=tipo;
  }  

  public static void addDataFileName (){ 
   ADDDATEFILENAME=Boolean.TRUE;
  }
  
  public static void setFileName (String filename){ 
   FOLDERLOGFILENAMETEMPORARIO = filename;
  }
  
  public static void addLog( String log, boolean sobrescrever ){

    //SimpleDateFormat df = new SimpleDateFormat( "dd/MM/yyyy H:mm:ss" );
    SimpleDateFormat dtArquivo = new SimpleDateFormat( "yyyyMMdd" );

    String logEscrever = log;
    String nomeArquivo = "";

    if (!FOLDERLOG.equals("")){
      nomeArquivo+=FOLDERLOG+"/";
      FOLDERLOG="";
    }
    
    if (ADDDATEFILENAME == Boolean.TRUE){
      nomeArquivo+=dtArquivo.format( new Date() );
      ADDDATEFILENAME= Boolean.FALSE;
    }
    
    if (!FOLDERLOGFILENAMETEMPORARIO.equals("")){
      nomeArquivo += FOLDERLOGFILENAMETEMPORARIO;
      FOLDERLOGFILENAMETEMPORARIO="";      
    }else{
      nomeArquivo += FOLDERLOGFILENAME;
    }
    
    if( LOGON.equals("FILE") ){
      try{
        FileWriter f = null;
        f = new FileWriter(FULLFOLDERLOG+ "\\"+ nomeArquivo, sobrescrever);
        f.write( logEscrever );
        f.close();
      }catch( IOException e ){ 
        System.out.println( e.getMessage() );
      }
    }

    if( LOGON.equals("PRINT") ){
      System.out.println( logEscrever  );
    }
  }

  public static void addLog( String Log, Exception excep ){
    StringWriter traceWriter = new StringWriter();
    PrintWriter printWriter = new PrintWriter(traceWriter, false);
    excep.printStackTrace(printWriter);
    printWriter.close();
    addLog(Log+" => "+traceWriter.getBuffer().toString(),true);
  } 
}