<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:doc="http://ns.kaikoda.com/documentation/xml"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://ns.thecodeyard.co.uk/functions"
    exclude-result-prefixes="#all"
    version="2.0">
    
    <xsl:output encoding="UTF-8" indent="yes" />
    <xsl:strip-space elements="*" />
    
   
    <xsl:template match="/">
    	<xsl:call-template name="re-include-referenced-entities">
    		<xsl:with-param name="latest-result" as="document-node()">
    			<xsl:apply-templates select="self::document-node()" mode="re-include-events" />
    		</xsl:with-param>
    		<xsl:with-param name="iteration" select="1" as="xs:integer" />
    	</xsl:call-template>
    </xsl:template>
	
	<xsl:template match="/data/include" mode="re-include-events">
		<xsl:copy>
			<xsl:apply-templates select="@*, node()" mode="#current" />
			<events>
				<xsl:copy-of select="/data/exclude/events/event[*[name() = ('person', 'parent')]/@ref = /data/include/people/person/@id]" />
			</events>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="/data/exclude/events/event[*[name() = ('person', 'parent')]/@ref = /data/include/people/person/@id]" mode="re-include-events" />
	
	
	<xsl:template name="re-include-referenced-entities">
		<xsl:param name="latest-result" as="document-node()" />
		<xsl:param name="iteration" as="xs:integer" />
		
		<xsl:variable name="re-include" select="$latest-result/data/include/descendant::*/@ref[. = $latest-result/data/exclude/*/*/@id]" as="xs:string*" />
		
		<xsl:choose>
			<xsl:when test="count($re-include) &gt; 0">
				<xsl:call-template name="re-include-referenced-entities">
					<xsl:with-param name="latest-result" as="document-node()">
						<xsl:apply-templates select="$latest-result" mode="re-include-referenced-entities">
							<xsl:with-param name="re-include" select="$re-include" as="xs:string*" tunnel="yes" />
							<xsl:with-param name="iteration" select="$iteration + 1" as="xs:integer" tunnel="yes" />
						</xsl:apply-templates>
					</xsl:with-param>
					<xsl:with-param name="iteration" select="$iteration + 1" />
				</xsl:call-template>
			</xsl:when>			
			<xsl:otherwise>
				<xsl:copy-of select="$latest-result" />
			</xsl:otherwise>		
		</xsl:choose>
		
	</xsl:template>
	
	
	<xsl:template match="/data/include" mode="re-include-referenced-entities">
		<xsl:param name="iteration" as="xs:integer" tunnel="yes" />
		<xsl:param name="re-include" as="xs:string*" tunnel="yes" />
		
		<xsl:copy>
			<xsl:apply-templates select="@*, node()" mode="#current" />	
			<xsl:for-each-group select="ancestor::data/exclude/*/*[@id = $re-include]" group-by="name()">
				<xsl:element name="{current-group()[1]/parent::*/name()}">
					<xsl:copy-of select="current-group()" />
				</xsl:element>
			</xsl:for-each-group>								
		</xsl:copy>
		
	</xsl:template>
	
	
	<xsl:template match="/data/exclude/*/*[@id]" mode="re-include-referenced-entities">	
		<xsl:param name="re-include" as="xs:string*" tunnel="yes" />
		
		<xsl:choose>
			<xsl:when test="self::*[@id = $re-include]" />
			<xsl:otherwise>
				<xsl:copy-of select="self::*" />
			</xsl:otherwise>
		</xsl:choose>		
		
	</xsl:template>	
	
	
	<xsl:template match="element()" mode="#all">
		<xsl:copy copy-namespaces="no"><xsl:apply-templates select="attribute(), node()" mode="#current" /></xsl:copy>
	</xsl:template>
	
	<xsl:template match="processing-instruction() | comment() | attribute() | text()" mode="#all">
		<xsl:copy><xsl:apply-templates select="node()" mode="#current" /></xsl:copy>
	</xsl:template>
	
	<xsl:template match="document-node()" mode="re-include-referenced-entities re-include-events">
		<xsl:document>
			<xsl:apply-templates select="node()" mode="#current" />
		</xsl:document>
	</xsl:template>	
	
</xsl:stylesheet>