package com.bluegumtree.sapling.people;

import static org.custommonkey.xmlunit.XMLAssert.assertXMLEqual;

import java.io.File;

import org.apache.commons.io.FileUtils;
import org.custommonkey.xmlunit.XMLUnit;
import org.junit.Test;


public class TestGeneratePersonProfile {

	@Test
	public void testGeneratePersonProfile() throws Exception {			
		
		String expected = FileUtils.readFileToString(new File(TestGeneratePersonProfile.class.getResource("/person_profile.html").getFile()), "UTF-8");
		
		CommandLineXmlProcessor runtime = new CommandLineXmlProcessor();
				
		runtime.execute("/home/sheila/Repositories/git/sapling/src/main/xproc/generate_person_profile.xpl root-publication-directory=/home/sheila/Software/Sapling/");					
		
		XMLUnit.setIgnoreWhitespace(true);
		
		String result = FileUtils.readFileToString(new File("/home/sheila/Software/Sapling/people/78.html"), "UTF-8");
		
		// String result = runtime.getResponse();
		
		assertXMLEqual(expected, result);
		
	}
	
}
