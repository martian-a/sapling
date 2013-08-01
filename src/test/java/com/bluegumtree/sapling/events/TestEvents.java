package com.bluegumtree.sapling.events;

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


public class TestEvents {

	static private CommandLineXmlProcessorCalabash processor;
	
	@Rule
	public ExpectedException exception = ExpectedException.none();
	
	@BeforeClass
	static public void setupOnce() throws IOException {
		
		FileUtils.deleteQuietly(new File("/home/sheila/Software/Sapling/events"));
		
		processor = new CommandLineXmlProcessorCalabash();
		
	}
	
	@Before
	public void setup() {
		processor.reset();
	}
	
	@Test
	public void testGetEventsData() throws Exception {			
		
		processor.setPipeline(new URI("/home/sheila/Repositories/git/sapling/src/main/resources/xproc/get_events_data.xpl"));
		
		String expected = FileUtils.readFileToString(new File(TestEvents.class.getResource("/control/events_data.xml").getFile()), "UTF-8");		
		
		processor.execute();			
		
		XMLUnit.setIgnoreWhitespace(true);
		
		assertXMLEqual(expected, processor.getResponse());
		
	}
	
	@Test
	public void testShowEvents() throws Exception {			
		
		String rootPublicationDirectory = "/home/sheila/Software/Sapling/";
		String pathToResultFile = rootPublicationDirectory + "events/index.html";
		
		File inputFile = new File(TestEvents.class.getResource("/control/events_data.xml").getFile());
		
		TreeMap<String, String> options = new TreeMap<String, String>();
		options.put("root-publication-directory", rootPublicationDirectory);
		
		processor.setPipeline(new File("/home/sheila/Repositories/git/sapling/src/main/resources/xproc/show_events.xpl").toURI());
		processor.setInput(inputFile.toURI());
		processor.setOptions(options);
		
		String expectedFile = FileUtils.readFileToString(new File(TestEvents.class.getResource("/control/show_events.html").getFile()), "UTF-8");
		String expectedResponse = "<sapling><link href=\"" + pathToResultFile + "\" /></sapling>";				
				
		processor.execute();		
		XMLUnit.setIgnoreWhitespace(true);
		
		
		String resultFile = FileUtils.readFileToString(new File(pathToResultFile), "UTF-8");
		
		assertXMLEqual(expectedFile, resultFile);
		assertXMLEqual(expectedResponse, processor.getResponse());
		
	}
	
	@Test
	public void testGetEventData() throws Exception {					
		
		TreeMap<String, String> options = new TreeMap<String, String>();
		options.put("id", "EVE78");		
		
		processor.setPipeline(new File("/home/sheila/Repositories/git/sapling/src/main/resources/xproc/get_event_data.xpl").toURI());
		processor.setOptions(options);
		
		String expected = FileUtils.readFileToString(new File(TestEvents.class.getResource("/control/event_data.xml").getFile()), "UTF-8");		
		
		processor.execute();			
		
		XMLUnit.setIgnoreWhitespace(true);
		
		assertXMLEqual(expected, processor.getResponse());
		
	}
		
	@Test
	public void testShowEvent() throws Exception {			
					
		String idNumber = "78";
		String rootPublicationDirectory = "/home/sheila/Software/Sapling/";
		String pathToResultFile = rootPublicationDirectory + "events/" + idNumber + ".html";
		
		TreeMap<String, String> options = new TreeMap<String, String>();
		options.put("root-publication-directory", rootPublicationDirectory);
		
		File inputFile = new File(TestEvents.class.getResource("/control/event_data.xml").getFile());
		
		processor.setPipeline(new File("/home/sheila/Repositories/git/sapling/src/main/resources/xproc/show_event.xpl").toURI());		
		processor.setInput(inputFile.toURI());
		processor.setOptions(options);
		
		String expectedFile = FileUtils.readFileToString(new File(TestEvents.class.getResource("/control/show_event.html").getFile()), "UTF-8");
		String expectedResponse = "<sapling><link href=\"" + pathToResultFile + "\" /></sapling>";				
				
		processor.execute();					
		
		XMLUnit.setIgnoreWhitespace(true);
		
		String resultFile = FileUtils.readFileToString(new File(pathToResultFile), "UTF-8");		
		
		assertXMLEqual(expectedFile, resultFile);
		assertXMLEqual(expectedResponse, processor.getResponse());
		
	}	

	@Test
	public void testPublishEvents() throws Exception {			
		
		String rootPublicationDirectory = "/home/sheila/Software/Sapling/";
		String pathToResultFileIndex = rootPublicationDirectory + "events/index.html";
		File pathToResultFileList = new File(TestEvents.class.getResource("/control/publish_events_file_list.xml").getFile());
		
		TreeMap<String, String> options = new TreeMap<String, String>();
		options.put("root-publication-directory", rootPublicationDirectory);
		
		processor.setPipeline(new File("/home/sheila/Repositories/git/sapling/src/main/resources/xproc/publish_events.xpl").toURI());
		processor.setOptions(options);		
		
		String expectedFile = FileUtils.readFileToString(new File(TestEvents.class.getResource("/control/show_events.html").getFile()), "UTF-8");
		String expectedResponse = FileUtils.readFileToString(pathToResultFileList, "UTF-8");			
		
		processor.execute();		
		XMLUnit.setIgnoreWhitespace(true);		
		
		String resultFile = FileUtils.readFileToString(new File(pathToResultFileIndex), "UTF-8");
		
		assertXMLEqual(expectedFile, resultFile);
		assertXMLEqual(expectedResponse, processor.getResponse());
		
	}
}
