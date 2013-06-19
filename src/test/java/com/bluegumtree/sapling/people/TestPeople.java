package com.bluegumtree.sapling.people;

import static org.custommonkey.xmlunit.XMLAssert.assertXMLEqual;

import java.io.File;

import org.apache.commons.io.FileUtils;
import org.custommonkey.xmlunit.XMLUnit;
import org.junit.BeforeClass;
import org.junit.Test;


public class TestPeople {

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
		
		runtime.execute("/home/sheila/Repositories/git/sapling/src/main/xproc/get_person_data.xpl");			
		
		XMLUnit.setIgnoreWhitespace(true);
		
		assertXMLEqual(expected, runtime.getResponse());
		
	}
		
	@Test
	public void testShowPerson() throws Exception {			
		
		String expected = FileUtils.readFileToString(new File(TestPeople.class.getResource("/show_person.html").getFile()), "UTF-8");
		
		CommandLineXmlProcessor runtime = new CommandLineXmlProcessor();
				
		runtime.execute("/home/sheila/Repositories/git/sapling/src/main/xproc/show_person.xpl root-publication-directory=/home/sheila/Software/Sapling/");					
		
		XMLUnit.setIgnoreWhitespace(true);
		
		String result = FileUtils.readFileToString(new File("/home/sheila/Software/Sapling/people/78.html"), "UTF-8");
		
		// String result = runtime.getResponse();
		
		assertXMLEqual(expected, result);
		
	}	
	
	@Test
	public void testShowPerson_noRootPublicationDirectory() throws Exception {			
		
		String expected = FileUtils.readFileToString(new File(TestPeople.class.getResource("/show_person.html").getFile()), "UTF-8");
		
		CommandLineXmlProcessor runtime = new CommandLineXmlProcessor();
				
		runtime.execute("/home/sheila/Repositories/git/sapling/src/main/xproc/show_person.xpl");					
		
		XMLUnit.setIgnoreWhitespace(true);
		
		String result = FileUtils.readFileToString(new File("/home/sheila/Software/Sapling/people/78.html"), "UTF-8");
		
		// String result = runtime.getResult();
		
		assertXMLEqual(expected, result);
		
	}
	
}
