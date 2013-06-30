package com.bluegumtree.sapling.people;

import static org.custommonkey.xmlunit.XMLAssert.assertXMLEqual;

import java.io.File;
import java.io.IOException;

import org.apache.commons.io.FileUtils;
import org.custommonkey.xmlunit.XMLUnit;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.ExpectedException;

import com.kaikoda.gourd.CommandLineXmlProcessor;


public class TestLibrary {

static private CommandLineXmlProcessor processor;
	
	@BeforeClass
	static public void setupOnce() throws IOException {
		
		FileUtils.deleteQuietly(new File("/home/sheila/Software/Sapling/people"));
		
		processor = new CommandLineXmlProcessor();
		
	}
	
	@Before
	public void setup() {
		processor.reset();
	}
	
	@Rule
	public ExpectedException exception = ExpectedException.none();

	
	@Test
	public void testXqueryRequest() throws Exception {			
		
		String expected = FileUtils.readFileToString(new File(TestLibrary.class.getResource("/control/person_data.xml").getFile()), "UTF-8");		
		
		processor.execute("/home/sheila/Repositories/git/sapling/src/main/resources/xproc/xquery_request.xpl uri=http://localhost:8080/exist/apps/sapling-test/queries/person.xq?id=PER78");
		
		XMLUnit.setIgnoreWhitespace(true);
		
		assertXMLEqual(expected, processor.getResponse());
		
	}
	
}
