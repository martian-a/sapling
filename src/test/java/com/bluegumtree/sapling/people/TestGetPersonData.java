package com.bluegumtree.sapling.people;

import static org.custommonkey.xmlunit.XMLAssert.assertXMLEqual;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;

import org.apache.commons.io.FileUtils;
import org.junit.Test;


public class TestGetPersonData {

	@Test
	public void testGetPersonData() throws Exception {		
		
		String expected = FileUtils.readFileToString(new File(TestGetPersonData.class.getResource("/person_data.xml").getFile()), "UTF-8");
		
		RuntimeCommand runtime = new RuntimeCommand();
		runtime.execute("java -jar /home/sheila/Software/Calabash/xmlcalabash-1.0.9-94/calabash.jar -P he /home/sheila/Repositories/git/sapling/src/main/xproc/get_person_data.xpl");			
		
		while (!runtime.isReady()) {
			// wait
		}
		
		String result = runtime.getResponse();
		
		System.out.print(result);
		
		assertXMLEqual(expected, result);
		
	}

	
	public class RuntimeCommand {			
				
		private Boolean ready = false;
		private String errorMessage = null;
		private String response =  null;
		
		public Boolean isReady() {
			return this.ready;
		}
		
		public String getErrorMessage() {
			return this.errorMessage;
		}
		
		public String getResponse() {
			return this.response;
		}
	    public void execute(String command) {
	    	
	    	this.ready = false;
	    	this.errorMessage = null;
	    	this.response = null;
	    	
	        try {            
	        	
	            Runtime rt = Runtime.getRuntime();
	            Process proc = rt.exec(command);
	            
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
}
