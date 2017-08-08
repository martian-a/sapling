<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xs"
	version="2.0">
	
	<xsl:output encoding="UTF-8" indent="yes"></xsl:output>
	
	<xsl:template match="/">
		<names>
			<xsl:for-each-group select="people/person/persona/name/name" group-by="translate(lower-case(.), '.', '')">
				<xsl:sort select="current-grouping-key()" data-type="text" order="ascending"></xsl:sort>
				<xsl:variable name="normalised" select="if (current-grouping-key() = '') then '[unknown]' else current-grouping-key()" as="xs:string" />
				<xsl:variable name="name" as="xs:string">
					<xsl:choose>
						<xsl:when test="current-group()[1] = ''">[Unknown]</xsl:when>
						<xsl:when test="ends-with(current-group()[1], '.')"><xsl:value-of select="substring(current-group()[1], 1, string-length(current-group()[1]) - 1)" /></xsl:when>
						<xsl:otherwise><xsl:value-of select="current-group()[1]" /></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<name id="{$normalised}">
					<xsl:if test="ends-with(current-group()[1], '.')">
						<xsl:attribute name="abbreviation">true</xsl:attribute>
					</xsl:if>
					<name><xsl:value-of select="$name" /></name>
					<xsl:for-each-group select="current-group()/ancestor::person" group-by="@id">
						<person ref="{current-grouping-key()}" />		
					</xsl:for-each-group>
				</name>
			</xsl:for-each-group>
		</names>
	</xsl:template>
	
</xsl:stylesheet>