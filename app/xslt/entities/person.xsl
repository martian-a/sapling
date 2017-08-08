<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:person="http://ns.kaikoda.com/personumentation/xml" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
	
	<xsl:template match="/app[view/data/entities/person] | /app[view/data/person]" mode="html.header html.header.scripts html.header.style html.footer.scripts"/>
	
	<xsl:template match="/app/view[data/entities/person]" mode="html.body">
		<xsl:apply-templates select="data/entities[person]"/>
	</xsl:template>
	
	
	<xsl:template match="/app/view[data/person]" mode="html.body">
		<xsl:apply-templates select="data/person"/>
	</xsl:template>
	
	
	
	<xsl:template match="/app/view[data/entities/person]" mode="view.title">
		<xsl:text>People</xsl:text>
	</xsl:template>
	
	
	<xsl:template match="/app/view[data/person]" mode="view.title">
		<xsl:apply-templates select="data/person/persona[1]/name"/>
	</xsl:template>
	
	<xsl:template match="/app/view/data/person/persona/name">
		<xsl:value-of select="string-join(name, ' ')"/>
	</xsl:template>
	
	
	<xsl:template match="data/entities[person]">
		<ul>
			<xsl:apply-templates>
				<xsl:sort select="name/string-join(name[@family = 'yes'], ' ')" data-type="text" order="ascending"/>
				<xsl:sort select="name/string-join(name[not(@family = 'yes')], ' ')" data-type="text" order="ascending"/>	
				<xsl:sort select="@year" data-type="number" order="ascending"/>
			</xsl:apply-templates>
		</ul>
	</xsl:template>
	
	
	<xsl:template match="person/persona">
		<div class="persona">
			<xsl:if test="preceding-sibling::persona">
				<h2>
                    <xsl:apply-templates select="name"/>
                </h2>
			</xsl:if>
			<p class="gender">
                <span class="label">Gender: </span>
                <xsl:apply-templates select="gender"/>
            </p>
			<xsl:apply-templates select="notes"/>
		</div>
	</xsl:template>
	
	<xsl:template match="person/notes">
		<div class="notes">
			<h2>Notes</h2>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	
	<xsl:template match="notes/p">
		<p>
            <xsl:apply-templates/>
        </p>
	</xsl:template>
	
	
	<xsl:template match="person/name" mode="href-html">
		<xsl:variable name="name" select="string-join(name, ' ')" as="xs:string?"/>
		<xsl:choose>
			<xsl:when test="$name = ''">[Unknown]</xsl:when>
			<xsl:otherwise>
                <xsl:value-of select="$name"/>
            </xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<xsl:template match="entities/person">
		<li>
			<xsl:apply-templates select="self::*" mode="href-html"/>
		</li>
	</xsl:template>
	
	
	<xsl:template match="person" mode="href-html">
		<xsl:call-template name="href-html">
			<xsl:with-param name="path" select="concat('person/', @ref)" as="xs:string"/>
			<xsl:with-param name="content" as="item()">
				<xsl:apply-templates select="name" mode="href-html"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
</xsl:stylesheet>