package com.bluegumtree.sapling.people;

// import static org.custommonkey.xmlunit.XMLAssert.assertXMLEqual;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.util.ArrayList;

import org.junit.Test;

import com.bluegumtree.sapling.people.Name.NameType;


public class TestPerson {

	@Test
	public void testPersonConstructor() {
		
		assertNotNull(new Person());
		
	}
	
	@Test
	public void testAddPersona() {
		
		Persona persona1 = new Persona();		
		ArrayList<Name> names1 = new ArrayList<Name>();
		names1.add(new Name("Edith"));
		names1.add(new Name("Agnes"));
		names1.add(new Name("Thomson", NameType.family));
		persona1.setNames(names1);
		persona1.setGender(Gender.female);
		
		Person person = new Person();
		ArrayList<Persona> personas = new ArrayList<Persona>();				
		
		person.addPersona(persona1);
		personas = person.getPersonas();
		
		assertTrue(personas.contains(persona1));
		assertEquals(1, personas.size());
		
		Persona persona2 = new Persona();		
		ArrayList<Name> names2 = new ArrayList<Name>();
		names2.add(new Name("Edith"));
		names2.add(new Name("Agnes"));
		names2.add(new Name("Spiro", NameType.family));
		persona2.setNames(names2);
		persona2.setGender(Gender.female);
		
		person.addPersona(persona2);		
		personas = person.getPersonas();
		
		assertTrue(personas.contains(persona1));
		assertEquals(2, personas.size());
		
	}
	
	@Test
	public void testSetNotes() {
		
		Person person = new Person();
		
		Notes notes = new Notes();
		notes.setValue("Molly was once a nurse.");
		
		person.setNotes(notes);
		
		assertEquals(notes, person.getNotes());
		
		
	}
	
}
