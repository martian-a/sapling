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


public class TestPeople {

	static private CommandLineXmlProcessor processor;
	
	@Rule
	public ExpectedException exception = ExpectedException.none();
	
	@BeforeClass
	static public void setupOnce() throws IOException {
		
		FileUtils.deleteQuietly(new File("/home/sheila/Software/Sapling/people"));
		
		processor = new CommandLineXmlProcessor();
		
	}
	
	@Before
	public void setup() {
		processor.reset();
	}
	
	@Test
	public void testGetPeopleData() throws Exception {			
		
		String expected = FileUtils.readFileToString(new File(TestPeople.class.getResource("/control/people_data.xml").getFile()), "UTF-8");		
		
		processor.execute("/home/sheila/Repositories/git/sapling/src/main/resources/xproc/get_people_data.xpl");			
		
		XMLUnit.setIgnoreWhitespace(true);
		
		assertXMLEqual(expected, processor.getResponse());
		
	}
	
	@Test
	public void testShowPeople() throws Exception {			
		
		String rootPublicationDirectory = "/home/sheila/Software/Sapling/";
		String pathToResultFile = rootPublicationDirectory + "people/index.html";
		
		String pathToSource = new File(TestPeople.class.getResource("/control/people_data.xml").getFile()).getAbsolutePath();
		
		String expectedFile = FileUtils.readFileToString(new File(TestPeople.class.getResource("/control/show_people.html").getFile()), "UTF-8");
		String expectedResponse = "<sapling><link href=\"" + pathToResultFile + "\" /></sapling>";				
				
		processor.execute("--input source=" + pathToSource + " /home/sheila/Repositories/git/sapling/src/main/resources/xproc/show_people.xpl root-publication-directory=" + rootPublicationDirectory);		
		XMLUnit.setIgnoreWhitespace(true);
		
		
		String resultFile = FileUtils.readFileToString(new File(pathToResultFile), "UTF-8");
		
		assertXMLEqual(expectedFile, resultFile);
		assertXMLEqual(expectedResponse, processor.getResponse());
		
	}
	
	@Test
	public void testGetPersonData() throws Exception {			
		
		String expected = FileUtils.readFileToString(new File(TestPeople.class.getResource("/control/person_data.xml").getFile()), "UTF-8");		
		
		processor.execute("/home/sheila/Repositories/git/sapling/src/main/resources/xproc/get_person_data.xpl id=PER78");			
		
		XMLUnit.setIgnoreWhitespace(true);
		
		assertXMLEqual(expected, processor.getResponse());
		
	}
		
	@Test
	public void testShowPerson() throws Exception {			
					
		String idNumber = "78";
		String rootPublicationDirectory = "/home/sheila/Software/Sapling/";
		String pathToResultFile = rootPublicationDirectory + "people/" + idNumber + ".html";
		
		String pathToSource = new File(TestPeople.class.getResource("/control/person_data.xml").getFile()).getAbsolutePath();
		
		String expectedFile = FileUtils.readFileToString(new File(TestPeople.class.getResource("/control/show_person.html").getFile()), "UTF-8");
		String expectedResponse = "<sapling><link href=\"" + pathToResultFile + "\" /></sapling>";				
				
		processor.execute("--input source=" + pathToSource + " /home/sheila/Repositories/git/sapling/src/main/resources/xproc/show_person.xpl root-publication-directory=" + rootPublicationDirectory);					
		
		XMLUnit.setIgnoreWhitespace(true);
		
		String resultFile = FileUtils.readFileToString(new File(pathToResultFile), "UTF-8");		
		
		assertXMLEqual(expectedFile, resultFile);
		assertXMLEqual(expectedResponse, processor.getResponse());
		
	}	
	
}