package com.bluegumtree.sapling.people;

import static org.custommonkey.xmlunit.XMLAssert.assertXMLEqual;
import static org.junit.Assert.*;

import java.io.File;

import org.apache.commons.io.FileUtils;
import org.custommonkey.xmlunit.XMLUnit;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.ExpectedException;

public class TestCommandLineXmlProcessor {

	@Rule
	public ExpectedException exception = ExpectedException.none();
	
	@Test
	public void testExecute_success() throws Exception {		
		
		String expected = FileUtils.readFileToString(new File(TestCommandLineXmlProcessor.class.getResource("/people_data.xml").getFile()), "UTF-8");
		
		CommandLineXmlProcessor runtime = new CommandLineXmlProcessor();
		
		runtime.execute("/home/sheila/Repositories/git/sapling/src/main/xproc/get_people_data.xpl");			
		
		XMLUnit.setIgnoreWhitespace(true);
		
		assertXMLEqual(expected, runtime.getResponse());
		
	}
	
	@Test
	public void testExecute_fail_noPipelineSpecified() throws Exception {		
			
		CommandLineXmlProcessor runtime = new CommandLineXmlProcessor();
		
		exception.expect(CommandLineXmlProcessorException.class);
		exception.expectMessage("Usage: com.xmlcalabash.drivers.Main [switches] [pipeline.xpl] [options]");
		
		runtime.execute("");						
		
	}
	
	@Test
	public void testExecute_fail_missingParameter_required() throws Exception {		
			
		CommandLineXmlProcessor runtime = new CommandLineXmlProcessor();
		
		exception.expect(CommandLineXmlProcessorException.class);
		exception.expectMessage("err:XS0018:No value provided for required option \"id\"");			
		
		String pathToSource = new File(TestPeople.class.getResource("/person_data.xml").getFile()).getAbsolutePath();	
				
		runtime.execute("--input source=" + pathToSource + " /home/sheila/Repositories/git/sapling/src/test/xproc/parameter_required_none.xpl");							
		
	}	

	@Test
	public void testExecute_input_source_select() throws Exception {		
			
		CommandLineXmlProcessor runtime = new CommandLineXmlProcessor();
			
		String pathToSource = new File(TestPeople.class.getResource("/person_data.xml").getFile()).getAbsolutePath();	
				
		runtime.execute("--input source=" + pathToSource + " /home/sheila/Repositories/git/sapling/src/test/xproc/input_source_select.xpl");
		
		assertXMLEqual("<person />", runtime.getResponse());
	}
	
}
