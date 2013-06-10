package com.bluegumtree.sapling.people;

// import static org.custommonkey.xmlunit.XMLAssert.assertXMLEqual;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

import java.util.ArrayList;

import org.junit.Test;

import com.bluegumtree.sapling.people.Name.NameType;


public class TestPersona {

	@Test
	public void testPersonaConstructor() {
		
		assertNotNull(new Persona());
		
	}
	
	@Test
	public void testPersonaSetNames() {
		
		ArrayList<Name> testNames = new ArrayList<Name>();
		testNames.add(new Name("Edith"));
		testNames.add(new Name("Agnes"));
		testNames.add(new Name("Thomson"));
		
		Persona persona = new Persona();
		persona.setNames(testNames);
		
		assertEquals(testNames, persona.getNames());
				
	}
	
	@Test
	public void testPersonaGetPersonalNames() {
		
		ArrayList<Name> givenNames = new ArrayList<Name>();
		givenNames.add(new Name("Edith"));
		givenNames.add(new Name("Agnes"));
		
		ArrayList<Name> allNames = new ArrayList<Name>();
		allNames.addAll(givenNames);
		allNames.add(new Name("Thomson", NameType.family));
		
		Persona persona = new Persona();
		persona.setNames(allNames);
		
		assertEquals(givenNames, persona.getNames(NameType.given));
				
	}
	
	@Test
	public void testPersonaGetFamilyNames() {
		
		ArrayList<Name> allNames = new ArrayList<Name>();
		allNames.add(new Name("Edith"));
		allNames.add(new Name("Agnes"));
		
		ArrayList<Name> familyNames = new ArrayList<Name>();
		familyNames.add(new Name("Thomson", NameType.family)); 
		allNames.addAll(familyNames);
		
		Persona persona = new Persona();
		persona.setNames(allNames);
		
		assertEquals(familyNames, persona.getNames(NameType.family));
				
	}
	
	@Test
	public void testPersonaSetGender_null() {
		
		Persona persona = new Persona();
		persona.setGender(null);
		
		assertEquals(Gender.unspecified, persona.getGender());
		
	}
	
	@Test
	public void testPersonaSetGender_female() {
		
		Persona persona = new Persona();
		persona.setGender(Gender.female);
		
		assertEquals(Gender.female, persona.getGender());
		
	}
	
	@Test
	public void testPersonaSetGender_male() {
		
		Persona persona = new Persona();
		persona.setGender(Gender.male);
		
		assertEquals(Gender.male, persona.getGender());
		
	}
}
