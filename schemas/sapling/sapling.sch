<?xml version="1.0" encoding="UTF-8"?>
<sch:schema 
	xmlns:xi="http://www.w3.org/2001/XInclude"
	xmlns:sch="http://purl.oclc.org/dsdl/schematron" 
	xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
	queryBinding="xslt2">
	
	<sch:pattern>
		
		<sch:title>Date</sch:title>
				
		<sch:rule context="date">
		
			<sch:let name="month-name" value="
				if (normalize-space(@month) != '')
				then (
					if (@month = 1) 
					then 'January'
					else if (@month = 2)
					then 'February'
					else if (@month = 3)
					then 'March'
					else if (@month = 4)
					then 'April'
					else if (@month = 5)
					then 'May'
					else if (@month = 6)
					then 'June'
					else if (@month = 7)
					then 'July'
					else if (@month = 8)
					then 'August'
					else if (@month = 9)
					then 'September'
					else if (@month = 10)
					then 'October'
					else if (@month = 11)
					then 'November'
					else if (@month = 12)
					then 'December'
					else ''
				)
				else ''"
			/>
			
			<sch:let name="max-days" value="
				if ($month-name = 'February') 
				then 29
				else if ($month-name = ('April', 'June', 'September', 'November'))
				then 30
				else 31" />
				
					
			<!-- Month number -->
			<sch:report test="self::*/@month[$month-name != ''][. &lt; 1 or . &gt; 12]">Invalid date.  Month must be between 1 and 12.</sch:report>	
						
			<!-- Day number -->
			<sch:report test="self::*[@day = '']">Invalid date. Day value must be a number.</sch:report>
						
			<!-- Days in month -->
			<sch:report test="self::*[@month]/@day[. != ''][. &gt; $max-days]">Invalid date.  Too many days in the month.  No more than <sch:value-of select="$max-days"/> expected<sch:value-of select="if ($month-name != '') then concat(' in ', $month-name) else ()" />.</sch:report>
			
			<!-- Date part dependencies -->
			<sch:report test="self::*[@day]/not(@month)">Invalid date. A date with a day value must also have a month value.</sch:report>			
			
		</sch:rule>
		
	</sch:pattern>
	
	
	<sch:pattern>
		
		<sch:title>ID Prefix</sch:title>
		
		<sch:let name="entities" value="'person', 'location', 'event', 'organisation', 'name'" />
		
		<sch:rule context="*[name() = ($entities)]">
			
			<sch:let name="prefix" value="
				if (name() = 'person')
				then 'PER'
				else if (name() = 'location')
				then 'LOC'
				else if (name() = 'event')
				then 'EVE'
				else if (name() = 'organisation')
				then 'ORG'
				else if (name() = 'name')
				then 'NAM'
				
				else ''" />
			
			<sch:report test="self::*[@id/not(starts-with(., $prefix)) or @ref/not(starts-with(., $prefix))]">Invalid ID prefix.  The first three characters of a <sch:value-of select="local-name()"/> ID must be <sch:value-of select="$prefix"/>.</sch:report>
			
		</sch:rule>
		
	</sch:pattern>
	
	
	<sch:pattern>
		
		<sch:title>ISBN</sch:title>
		
		<!--
			https://isbn-information.com/check-digit-for-the-13-digit-isbn.html
			https://isbn-information.com/the-10-digit-isbn.html
		-->
		
		<sch:rule context="isbn">
						
			<sch:let name="isbn-normalised" value="translate(., 'x- ', 'X')" />
			
			<sch:let name="version" value="
				if (string-length($isbn-normalised) = 10) 
				then '10' 
				else if (string-length($isbn-normalised) = 13)
				then '13'
				else 'invalid'" />
			
			
			<sch:let name="check-digit" value="
				if ($version = '13')
				then xs:string(substring($isbn-normalised, 13, 1))
				else ''" />
			

			<sch:let name="check-mod" value="

				if ($version ='10')
				then 
					(
						(xs:integer(substring($isbn-normalised, 1, 1)) * 10) +
						(xs:integer(substring($isbn-normalised, 2, 1)) * 9) +
						(xs:integer(substring($isbn-normalised, 3, 1)) * 8) +
						(xs:integer(substring($isbn-normalised, 4, 1)) * 7) +
						(xs:integer(substring($isbn-normalised, 5, 1)) * 6) +
						(xs:integer(substring($isbn-normalised, 6, 1)) * 5) +
						(xs:integer(substring($isbn-normalised, 7, 1)) * 4) +
						(xs:integer(substring($isbn-normalised, 8, 1)) * 3) +
						(xs:integer(substring($isbn-normalised, 9, 1)) * 2) +
						(
							if (substring($isbn-normalised, 10, 1) = 'X') 
							then 10
							else xs:integer(substring($isbn-normalised, 10, 1)
						) * 1)
					) mod 11
				else if ($version = '13') 
				then 
					(
						(xs:integer(substring($isbn-normalised, 1, 1)) * 1) +
						(xs:integer(substring($isbn-normalised, 2, 1)) * 3) +
						(xs:integer(substring($isbn-normalised, 3, 1)) * 1) +
						(xs:integer(substring($isbn-normalised, 4, 1)) * 3) +
						(xs:integer(substring($isbn-normalised, 5, 1)) * 1) +
						(xs:integer(substring($isbn-normalised, 6, 1)) * 3) +
						(xs:integer(substring($isbn-normalised, 7, 1)) * 1) +
						(xs:integer(substring($isbn-normalised, 8, 1)) * 3) +
						(xs:integer(substring($isbn-normalised, 9, 1)) * 1) +
						(xs:integer(substring($isbn-normalised, 10, 1)) * 3) +
						(xs:integer(substring($isbn-normalised, 11, 1)) * 1) +
						(xs:integer(substring($isbn-normalised, 12, 1)) * 3)
					) mod 10
				else ''" />
			
			<sch:let name="check-value" value="xs:string(
					if ($version = '13')
					then
						if ($check-mod > 0) 
						then 10 - $check-mod
						else 0
					else $check-mod
				)" />
			
			<sch:assert test="self::*[translate(., '0123456789X- ', '') = '']">Invalid ISBN.  Unexpected character(s): <sch:value-of select="translate(., '0123456789X- ', '')" /></sch:assert>
			
			<sch:assert test="self::*[$version != '']">Invalid ISBN.  An ISBN must be either 10 or 13 characters long.</sch:assert>
			
			<sch:assert test="self::*[($version = '10' and $check-value = '0') or ($check-value = $check-digit)]">Invalid ISBN.  The check digit does not match the value of the check sum.</sch:assert>
			
		</sch:rule>
		
	</sch:pattern>
	

	<sch:pattern>
		
		<sch:title>Event</sch:title>
		
		<sch:rule context="event">
			
			<sch:let name="type" value="@type" />
			<sch:let name="subjects" value="person" />
			
			<sch:report test="preceding-sibling::event[@type = $type and $type != 'marriage'][person/@ref = $subjects/@ref]">Duplicate <sch:value-of select="$type"/>.</sch:report>
			
			<sch:report test="self::event[not($type = ('birth', 'adoption'))]/parent">Unexpected parent.  The parent element may only be used in birth or adoption events.</sch:report>
			<sch:report test="self::event[$type = 'historical']/*[name() = ('person', 'parent')]">Unexpected <sch:name />.  References to people may only be used in the summary of a historical event.</sch:report>
			<sch:report test="self::event[not($type = 'historical')]/location[preceding-sibling::location]">Unexpected location.  An event may only be associated with a single location, unless it is a historical event.</sch:report>
			
		</sch:rule>
		
	</sch:pattern>
	
	
	<sch:pattern>
		
		<sch:title>Person</sch:title>
		
		<sch:rule context="person">
			
			<sch:let name="birth-event" value="if (ancestor//data/events/event[@type = 'birth'][person/@ref = current()/@id]) then ancestor//data/events/event[@type = 'birth'][person/@ref = current()/@id] else ancestor//data/events/event[@type = 'christening'][person/@ref = current()/@id]" />
			
			<sch:report test="self::*[count($birth-event/date/@year) = 1]/@year[. != $birth-event/date/@year]">Invalid year.  Birth event year recorded as <sch:value-of select="$birth-event/date/@year"/>.</sch:report>
			
		</sch:rule>
		
	</sch:pattern>
	
	<sch:pattern>
		
		<sch:title>Sources</sch:title>
		
		<sch:let name="events" value="/app/data/events/event" />
		<sch:let name="people" value="/app/data/people/person" />
		<sch:let name="locations" value="/app/data/locations/location" />
		<sch:let name="organisations" value="/app/data/organisations/organisation" />
		
		<sch:rule context="/app/data/sources/source">
			
			<sch:let name="source-id" value="self::source/@id" />
			<sch:let name="total-references" value="count(($events, $people, $locations, $organisations)/sources/source[@ref = $source-id])" />
			
			<sch:assert test="self::source[$total-references > 0]">Unused source.  This source has NOT been referenced yet.</sch:assert>	
		
		</sch:rule>
		
	</sch:pattern>
	
	<sch:pattern>
		
		<sch:title>Source Extracts</sch:title>
		
		<sch:rule context="source/body-matter/extract">
			
			<sch:let name="highest-id" value="parent::body-matter/extract[
					@id/not(number(substring-after(., 'EXT')) &lt; parent::extract/preceding-sibling::extract/@id/number(substring-after(., 'EXT')))
				][
					@id/not(number(substring-after(., 'EXT')) &lt; parent::extract/following-sibling::extract/@id/number(substring-after(., 'EXT')))
				][1]/@id" />
			<sch:let name="next-id" value="concat('EXT', number(substring-after($highest-id, 'EXT')) + 1)" />
			
			<sch:report test="self::extract[@id = current()/preceding-sibling::extract/@id]">Duplicate ID. <sch:value-of select="@id" /> has already been assigned to an extract associated with this source.  Change to <sch:value-of select="$next-id"/></sch:report>
			
			<sch:assert test="self::extract[(pages or link) or ancestor::source/front-matter[descendant::pages or descendant::link]]">Missing location. Either page numbers or a link to the extract must be provided.</sch:assert>
			
		</sch:rule>
		
	</sch:pattern>

	
</sch:schema>