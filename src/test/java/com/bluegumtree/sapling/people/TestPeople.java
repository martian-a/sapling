package com.bluegumtree.sapling.people;

import static org.custommonkey.xmlunit.XMLAssert.assertXMLEqual;

import java.io.File;

import org.apache.commons.io.FileUtils;
import org.custommonkey.xmlunit.XMLUnit;
import org.junit.BeforeClass;
import org.junit.Ignore;
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
		
		String expected = FileUtils.readFileToString(new File(TestPeople.class.getResource("/show_people.html").getFile()), "UTF-8");
		
		CommandLineXmlProcessor runtime = new CommandLineXmlProcessor();
				
		runtime.execute("/home/sheila/Repositories/git/sapling/src/main/xproc/show_people.xpl root-publication-directory=/home/sheila/Software/Sapling/");					
		
		XMLUnit.setIgnoreWhitespace(true);
		
		String result = FileUtils.readFileToString(new File("/home/sheila/Software/Sapling/people/index.html"), "UTF-8");
		
		// String result = runtime.getResponse();
		
		assertXMLEqual(expected, result);
		
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
	public void testShowPerson_noRootPublicationDirectory() throws Exception {
		
		exception.expect(CommandLineXmlProcessorException.class);
		exception.expectMessage("err:XD0023:Undeclared variable in XPath expression: $root-publication-directory");				
		
		String pathToSource = new File(TestPeople.class.getResource("/person_data.xml").getFile()).getAbsolutePath();
						
		CommandLineXmlProcessor runtime = new CommandLineXmlProcessor();
				
		runtime.execute("--input source=" + pathToSource + " /home/sheila/Repositories/git/sapling/src/main/xproc/show_person.xpl");					
		
	}
	
}