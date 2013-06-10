package com.bluegumtree.sapling.people;

// import static org.custommonkey.xmlunit.XMLAssert.assertXMLEqual;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import org.junit.After;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.ExpectedException;

import com.bluegumtree.sapling.people.Name.NameType;
import com.bluegumtree.sapling.people.Person;


public class TestName {

	@Test
	public void testName_null() {		
		assertNotNull(new Name());		
	}
	
	@Test
	public void testName_notNull() {		
		
		String testValue = "Molly";
		Name testName = new Name(testValue);
		
		assertEquals(testValue, testName.getValue());
		
	}
	
	
	@Test
	public void testName_typeGiven_explicit() {		
	
		NameType testType = NameType.given;		
		Name testName = new Name("Molly", testType);		
		assertEquals(testType, testName.getType());
		
	}
	
	@Test
	public void testName_typeGiven_implicit() {		
			
		NameType testType = NameType.given;		
		Name testName = new Name("Molly");		
		assertEquals(testType, testName.getType());
		
	}
	
	@Test
	public void testName_typeFamily_explicit() {		
			
		NameType testType = NameType.family;		
		Name testName = new Name("Thomson", testType);		
		assertEquals(testType, testName.getType());
		
	}
	
}
