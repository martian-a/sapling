<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://ns.kaikoda.com/xslt/functions"
    exclude-result-prefixes="xs fn"
    version="2.0">
   
    <xsl:import href="../global.xsl" />
    <xsl:import href="person.xsl"/>       
    
    <xsl:param name="root-publication-directory" select="''" />
    
    <xsl:variable name="person-id" select="/sapling/person/@id" />
    <xsl:variable name="primary-doc" select="/sapling" /> 
    
    <xsl:template match="/">
        <xsl:apply-templates select="sapling" />
    </xsl:template>
    
    <xsl:template match="sapling">
        <xsl:apply-templates select="person" mode="profile" />
    </xsl:template>
    
    <xsl:template match="person" mode="profile">
    	<xsl:variable name="publication-path" select="concat($root-publication-directory, 'people/', fn:getPersonId(@id), '.html')" />
    
    	<sapling>
    		<link href="{$publication-path}" />
    	</sapling>
    
        <xsl:result-document href="{$publication-path}" format="xhtml" encoding="utf-8">
            <html>
                <head>
                    <title><xsl:apply-templates select="persona[1]/name" /></title>             
                </head>
                <body>
                    <article>
                        <section class="personas">
                            <xsl:apply-templates select="persona" />
                        </section>
                    	<xsl:if test="related/events/event[@type = ('marriage', 'birth')]">
                    		<section class="family">
                    			<xsl:apply-templates select="self::person[related/events/event[@type = 'birth'][person/@ref = $person-id]]" mode="family.parents" />
                    		    <xsl:apply-templates select="self::person[related/events/event[@type = 'marriage'][person/@ref = $person-id]]" mode="family.partners" />
                    		    <xsl:apply-templates select="self::person[related/events/event[@type = 'birth'][parent/@ref = $person-id]]" mode="family.children" />
                    		</section>
                    	</xsl:if>
                        <xsl:if test="related/events/event">
                            <section class="timeline">
                                <table>
                                    <caption>Timeline</caption>
                                    <thead>
                                        <tr>
                                            <th class="year">Year</th>
                                            <th class="month">Month</th>
                                            <th class="day">Day</th>
                                            <th class="location">Location</th>
                                            <th class="description">Event</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <xsl:apply-templates select="related/events/event">
                                        	<xsl:sort select="date/@year" data-type="number" order="ascending" />
                                        	<xsl:sort select="date/@month" data-type="number" order="ascending" />
                                        	<xsl:sort select="date/@day" data-type="number" order="ascending" />
                                        </xsl:apply-templates>
                                    </tbody>
                                </table>
                            </section>
                        </xsl:if>
                        <xsl:apply-templates select="notes" />
                    </article>
                </body>
            </html>        
        </xsl:result-document>
    </xsl:template>
    
    
    <xsl:template match="persona">
        <section class="persona">
            <h1><xsl:apply-templates select="name" /></h1>
            <xsl:apply-templates select="gender" />
        </section>
    </xsl:template>
    
    <xsl:template match="person" mode="family.parents">
        <xsl:variable name="parents" as="document-node()">
            <xsl:document>
                <list>
                    <xsl:for-each select="related/events/event[@type = 'birth'][person/@ref = $person-id]">
                        <xsl:sort select="date/@year" data-type="number" order="ascending" />
                        <xsl:sort select="date/@month" data-type="number" order="ascending" />
                        <xsl:sort select="date/@day" data-type="number" order="ascending" />
                        <xsl:copy-of select="parent" />/>
                    </xsl:for-each>
                </list>
            </xsl:document>
        </xsl:variable>        
        
        <xsl:if test="$parents/list/*">
            <section class="parents">
                <h1>Parents</h1>
                <ul>
                    <xsl:for-each select="$parents/list/*">
                        <li><xsl:apply-templates select="." /></li>
                    </xsl:for-each>
                </ul>
            </section>
        </xsl:if>		       
    </xsl:template>
    
    <xsl:template match="person" mode="family.partners">
        <xsl:variable name="partners" as="document-node()">
            <xsl:document>
                <list>
                    <xsl:for-each select="related/events/event[@type = 'marriage'][person/@ref = $person-id]">
                        <xsl:sort select="date/@year" data-type="number" order="ascending" />
                        <xsl:sort select="date/@month" data-type="number" order="ascending" />
                        <xsl:sort select="date/@day" data-type="number" order="ascending" />						
                        <xsl:copy-of select="person[@ref != $person-id]" />
                    </xsl:for-each>
                </list>
            </xsl:document>
        </xsl:variable>        
        
        <xsl:if test="$partners/list/*">
            <section class="partners">
                <h1>Partners</h1>
                <ul>
                    <xsl:for-each select="$partners/list/*">
                        <li><xsl:apply-templates select="." /></li>
                    </xsl:for-each>
                </ul>
            </section>
        </xsl:if>		       
    </xsl:template>	
    
    <xsl:template match="person" mode="family.children">
        <xsl:variable name="children" as="document-node()">
            <xsl:document>
                <list>
                    <xsl:for-each select="related/events/event[@type = 'birth'][parent/@ref = $person-id]">
                        <xsl:sort select="date/@year" data-type="number" order="ascending" />
                        <xsl:sort select="date/@month" data-type="number" order="ascending" />
                        <xsl:sort select="date/@day" data-type="number" order="ascending" />
                        <xsl:sort select="$primary-doc/related/people/person[@id = current()/person/@ref]/@year" data-type="number" order="ascending" />
                        <xsl:copy-of select="person" />
                    </xsl:for-each>										
                </list>
            </xsl:document>
        </xsl:variable>        
        
        <xsl:if test="$children/list/*">
            <section class="children">
                <h1>Children</h1>
                <ul>
                    <xsl:for-each select="$children/list/*">
                        <li><xsl:apply-templates select="." /></li>
                    </xsl:for-each>
                </ul>
            </section>
        </xsl:if>		       
    </xsl:template>
    
    
    <xsl:template match="related/events/event">
        <tr>
            <td class="year"><xsl:value-of select="date/@year" /></td>
            <td class="month"><xsl:value-of select="fn:getShortMonthName(date/@month)" /></td>
            <td class="day"><xsl:value-of select="date/@day" /></td>
            <td class="location"><xsl:apply-templates select="ancestor::related[1]/locations/location[@id = current()/location/@ref]" /></td>
            <td class="description"><xsl:apply-templates select="." mode="description" /></td>
        </tr>
    </xsl:template>
    
    <xsl:template match="person/notes">
        <section class="notes">
            <xsl:apply-templates />
        </section>
    </xsl:template>
    
    
</xsl:stylesheet>