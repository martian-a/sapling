package com.bluegumtree.sapling.people;

import static org.junit.Assert.assertEquals;

import org.junit.Test;

public class Name {

	public enum NameType {
		given, family;
	}
	
	private final String value;	
	private final NameType type;
	
	public Name(String valueIn, NameType typeIn) {
		this.value = valueIn; 
		this.type = typeIn;
	}
	
	public Name(String valueIn) {
		this(valueIn, NameType.given);
	}
	
	public Name() {
		this(null);
	}
	
	public String getValue() {
		return this.value;
	}

	public NameType getType() {
		return this.type;
	}
	
}
