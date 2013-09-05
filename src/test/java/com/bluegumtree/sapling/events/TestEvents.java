package com.bluegumtree.sapling.events;

import static org.custommonkey.xmlunit.XMLAssert.assertXMLEqual;
import static org.junit.Assert.assertEquals;

import java.io.File;
import java.io.IOException;
import java.net.URI;
import java.util.TreeMap;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerConfigurationException;

import org.apache.commons.io.FileUtils;
import org.custommonkey.xmlunit.XMLUnit;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.ExpectedException;

import com.kaikoda.gourd.CommandLineXmlProcessorCalabash;
import com.kaikoda.willow.PrimedTransformer;

public class TestEvents {

	static private CommandLineXmlProcessorCalabash processor;
	static private PrimedTransformer transformer;

	static private String rootPublicationDirectoryPath;
	static private File sampleControlFileEvent66Data;
	static private String sampleControlStringEvent66Data;
	static private File sampleControlFileEventsData;
	static private String sampleControlStringEventsData;

	static private File sampleControlFileShowEventsHtml;
	static private String sampleControlStringShowEventsHtml;

	static private File sampleControlFileShowEvent66Html;
	static private String sampleControlStringShowEvent66Html;

	static private File sampleResultFileShowEventsHtml;
	static private File sampleResultFileShowEvent66Html;

	@Rule
	public ExpectedException exception = ExpectedException.none();

	@BeforeClass
	static public void setupOnce() throws IOException, TransformerConfigurationException, ParserConfigurationException {

		FileUtils.deleteQuietly(new File("/home/sheila/Software/Sapling/events"));

		processor = new CommandLineXmlProcessorCalabash();
		transformer = new PrimedTransformer();

		sampleControlFileEvent66Data = new File(TestEvents.class.getResource("/control/events/event_data.xml").getFile());
		sampleControlStringEvent66Data = FileUtils.readFileToString(sampleControlFileEvent66Data, "UTF-8");

		/*
		 * sampleControlFileEventsData = new
		 * File(TestEvents.class.getResource("/control/events/events_data.xml"
		 * ).getFile()); sampleControlStringEventsData =
		 * FileUtils.readFileToString(sampleControlFileEventsData, "UTF-8");
		 * 
		 * sampleControlFileShowEventsHtml = new
		 * File(TestEvents.class.getResource
		 * ("/control/events/show_events.html").getFile());
		 * sampleControlStringShowEventsHtml =
		 * FileUtils.readFileToString(sampleControlFileShowEventsHtml, "UTF-8");
		 */

		sampleControlFileShowEvent66Html = new File(TestEvents.class.getResource("/control/events/show_event.html").getFile());
		sampleControlStringShowEvent66Html = FileUtils.readFileToString(sampleControlFileShowEvent66Html, "UTF-8");

		rootPublicationDirectoryPath = "/home/sheila/Software/Sapling/";

		sampleResultFileShowEvent66Html = new File(rootPublicationDirectoryPath + "events/66.html");
		sampleResultFileShowEventsHtml = new File(rootPublicationDirectoryPath + "events/index.html");

	}

	@Before
	public void setup() {

		processor.reset();

		/*
		 * assertEquals(true, sampleControlFileEvent66Data.exists());
		 * assertEquals(true, sampleControlStringEvent66Data != null);
		 * 
		 * assertEquals(true, sampleControlFileEventsData.exists());
		 * assertEquals(true, sampleControlStringEventsData != null);
		 * 
		 * assertEquals(true, sampleControlFileShowEventsHtml.exists());
		 * assertEquals(true, sampleControlStringShowEventsHtml != null);
		 * 
		 * assertEquals(true, sampleControlFileShowEvent66Html.exists());
		 * assertEquals(true, sampleControlStringShowEvent66Html != null);
		 * 
		 * assertEquals(false, sampleResultFileShowEvent66Html.exists());
		 * assertEquals(false, sampleResultFileShowEventsHtml.exists());
		 */

	}

	/**
	 * Check that the data for the index of events is retrieved correctly.
	 * 
	 * @throws Exception
	 */
	@Test
	public void testGetEventsData() throws Exception {

		File xprocGetEventData = new File(TestEvents.class.getResource("/xproc/events/get_events_data.xpl").getFile());
		assertEquals(true, xprocGetEventData.exists());
		
		processor.setPipeline(xprocGetEventData.toURI());
		processor.execute();

		XMLUnit.setIgnoreWhitespace(true);

		assertXMLEqual(sampleControlStringEvent66Data, processor.getResponse());

	}

