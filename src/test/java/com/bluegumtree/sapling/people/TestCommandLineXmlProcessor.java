package com.bluegumtree.sapling.people;

import static org.custommonkey.xmlunit.XMLAssert.assertXMLEqual;

import java.io.File;

import org.apache.commons.io.FileUtils;
import org.junit.Test;

public class TestCommandLineXmlProcessor {

	@Test
	public void testExecute() throws Exception {		
		
		String expected = FileUtils.readFileToString(new File(TestGetPersonData.class.getResource("/person_data.xml").getFile()), "UTF-8");
		
		CommandLineXmlProcessor runtime = new CommandLineXmlProcessor();
		
		runtime.execute("/home/sheila/Repositories/git/sapling/src/main/xproc/get_person_data.xpl");			
		
		assertXMLEqual(expected, runtime.getResponse());
		
	}
	
}
