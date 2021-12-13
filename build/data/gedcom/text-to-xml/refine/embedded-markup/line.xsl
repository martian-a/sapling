<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="2.0">
    
    <xsl:import href="../../../../../utils/identity.xsl" />
    
	<xsl:template match="text()[contains(., '&lt;/line') or contains(., '&lt;line /&gt;')]">
		<xsl:value-of select="replace(replace(replace(., '&lt;/line&gt;', codepoints-to-string(10)), '&lt;line&gt;', ''), '&lt;line /&gt;', '')" />
	</xsl:template>
    
</xsl:stylesheet>