	/**
	 * Check that an HTML view of the index of events is published.
	 * 
	 * @throws Exception
	 */
	@Test
	public void testShowEvents() throws Exception {

		TreeMap<String, String> options = new TreeMap<String, String>();
		options.put("root-publication-directory", rootPublicationDirectoryPath);

		File xprocShowEvents = new File(TestEvents.class.getResource("/xproc/events/show_events.xpl").getFile());
		assertEquals(true, xprocShowEvents.exists());
		
		processor.setPipeline(xprocShowEvents.toURI());
		processor.setInput(sampleControlFileEventsData.toURI());
		processor.setOptions(options);

		String expectedResponse = "<sapling><link href=\"" + sampleResultFileShowEventsHtml.toURI().toString() + "\" /></sapling>";

		processor.execute();
		XMLUnit.setIgnoreWhitespace(true);

		assertEquals(true, sampleResultFileShowEventsHtml.exists());
		String sampleResultStringShowEventsHtml = FileUtils.readFileToString(sampleResultFileShowEventsHtml, "UTF-8");

		assertXMLEqual(sampleResultStringShowEventsHtml, sampleResultStringShowEventsHtml);
		assertXMLEqual(expectedResponse, processor.getResponse());

	}

	/**
	 * Check that the XML data for an event is correctly retrieved from the data
	 * store.
	 * 
	 * @throws Exception
	 */
	@Test
	public void testGetEventData() throws Exception {

		// Check that the control sample exists
		assertEquals(true, sampleControlStringEvent66Data != null);
		
		// Check that the pipeline exists
		File xprocGetEventData = new File(TestEvents.class.getResource("/xproc/events/get_event_data.xpl").getFile());
		assertEquals(true, xprocGetEventData.exists());
		
		// Prepare the options
		TreeMap<String, String> options = new TreeMap<String, String>();
		options.put("id", "EVE66");
		
		// Prepare the pipeline
		processor.setPipeline(xprocGetEventData.toURI());
		processor.setOptions(options);

		processor.execute();

		XMLUnit.setIgnoreWhitespace(true);
		XMLUnit.setIgnoreAttributeOrder(true);

		assertXMLEqual(sampleControlStringEvent66Data, processor.getResponse());

	}

	/**
	 * Check that an HTML view of an event is correctly published.
	 * 
	 * @throws Exception
	 */
	@Test
	public void testShowEvent() throws Exception {

		// Prepare the expected result
		String expectedResponse = "<sapling><link href=\"" + sampleResultFileShowEvent66Html.toURI().toString() + "\" /></sapling>";

		// Check that the control sample exists
		assertEquals(true, sampleControlStringShowEvent66Html != null);
		
		// Check that the input file exists
		assertEquals(true, sampleControlFileEvent66Data.exists());
		
		// Check that the XProc file exists
		File xprocShowEvent = new File(TestEvents.class.getResource("/xproc/events/show_event.xpl").getFile());
		assertEquals(true, xprocShowEvent.exists());		
		
		// Prepare the options collection
		TreeMap<String, String> options = new TreeMap<String, String>();
		options.put("root-publication-directory", rootPublicationDirectoryPath);

		// Prepare the pipeline
		processor.setPipeline(xprocShowEvent.toURI());
		processor.setInput(sampleControlFileEvent66Data.toURI());
		processor.setOptions(options);

		// Execute the pipeline
		processor.execute();

		// Prepare the evaluation environment
		XMLUnit.setIgnoreWhitespace(true);

		// Check that the expected result file has be generated
		assertEquals(true, sampleResultFileShowEvent66Html.exists());

		// Read the contents of the result file
		String sampleResultStringShowEvent66Html = FileUtils.readFileToString(sampleResultFileShowEvent66Html, "UTF-8");

		// Check that the contents of the result file matches that expected
		assertXMLEqual(sampleControlStringShowEvent66Html, sampleResultStringShowEvent66Html);

		// Check that the response from the pipeline matches that expected
		assertXMLEqual(expectedResponse, processor.getResponse());

	}

	/**
	 * Check that an HTML view for every event is published.
	 * 
	 * @throws Exception
	 */
	@Test
	public void testPublishEvents() throws Exception {

		File pathToResultFileList = new File(TestEvents.class.getResource("/control/events/publish_events_file_list.xml").getFile());

		TreeMap<String, String> options = new TreeMap<String, String>();
		options.put("root-publication-directory", rootPublicationDirectoryPath);
		
		File xprocPublishEvents = new File(TestEvents.class.getResource("/xproc/events/publish_events.xpl").getFile());
		assertEquals(true, xprocPublishEvents.exists());

		processor.setPipeline(xprocPublishEvents.toURI());
		processor.setOptions(options);

		String expectedResponse = FileUtils.readFileToString(pathToResultFileList, "UTF-8");

		processor.execute();
		XMLUnit.setIgnoreWhitespace(true);

		assertEquals(true, sampleResultFileShowEventsHtml.exists());
		String resultString = FileUtils.readFileToString(sampleResultFileShowEventsHtml, "UTF-8");

		assertXMLEqual(sampleControlStringShowEventsHtml, resultString);
		assertXMLEqual(expectedResponse, processor.getResponse());

	}
}
