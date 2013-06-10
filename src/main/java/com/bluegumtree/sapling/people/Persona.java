package com.bluegumtree.sapling.people;

import java.util.ArrayList;

import com.bluegumtree.sapling.people.Name.NameType;

public class Persona {

	private ArrayList<Name> names;	
	private Gender gender;

	public void setNames(ArrayList<Name> testNames) {
		this.names = testNames;		
	}

	public ArrayList<Name> getNames() {
		return this.names;
	}

	public ArrayList<Name> getNames(NameType typeRequired) {
	
		ArrayList<Name> matches = new ArrayList<Name>();
		for (Name name : this.names) {
			if (name.getType().equals(typeRequired)) {
				matches.add(name);
			}
		}
		return matches;
	}

	public void setGender(Gender genderIn) {
		if (genderIn != null) {
			this.gender = genderIn;
		} else {
			this.gender = gender.unspecified;
		}
	}

	public Gender getGender() {
		return this.gender;
	}
	
}
