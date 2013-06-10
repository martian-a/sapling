package com.bluegumtree.sapling.people;

import java.util.ArrayList;
import java.util.Set;
import java.util.TreeSet;

public class Person {
	
	private ArrayList<Persona> personas;
	private Notes notes;
	
	public Person() {
		this.personas = new ArrayList<Persona>();
		this.notes = null;
	}
	
	public void addPersona(Persona persona) {
		if (persona != null) {
			this.personas.add(persona);
		}
	}

	public ArrayList<Persona> getPersonas() {
		return this.personas;
	}

	public Notes getNotes() {
		return this.notes;
	}

	public void setNotes(Notes notesIn) {
		this.notes = notesIn;		
	}
	
}
