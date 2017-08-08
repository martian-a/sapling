<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://ns.thecodeyard.co.uk/functions" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
	
	<xsl:function name="fn:add-trailing-slash" as="xs:string">
		<xsl:param name="string-in" as="xs:string?"/>
		
		<xsl:value-of select="concat($string-in, if (ends-with($string-in, '/')) then '' else '/')"/>
	</xsl:function>
	
</xsl:stylesheet>