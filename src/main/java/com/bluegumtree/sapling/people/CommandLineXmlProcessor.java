package com.bluegumtree.sapling.people;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;

public class CommandLineXmlProcessor {

	private static String DEFAULT_PATH_TO_PROCESSOR = "/home/sheila/Software/Calabash/xmlcalabash-1.0.9-94/calabash.jar"; 
	
	private String pathToXmlProcessor;
	private Runtime runtime;
	private Boolean ready;
	private String errorMessage;
	private String response;
	
	public CommandLineXmlProcessor() {
		this(CommandLineXmlProcessor.DEFAULT_PATH_TO_PROCESSOR);
	}
	
	public CommandLineXmlProcessor(String processor) {
		
		this.pathToXmlProcessor = processor;
        this.runtime = Runtime.getRuntime();
        this.ready = true;
        this.errorMessage = null;
        this.response = null;
		
	}
	
	public Boolean isReady() {
		return this.ready;
	}
	
	public String getErrorMessage() {
		return this.errorMessage;
	}
	
	public String getResponse() {
		return this.response;
	}
    public void execute(String args) {
    	
    	this.ready = false;
    	this.errorMessage = null;
    	this.response = null;
    
    	String command = "java -jar " + this.pathToXmlProcessor + " -P he " + args;    	
    	
        try {            
        	           
            Process proc = runtime.exec(command);
            
            InputStream errorStream = proc.getErrorStream();
            InputStreamReader errorStreamReader = new InputStreamReader(errorStream);
            BufferedReader bufferedErrorStreamReader = new BufferedReader(errorStreamReader);
            
            InputStream outputStream = proc.getInputStream();
            InputStreamReader outputStreamReader = new InputStreamReader(outputStream);
            BufferedReader bufferedOutputStreamReader = new BufferedReader(outputStreamReader);
            
            String errorLine = null;
            
            this.errorMessage = "";
            while ((errorLine = bufferedErrorStreamReader.readLine()) != null) {
            	this.errorMessage = this.errorMessage + errorLine + "\n";
            }
            
            String resultLine = null;
            
            this.response = "";
            while ((resultLine = bufferedOutputStreamReader.readLine()) != null) {
            	this.response = this.response + resultLine + "\n";
            }
            	            	       
            int exitVal = proc.waitFor();
        
        } catch (Throwable t) {
            t.printStackTrace();
        }
        
        this.ready = true;
    }
	
}
