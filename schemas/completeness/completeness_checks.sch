<?xml version="1.0" encoding="UTF-8"?>
<sch:schema 
	xmlns:xi="http://www.w3.org/2001/XInclude"
	xmlns:sch="http://purl.oclc.org/dsdl/schematron" 
	xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
	queryBinding="xslt2">
	
	<sch:ns uri="http://www.w3.org/2003/01/geo/wgs84_pos#" prefix="geo"/>
		
	<sch:pattern>
		
		<sch:title>Person</sch:title>
		
		<sch:rule context="person/persona/name">
			
			<sch:assert test="name[@family = 'yes']">Missing family name.</sch:assert>
			<sch:assert test="name[not(@family = 'yes')]">Missing personal name.</sch:assert>
			
		</sch:rule>
		
		<sch:rule context="persona">
			
			<sch:assert test="gender[. != '']">Missing gender.</sch:assert>
			
		</sch:rule>
		
		<sch:rule context="person">
			
			<sch:let name="id" value="@id" />
			<sch:let name="current-year" value="year-from-date(current-date())" />
			<sch:let name="age" value="$current-year - @year" />
			
			<sch:assert test="/app/data/events/event[@type = 'birth']/person[@ref = $id]">Missing birth event.</sch:assert>
			<sch:report test="self::*[$age > 80] and not(/app/data/events/event[@type = 'death']/person[@ref = $id])">Missing death event.</sch:report>
			
		</sch:rule>
		
	</sch:pattern>
	
	
	<sch:pattern>
		
		<sch:title>Event</sch:title>
		
		<sch:rule context="event">
			
			<sch:assert test="descendant::location">Missing location.</sch:assert>
			
		</sch:rule>
		
		<sch:rule context="person">
			
			<sch:assert test="self::person[@year != '']">Missing estimated birth year.</sch:assert>
			
		</sch:rule>
		
	</sch:pattern>
	
	
	<sch:pattern>
		
		<sch:title>Historical Event</sch:title>
		
		<sch:rule context="event[@type = 'historical']">
			
			<sch:assert test="summary">Missing summary.</sch:assert>
			
		</sch:rule>
		
	</sch:pattern>
	
	
</sch:schema>