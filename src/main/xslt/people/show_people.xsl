<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://ns.kaikoda.com/xslt/functions"
    exclude-result-prefixes="xs fn"
    version="2.0">
    
    <xsl:import href="../global.xsl" />
    <xsl:import href="person.xsl"/>
    
    <xsl:param name="root-publication-directory" select="''" />
    
    <xsl:variable name="primary-doc" select="/sapling" /> 
    
    <xsl:template match="/">
        <xsl:apply-templates select="sapling" />
    </xsl:template>
    
    <xsl:template match="sapling">
        <xsl:apply-templates select="people" mode="index" />
    </xsl:template>
    
    <xsl:template match="people" mode="index">
        <xsl:variable name="publication-path" select="concat($root-publication-directory, 'people/index.html')" />
        
        <sapling>
            <link href="{$publication-path}" />
        </sapling>
        
        <xsl:result-document href="{$publication-path}" format="xhtml" encoding="utf-8">
            <html>
                <head>
                    <title>People</title>             
                </head>
                <body>
                    <article>
                        <section class="header">
                            <h1>People</h1>                
                        </section>
                        <xsl:if test="person">
                            <section class="list">
                                <table>
                                    <caption>People</caption>
                                    <thead>
                                        <tr>
                                            <th class="person" rowspan="2">Person</th>
                                            <th class="birth" colspan="2">Born</th>
                                            <th class="death" colspan="2">Died</th>
                                        </tr>
                                        <tr>
                                            <th class="birth-date">Date<a class="footnote-ref" href="#footnote-birth-date">*</a></th>
                                            <th class="birth-location">Location</th>
                                            <th class="death-date">Date</th>
                                            <th class="death-location">Location</th>
                                        </tr>                        
                                    </thead>
                                    <tbody>
                                        <xsl:for-each-group select="person/persona" group-by="ancestor::person[1]/@year">
                                            <xsl:sort select="current-grouping-key()" data-type="number" order="ascending" />
                                            <xsl:apply-templates select="current-group()[not(name/name/@family = 'yes')]" mode="index-entry">
                                                <xsl:sort select="name" data-type="text" order="ascending" />
                                            </xsl:apply-templates>
                                            <xsl:for-each-group select="current-group()[name/name/@family = 'yes']" group-by="name/name[@family = 'yes']">
                                                <xsl:sort select="current-grouping-key()" data-type="text" order="ascending" />
                                                <xsl:apply-templates select="current-group()[count(name/name[not(@family = 'yes')]) &lt; 2]" mode="index-entry">
                                                    <xsl:sort select="name" data-type="text" order="ascending" />
                                                </xsl:apply-templates>
                                                <xsl:apply-templates select="current-group()[count(name/name[not(@family = 'yes')]) &gt; 1]" mode="index-entry">
                                                    <xsl:sort select="name" data-type="text" order="ascending" />
                                                </xsl:apply-templates>
                                            </xsl:for-each-group>
                                        </xsl:for-each-group>                                        
                                    </tbody>
                                </table>
                            </section>
                        </xsl:if>
                        <section class="footnotes">
                            <h1>Footnotes</h1>
                            <section id="footnote-birth-date">
                                <h1>*</h1>
                                <p>In order to make it easier to differentiate between people in indices, if someone's actual birth date is not known an estimate is used instead.</p>
                            </section>
                        </section>
                    </article>
                </body>
            </html>        
        </xsl:result-document>
    </xsl:template>
    
    
    <xsl:template match="persona" mode="index-entry">
        <xsl:variable name="person-id" select="ancestor::person[1]/@id" />
        <tr>
            <td class="person"><xsl:apply-templates select="self::persona" /></td>
            <td class="birth-date"><xsl:apply-templates select="ancestor::person[1]" mode="birth-year-approx" /></td>
            <td class="birth-location"><xsl:apply-templates select="/sapling/events/event[person/@ref = $person-id][@type = 'birth']/location" /></td>
            <td class="death-date"><xsl:apply-templates select="ancestor::person[1]" mode="death-year" /></td>
            <td class="death-location"><xsl:apply-templates select="/sapling/events/event[person/@ref = $person-id][@type = 'death']/location" /></td>
        </tr>
    </xsl:template>
    
</xsl:stylesheet>