package com.bluegumtree.sapling.people;

import static org.custommonkey.xmlunit.XMLAssert.assertXMLEqual;

import java.io.File;

import org.apache.commons.io.FileUtils;
import org.custommonkey.xmlunit.XMLUnit;
import org.junit.BeforeClass;
import org.junit.Ignore;
import org.junit.Test;


public class TestLibrary {

	@BeforeClass
	public static void oneTimeSetup() {
		FileUtils.deleteQuietly(new File("/home/sheila/Software/Sapling/people"));
	}
	
	@Test
	public void testXqueryRequest() throws Exception {			
		
		String expected = FileUtils.readFileToString(new File(TestLibrary.class.getResource("/person_data.xml").getFile()), "UTF-8");
		
		CommandLineXmlProcessor runtime = new CommandLineXmlProcessor();
		
		runtime.execute("/home/sheila/Repositories/git/sapling/src/main/xproc/xquery_request.xpl uri=http://localhost:8080/exist/apps/sapling-test/queries/person.xq?id=PER78");
		
		XMLUnit.setIgnoreWhitespace(true);
		
		assertXMLEqual(expected, runtime.getResponse());
		
	}
	
}
