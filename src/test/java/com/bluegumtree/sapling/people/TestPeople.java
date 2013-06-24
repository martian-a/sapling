package com.bluegumtree.sapling.people;

import static org.custommonkey.xmlunit.XMLAssert.assertXMLEqual;

import java.io.File;

import org.apache.commons.io.FileUtils;
import org.custommonkey.xmlunit.XMLUnit;
import org.junit.BeforeClass;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.ExpectedException;


public class TestPeople {

	@Rule
	public ExpectedException exception = ExpectedException.none();
	
	@BeforeClass
	public static void oneTimeSetup() {
		FileUtils.deleteQuietly(new File("/home/sheila/Software/Sapling/people"));
	}
	
	@Test
	public void testGetPeopleData() throws Exception {			
		
		String expected = FileUtils.readFileToString(new File(TestPeople.class.getResource("/people_data.xml").getFile()), "UTF-8");
		
		CommandLineXmlProcessor runtime = new CommandLineXmlProcessor();
		
		runtime.execute("/home/sheila/Repositories/git/sapling/src/main/xproc/get_people_data.xpl");			
		
		XMLUnit.setIgnoreWhitespace(true);
		
		assertXMLEqual(expected, runtime.getResponse());
		
	}
	
	@Test
	public void testShowPeople() throws Exception {			
		
		String rootPublicationDirectory = "/home/sheila/Software/Sapling/";
		String pathToResultFile = rootPublicationDirectory + "people/index.html";
		
		String pathToSource = new File(TestPeople.class.getResource("/people_data.xml").getFile()).getAbsolutePath();
		
		String expectedFile = FileUtils.readFileToString(new File(TestPeople.class.getResource("/show_people.html").getFile()), "UTF-8");
		String expectedResponse = "<sapling><link href=\"" + pathToResultFile + "\" /></sapling>";
				
		CommandLineXmlProcessor runtime = new CommandLineXmlProcessor();
				
		runtime.execute("--input source=" + pathToSource + " /home/sheila/Repositories/git/sapling/src/main/xproc/show_people.xpl root-publication-directory=" + rootPublicationDirectory);		
		XMLUnit.setIgnoreWhitespace(true);
		
		
		String resultFile = FileUtils.readFileToString(new File(pathToResultFile), "UTF-8");
		
		assertXMLEqual(expectedFile, resultFile);
		assertXMLEqual(expectedResponse, runtime.getResponse());
		
	}
	
	@Test
	public void testGetPersonData() throws Exception {			
		
		String expected = FileUtils.readFileToString(new File(TestPeople.class.getResource("/person_data.xml").getFile()), "UTF-8");
		
		CommandLineXmlProcessor runtime = new CommandLineXmlProcessor();
		
		runtime.execute("/home/sheila/Repositories/git/sapling/src/main/xproc/get_person_data.xpl id=PER78");			
		
		XMLUnit.setIgnoreWhitespace(true);
		
		assertXMLEqual(expected, runtime.getResponse());
		
	}
		
	@Test
	public void testShowPerson() throws Exception {			
					
		String idNumber = "78";
		String rootPublicationDirectory = "/home/sheila/Software/Sapling/";
		String pathToResultFile = rootPublicationDirectory + "people/" + idNumber + ".html";
		
		String pathToSource = new File(TestPeople.class.getResource("/person_data.xml").getFile()).getAbsolutePath();
		
		String expectedFile = FileUtils.readFileToString(new File(TestPeople.class.getResource("/show_person.html").getFile()), "UTF-8");
		String expectedResponse = "<sapling><link href=\"" + pathToResultFile + "\" /></sapling>";
				
		CommandLineXmlProcessor runtime = new CommandLineXmlProcessor();
				
		runtime.execute("--input source=" + pathToSource + " /home/sheila/Repositories/git/sapling/src/main/xproc/show_person.xpl root-publication-directory=" + rootPublicationDirectory);					
		
		XMLUnit.setIgnoreWhitespace(true);
		
		String resultFile = FileUtils.readFileToString(new File(pathToResultFile), "UTF-8");		
		
		assertXMLEqual(expectedFile, resultFile);
		assertXMLEqual(expectedResponse, runtime.getResponse());
		
	}	

	@Test
	public void testPublishPeople() throws Exception {			
		
		String rootPublicationDirectory = "/home/sheila/Software/Sapling/";
		String pathToResultFileIndex = rootPublicationDirectory + "people/index.html";		
		
		String expectedFile = FileUtils.readFileToString(new File(TestPeople.class.getResource("/show_people.html").getFile()), "UTF-8");
		String expectedResponse = "<sapling><link href=\"" + pathToResultFileIndex + "\" /></sapling>";
				
		CommandLineXmlProcessor runtime = new CommandLineXmlProcessor();
				
		runtime.execute("/home/sheila/Repositories/git/sapling/src/main/xproc/publish_people.xpl root-publication-directory=" + rootPublicationDirectory);		
		XMLUnit.setIgnoreWhitespace(true);		
		
		// String resultFile = FileUtils.readFileToString(new File(pathToResultFileIndex), "UTF-8");
		
		assertXMLEqual(expectedResponse, runtime.getResponse());
		// assertXMLEqual(expectedFile, resultFile);
		
	}
}