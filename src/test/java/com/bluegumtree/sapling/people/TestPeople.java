package com.bluegumtree.sapling.people;

import static org.custommonkey.xmlunit.XMLAssert.assertXMLEqual;

import java.io.File;
import java.io.IOException;
import java.net.URI;
import java.util.TreeMap;

import org.apache.commons.io.FileUtils;
import org.custommonkey.xmlunit.XMLUnit;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.ExpectedException;

import com.kaikoda.gourd.CommandLineXmlProcessorCalabash;


public class TestPeople {

	static private CommandLineXmlProcessorCalabash processor;
	
	@Rule
	public ExpectedException exception = ExpectedException.none();
	
	@BeforeClass
	static public void setupOnce() throws IOException {
		
		FileUtils.deleteQuietly(new File("/home/sheila/Software/Sapling/people"));
		
		processor = new CommandLineXmlProcessorCalabash();
		
	}
	
	@Before
	public void setup() {
		processor.reset();
	}
	
	@Test
	public void testGetPeopleData() throws Exception {			
		
		processor.setPipeline(new URI("/home/sheila/Repositories/git/sapling/src/main/resources/xproc/people/get_people_data.xpl"));
		
		String expected = FileUtils.readFileToString(new File(TestPeople.class.getResource("/control/people_data.xml").getFile()), "UTF-8");		
		
		processor.execute();			
		
		XMLUnit.setIgnoreWhitespace(true);
		
		assertXMLEqual(expected, processor.getResponse());
		
	}
	
	@Test
	public void testShowPeople() throws Exception {			
		
		String rootPublicationDirectory = "/home/sheila/Software/Sapling/";
		String pathToResultFile = rootPublicationDirectory + "people/index.html";
		
		File inputFile = new File(TestPeople.class.getResource("/control/people_data.xml").getFile());
		
		TreeMap<String, String> options = new TreeMap<String, String>();
		options.put("root-publication-directory", rootPublicationDirectory);
		
		processor.setPipeline(new File("/home/sheila/Repositories/git/sapling/src/main/resources/xproc/people/show_people.xpl").toURI());
		processor.setInput(inputFile.toURI());
		processor.setOptions(options);
		
		String expectedFile = FileUtils.readFileToString(new File(TestPeople.class.getResource("/control/show_people.html").getFile()), "UTF-8");
		String expectedResponse = "<sapling><link href=\"" + pathToResultFile + "\" /></sapling>";				
				
		processor.execute();		
		XMLUnit.setIgnoreWhitespace(true);
		
		
		String resultFile = FileUtils.readFileToString(new File(pathToResultFile), "UTF-8");
		
		assertXMLEqual(expectedFile, resultFile);
		assertXMLEqual(expectedResponse, processor.getResponse());
		
	}
	
	@Test
	public void testGetPersonData() throws Exception {					
		
		TreeMap<String, String> options = new TreeMap<String, String>();
		options.put("id", "PER78");		
		
		processor.setPipeline(new File("/home/sheila/Repositories/git/sapling/src/main/resources/xproc/people/get_person_data.xpl").toURI());
		processor.setOptions(options);
		
		String expected = FileUtils.readFileToString(new File(TestPeople.class.getResource("/control/person_data.xml").getFile()), "UTF-8");		
		
		processor.execute();			
		
		XMLUnit.setIgnoreWhitespace(true);
		
		assertXMLEqual(expected, processor.getResponse());
		
	}
		
	@Test
	public void testShowPerson() throws Exception {			
					
		String idNumber = "78";
		String rootPublicationDirectory = "/home/sheila/Software/Sapling/";
		String pathToResultFile = rootPublicationDirectory + "people/" + idNumber + ".html";
		
		TreeMap<String, String> options = new TreeMap<String, String>();
		options.put("root-publication-directory", rootPublicationDirectory);
		
		File inputFile = new File(TestPeople.class.getResource("/control/person_data.xml").getFile());
		
		processor.setPipeline(new File("/home/sheila/Repositories/git/sapling/src/main/resources/xproc/people/show_person.xpl").toURI());		
		processor.setInput(inputFile.toURI());
		processor.setOptions(options);
		
		String expectedFile = FileUtils.readFileToString(new File(TestPeople.class.getResource("/control/show_person.html").getFile()), "UTF-8");
		String expectedResponse = "<sapling><link href=\"" + pathToResultFile + "\" /></sapling>";				
				
		processor.execute();					
		
		XMLUnit.setIgnoreWhitespace(true);
		
		String resultFile = FileUtils.readFileToString(new File(pathToResultFile), "UTF-8");		
		
		assertXMLEqual(expectedFile, resultFile);
		assertXMLEqual(expectedResponse, processor.getResponse());
		
	}	

	@Test
	public void testPublishPeople() throws Exception {			
		
		String rootPublicationDirectory = "/home/sheila/Software/Sapling/";
		String pathToResultFileIndex = rootPublicationDirectory + "people/index.html";
		File pathToResultFileList = new File(TestPeople.class.getResource("/control/publish_people_file_list.xml").getFile());
		
		TreeMap<String, String> options = new TreeMap<String, String>();
		options.put("root-publication-directory", rootPublicationDirectory);
		
		processor.setPipeline(new File("/home/sheila/Repositories/git/sapling/src/main/resources/xproc/people/publish_people.xpl").toURI());
		processor.setOptions(options);		
		
		String expectedFile = FileUtils.readFileToString(new File(TestPeople.class.getResource("/control/show_people.html").getFile()), "UTF-8");
		String expectedResponse = FileUtils.readFileToString(pathToResultFileList, "UTF-8");			
		
		processor.execute();		
		XMLUnit.setIgnoreWhitespace(true);		
		
		String resultFile = FileUtils.readFileToString(new File(pathToResultFileIndex), "UTF-8");
		
		assertXMLEqual(expectedFile, resultFile);
		assertXMLEqual(expectedResponse, processor.getResponse());
		
	}
}
