package com.bluegumtree.sapling.people;

// import static org.custommonkey.xmlunit.XMLAssert.assertXMLEqual;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.util.ArrayList;

import org.junit.Test;

import com.bluegumtree.sapling.people.Name.NameType;


public class TestNotes {

	@Test
	public void testNotesConstructor() {
		
		assertNotNull(new Notes());
		
	}
	
	@Test
	public void testSetValue() {
		
		Notes notes = new Notes();
		notes.setValue("<p>Testing, testing. One, two, three.</p>");
		
	}
	
}
