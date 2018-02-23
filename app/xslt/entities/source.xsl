<?xml-model href="http://ns.thecodeyard.co.uk/schema/cinnamon.sch?v=0.1.0" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fn="http://ns.thecodeyard.co.uk/functions"
    xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#"
    xmlns:doc="http://ns.kaikoda.com/documentation/xml" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all" 
    version="2.0">
    
    <doc:doc scope="stylesheet">
        <doc:title>Source</doc:title>
        <doc:desc>Templates specific to the source entity.</doc:desc>
    </doc:doc>
    
    
    <doc:doc>
        <doc:desc>Key for looking-up sources by @id.</doc:desc>
    </doc:doc>
    <xsl:key name="source" match="related/source | data/source | entities/source" use="@id" />
    
    
    <doc:doc>
        <doc:desc>
            <doc:ul>
                <doc:ingress>Default match for main modes:</doc:ingress>
                <doc:li>HTML header</doc:li>
                <doc:li>scripts in the header</doc:li>
                <doc:li>style in the header</doc:li>
                <doc:li>scripts in the footer</doc:li>
            </doc:ul>
        </doc:desc>
    </doc:doc>
    <xsl:template match="/app[view/data/entities/source] | /app[view/data/source]" mode="html.header html.header.scripts html.header.style html.footer.scripts"/>
    
    
    <doc:doc>
        <doc:desc>Source index title</doc:desc>
    </doc:doc>
    <xsl:template match="/app/view[data/entities/source]" mode="view.title">
        <xsl:text>Sources</xsl:text>
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Source profile title</doc:desc>
    </doc:doc>
    <xsl:template match="/app/view[data/source]" mode="view.title">
        <xsl:value-of select="xs:string(data/source/reference[1]/titles/title)" />
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Entry point for generating the HTML body of the source index.</doc:desc>
    </doc:doc>
    <xsl:template match="/app/view[data/entities/source]" mode="html.body">
        <xsl:apply-templates select="data/entities[source]"/>
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Entry point for generating the HTML body of a source profile.</doc:desc>
    </doc:doc>
    <xsl:template match="/app/view[data/source]" mode="html.body">
        <xsl:apply-templates select="data/source"/>
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Defines the structure of the HTML body of a source profile.</doc:desc>
    </doc:doc>
    <xsl:template match="data/source">
        <xsl:apply-templates select="related[person]" mode="people" />
        <xsl:apply-templates select="related[organisation]" mode="organisations" />
        <xsl:apply-templates select="related[location]" mode="locations" />
        <xsl:apply-templates select="related[event]" mode="timeline" />
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Source index by title.</doc:desc>
    </doc:doc>
    <xsl:template match="data/entities[source]">
        <div class="nav-index alphabetical" id="nav-bibliography">
            <h2>Bibliography
                <xsl:text> </xsl:text>
                <a href="#top" class="nav" title="Top of page">▴</a></h2>
            
            <xsl:variable name="entries" as="element()*">
                <xsl:for-each-group select="source" group-by="translate(substring(upper-case(reference[@type = 'bibliographic']), 1, 1), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', '') = ''">
                    <xsl:sort select="current-grouping-key()" data-type="text" order="ascending" /> 
                        
                    <xsl:choose>
                        <xsl:when test="current-grouping-key() = false()">
                            
                            <xsl:variable name="sorted-entries" as="element()*">
                                <xsl:for-each select="current-group()">
                                    <xsl:sort select="xs:string(.)" data-type="text" />
                                    <xsl:sequence select="self::*" />
                                </xsl:for-each>
                            </xsl:variable>
                            
                            
                            <xsl:call-template name="generate-jump-navigation-group">
                                <xsl:with-param name="group" select="$sorted-entries" as="element()*" />
                                <xsl:with-param name="key" select="''" as="xs:string" />
                                <xsl:with-param name="misc-match-test" select="''" as="xs:string" />
                                <xsl:with-param name="misc-match-label" select="'Miscellaneous'" as="xs:string" />
                            </xsl:call-template>
                            
                        </xsl:when>
                        <xsl:otherwise>
                            
                            <xsl:for-each-group select="current-group()" group-by="substring(upper-case(reference[@type = 'bibliographic']), 1, 1)">
                                <xsl:sort select="current-grouping-key()" data-type="text" order="ascending" />
                                
                                <xsl:variable name="sorted-entries" as="element()*">
                                    <xsl:for-each select="current-group()">
                                        <xsl:sort select="xs:string(.)" data-type="text" />
                                        <xsl:sequence select="self::*" />
                                    </xsl:for-each>
                                </xsl:variable>
                                
                                
                                <xsl:call-template name="generate-jump-navigation-group">
                                    <xsl:with-param name="group" select="$sorted-entries" as="element()*" />
                                    <xsl:with-param name="key" select="current-grouping-key()" as="xs:string" />
                                    <xsl:with-param name="misc-match-test" select="''" as="xs:string" />
                                    <xsl:with-param name="misc-match-label" select="'Miscellaneous'" as="xs:string" />
                                </xsl:call-template>	
                            </xsl:for-each-group>
                            
                        </xsl:otherwise>
                    </xsl:choose>
                    
                </xsl:for-each-group>
            </xsl:variable>
            
            <xsl:call-template name="generate-jump-navigation">
                <xsl:with-param name="entries" select="$entries" as="element()*" />
                <xsl:with-param name="id" select="'nav-bibliography'" as="xs:string" />
            </xsl:call-template>
           
        </div>         
           
    </xsl:template>
    
    <xsl:template match="group/entries/source">
        <li>
            <xsl:call-template name="href-html">
                <xsl:with-param name="path" select="concat('source/', @id)" as="xs:string"/>
                <xsl:with-param name="content" as="item()*">
                    <xsl:apply-templates select="reference" />
                </xsl:with-param>
            </xsl:call-template>
        </li>
    </xsl:template>
       
    
    <doc:doc>
        <doc:desc>Entry for a source in a list of related sources.</doc:desc>
        <doc:note>Suppressed for time being.</doc:note>
    </doc:doc>
    <xsl:template match="entities/source" />
    
    
    <doc:doc>
        <doc:desc>Matches a reference to a source and generates a link to it's profile page.</doc:desc>
    </doc:doc>
    <xsl:template match="source[@ref]">
        <xsl:apply-templates select="key('source', @ref)" mode="href-html" />
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc></doc:desc>
    </doc:doc>
    <xsl:template match="source" mode="href-html">
        <xsl:param name="inline-value" as="xs:string?" tunnel="yes" />
        
        <xsl:call-template name="href-html">
            <xsl:with-param name="path" select="concat('source/', @id)" as="xs:string"/>
            <xsl:with-param name="content" as="item()">
                <xsl:choose>
                    <xsl:when test="$inline-value != ''">
                        <xsl:value-of select="$inline-value" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="front-matter/title" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    
    
   
    <doc:doc>
        <doc:desc>Preface a bilbiographic entry with it's authors.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference">
        <span class="reference {@type} {@style}">
            <xsl:apply-templates />
        </span>
    </xsl:template>
    
    
    
    
    
    <doc:doc>
        <doc:desc>Preface a bilbiographic entry with it's authors.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference/creators">
        <xsl:apply-templates select="author" />
        <xsl:text>. </xsl:text>
    </xsl:template>
    

    <doc:doc>
        <doc:desc>Append et al where required.</doc:desc>
    </doc:doc>   
    <xsl:template match="source/reference/creators/author[@et-al = 'true']" priority="20">
        <xsl:next-match />
        <xsl:text> </xsl:text><span class="author et-al">et al</span>
    </xsl:template>  
    

    <doc:doc>
        <doc:desc>The first author in a bibliography entry.</doc:desc>
        <doc:note>Surname first, then forenames.</doc:note>
    </doc:doc>
    <xsl:template match="source/reference/creators/author[position() = 1]">
        <xsl:apply-templates select="name" mode="#current" />
    </xsl:template>    
    
 
    
    
    <doc:doc>
        <doc:desc>Authors (other than the first) in a bibliography entry.</doc:desc>
        <doc:note>Fornames first, then surname.</doc:note>
    </doc:doc>
    <xsl:template match="source/reference/creators/author[position() &gt; 1]">
        <xsl:choose>
            <xsl:when test="following-sibling::author">
                <xsl:text>, </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text> and </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates select="name" mode="#current" />
    </xsl:template>
    
       
       
    <doc:doc>
        <doc:desc>Wrap the name of each author in a span.</doc:desc>
    </doc:doc>   
    <xsl:template match="source/reference/creators/author/name" priority="10">
        <span class="author">
            <xsl:next-match />
        </span>
    </xsl:template>  
       
    
    <doc:doc>
        <doc:desc>Format the name of the first author.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference/creators/author[1]/name">
        <!-- Surname -->
        <xsl:apply-templates select="name[@family = 'yes']" mode="#current" />
        <!-- Comma and non-breaking space -->
        <xsl:text>,</xsl:text><xsl:value-of select="codepoints-to-string(160)" />
        <!-- Forename(s) -->
        <xsl:apply-templates select="name[not(@family = 'yes')]" mode="#current" />
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Format the name of an author other than the first author.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference/creators/author[position() &gt; 1]/name">
        <!-- Forename(s) -->
        <xsl:apply-templates select="name[not(@family = 'yes')]" mode="#current" />
        <!-- Non-breaking space -->
        <xsl:value-of select="codepoints-to-string(160)" />
        <!-- Surname -->
        <xsl:apply-templates select="name[@family = 'yes']" mode="#current" />        
    </xsl:template>
    
   
    <doc:doc>
        <doc:desc>Format the surname of an author.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference/creators/author/name/name[@family = 'yes']">
        <span class="family-name"><xsl:value-of select="." /></span>    
   </xsl:template>
   
   
    <doc:doc>
        <doc:desc>Format the forenames of an author.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference/creators/author/name/name[not(@family = 'yes')]">
        <xsl:choose>
            <xsl:when test="position() = 1">
                <span class="forename"><xsl:value-of select="." /></span>                  
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="position() = 2"><xsl:text> </xsl:text></xsl:if>
                <span class="initial"><xsl:value-of select="substring(upper-case(.), 1, 1)" /></span>  
                <xsl:if test="following-sibling::name[not(@family = 'yes')] or ancestor::author[1][following-sibling::author]">
                    <xsl:text>.</xsl:text>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    
    
    
   
    <doc:doc>
        <doc:desc>Format the title of serial source.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference[@style = ('journal', 'newspaper')]/titles/title" priority="50">
        <xsl:value-of select="$ldquo" /><xsl:next-match /><xsl:text>.</xsl:text><xsl:value-of select="$rdquo" /><xsl:text> </xsl:text>
    </xsl:template>  
    
    
    <doc:doc>
        <doc:desc>Append a full stop to the end of the title sequence of a book reference.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference[@style = 'book']/titles" priority="50">
        <xsl:next-match /><xsl:text>. </xsl:text>
    </xsl:template>  

        
    <doc:doc>
        <doc:desc>Format the title of non-serial source or serial article.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference/titles/title" priority="20"> 
       <span class="title"><xsl:next-match /></span>
    </xsl:template>   
    
    
    <doc:doc>
        <doc:desc>Format the title of a journal.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference/journal/title" priority="30">
        <span class="journal-title"><xsl:next-match /></span>
    </xsl:template>  
    
    
    <doc:doc>
        <doc:desc>Append a space after a journal title.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference[@style = 'journal']/journal/title" priority="20">
        <xsl:next-match /><xsl:text> </xsl:text>
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Wrap an inferred title in square brackets.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference/titles/title[@status = 'inferred']" priority="10"> 
        <xsl:text>[</xsl:text><xsl:next-match /><xsl:text>]</xsl:text>
    </xsl:template>   
    
    <doc:doc>
        <doc:desc>Output a source or journal title.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference/titles/title | source/reference/journal/title"> 
        <xsl:value-of select="node()" />
    </xsl:template> 
    
    
    <doc:doc>
        <doc:desc>Format the subtitle of non-serial source or serial article.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference/titles/subtitle">
        <xsl:text>: </xsl:text>
        <span class="title subtitle"><xsl:copy-of select="node()" /></span>
    </xsl:template>  
    
    
    <doc:doc>
        <doc:desc>Format the series of non-serial source or serial article.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference/series">
        <span class="series"><xsl:text>(</xsl:text><xsl:copy-of select="node()" /><xsl:text>). </xsl:text></span>
    </xsl:template>  
    
    
    <doc:doc>
        <doc:desc>Format the serial volume, issue and date of a journal.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference[@style = 'journal']/journal/issue">
        <xsl:apply-templates select="volume[normalize-space(@number) != '' or normalize-space(.) != '']" mode="#current" />
        <xsl:if test="volume[normalize-space(@number) = '' and normalize-space(.) != ''] and issue"><xsl:text>, </xsl:text></xsl:if>
        <xsl:apply-templates select="issue" mode="#current" />
        <xsl:text> </xsl:text>
        <xsl:apply-templates select="date" mode="#current" />
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Format the volume of serial source.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference/journal/issue/volume" priority="10">
        <span class="volume"><xsl:next-match /></span>
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Output a custom volume label.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference/journal/issue/volume[normalize-space(.) != '']">
        <xsl:value-of select="." />
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Output a standard numbered volume label.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference/journal/issue/volume[normalize-space(.) = '']">
        <xsl:value-of select="@number" />
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Format the issue of serial source.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference/journal/issue/issue">
        <span class="issue"><xsl:value-of select="." /></span>
    </xsl:template>
        
    
    <doc:doc>
        <doc:desc>Prepend a colon before journal page numbers.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference[@style = 'journal']/journal/pages" priority="10">
        <xsl:text>: </xsl:text><xsl:next-match />
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Prepend a comma before newspaper page numbers.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference[@style = 'newspaper']/journal/pages" priority="10">
        <xsl:text>, </xsl:text><xsl:next-match />
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Format the page numbers of serial source.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference/journal/pages">
        <span class="pages"><xsl:apply-templates select="@start" mode="#current" /></span>
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Format the starting page number of serial source.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference/journal/pages/@start">
        <xsl:value-of select="." />
        <xsl:apply-templates select="parent::pages/@end[. != current()]" mode="#current" />
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Format the end page number of serial source.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference/journal/pages/@end">
        <xsl:text>-</xsl:text><xsl:value-of select="." />
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Include the location in a bibliography entry.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference/location">
        <span class="location"><xsl:value-of select="normalize-space(.)" /></span>
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Format the publisher in a bilbiographic entry.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference/publisher" priority="10">
        <span class="publisher"><xsl:next-match /></span>
        <xsl:choose>
            <xsl:when test="following-sibling::date[@rel = ('published', 'revised')]"><xsl:text>, </xsl:text></xsl:when>
            <xsl:otherwise><xsl:text>. </xsl:text></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Include the publisher in a bilbiographic entry.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference/publisher">
        <xsl:if test="preceding-sibling::location"><xsl:text>: </xsl:text></xsl:if>
        <xsl:value-of select="." />
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Include the publication or revision date in a book reference.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference[@style = 'book']/date">
        <span class="date {@rel}">
            <xsl:value-of select="if (@year) then @year else ." />
            <xsl:if test="@rel = 'revised'"> (rev)</xsl:if>
        </span>
        <xsl:choose>
            <xsl:when test="following-sibling::date">
                <xsl:text>, </xsl:text>
            </xsl:when>
            <xsl:otherwise>.</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Include the publication or revision date in a newspaper reference.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference[@style = 'newspaper']/journal/issue/date" priority="50">
        <xsl:text>, </xsl:text>
        <span class="date published">
            <xsl:next-match />
        </span>
    </xsl:template>
        
    
    <doc:doc>
        <doc:desc>Include the publication or revision date in a journal reference.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference[@style = 'journal']/journal/issue/date" priority="50">
        <span class="date published">
            <xsl:text>(</xsl:text>
            <xsl:next-match />
            <xsl:text>)</xsl:text></span>
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Format the publication date in a newspaper reference.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference[@style = 'newspaper']/journal/issue/date[@day and @month and @year]">
        <xsl:value-of select="substring(fn:month-name(@month), 1, 3)" />
        <xsl:text> </xsl:text>
        <xsl:value-of select="@day" />
        <xsl:text>, </xsl:text>
        <xsl:value-of select="@year" />
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Format the publication date in a serial reference (other than a newspaper) when day, month and year are all present.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference[not(@style = 'newspaper')]/journal/issue/date[@day and @month and @year]">
        <xsl:value-of select="@day" />
        <xsl:text> </xsl:text>
        <xsl:value-of select="substring(fn:month-name(@month), 1, 3)" />
        <xsl:text> </xsl:text>
        <xsl:value-of select="@year" />
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Format the publication date for a serial reference (other than a newspaper) when only month and year are present.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference/journal/issue/date[not(@day) and @month and @year]">
        <xsl:value-of select="fn:month-name(@month)" />
        <xsl:text> </xsl:text>
        <xsl:value-of select="@year" />
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Format the publication date for a serial reference (other than a newspaper) when only year is present.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference/journal/issue/date[not(@day) and not(@month) and @year]">
        <xsl:value-of select="@year" />
    </xsl:template>
    
   
</xsl:stylesheet>