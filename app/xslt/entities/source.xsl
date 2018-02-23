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
        <doc:desc>Suppress for the time being.</doc:desc>
    </doc:doc>
    <xsl:template match="/app/view[data/source]" mode="view.title" />
    
    
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
            
            <xsl:variable name="bibliography" as="document-node()">
                <xsl:document>
                    <bibliography>
                        <xsl:for-each select="source">
                            <source><xsl:apply-templates select="self::source" mode="bibliography" /></source>
                        </xsl:for-each>
                    </bibliography>
                </xsl:document>
            </xsl:variable>
            
            <xsl:variable name="filter" select="tokenize(translate(upper-case($bibliography), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', ''), '.')" as="xs:string*" />
            
            <xsl:variable name="entries" as="element()*">
                <xsl:for-each-group select="$bibliography/bibliography/source" group-by="translate(substring(., 1, 1), $filter, '') = ''">
                    <xsl:choose>
                        <xsl:when test="current-grouping-key() = true()">
                            <xsl:call-template name="generate-jump-navigation-group">
                                <xsl:with-param name="group" select="current-group()" as="element()*" />
                                <xsl:with-param name="key" select="''" as="xs:string" />
                                <xsl:with-param name="misc-match-test" select="''" as="xs:string" />
                                <xsl:with-param name="misc-match-label" select="'Miscellaneous'" as="xs:string" />
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:for-each-group select="current-group()" group-by="substring(upper-case(.), 1, 1)">
                                <xsl:sort select="current-grouping-key()" data-type="text" order="ascending" />
                                <xsl:call-template name="generate-jump-navigation-group">
                                    <xsl:with-param name="group" select="current-group()" as="element()*" />
                                    <xsl:with-param name="key" select="current-grouping-key()" as="xs:string" />
                                    <xsl:with-param name="misc-match-test" select="''" as="xs:string" />
                                    <xsl:with-param name="misc-match-label" select="'Unattributed'" as="xs:string" />
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
        <li><xsl:copy-of select="node()" /></li>
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
        <doc:desc>Bibliographic entry for a non-serial source.</doc:desc>
    </doc:doc>
    <xsl:template match="source[front-matter/not(journal)]" mode="bibliography">
        <span class="non-serial">
            <xsl:apply-templates select="front-matter[author]" mode="bibliography.authors" />
            <xsl:apply-templates select="front-matter[title]" mode="bibliography.title" />
            <xsl:apply-templates select="front-matter/series" mode="bibliography.series" />
            <xsl:apply-templates select="front-matter[location]" mode="bibliography.location" />
            <xsl:apply-templates select="front-matter" mode="bibliography.publisher" />
            <xsl:apply-templates select="front-matter[date/@rel = ('published', 'revised')]" mode="bibliography.date" />
        </span>
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Bibliographic entry for a serial source.</doc:desc>
    </doc:doc>
    <xsl:template match="source[front-matter/journal]" mode="bibliography">
        <span class="serial">
            <xsl:apply-templates select="front-matter[author]" mode="bibliography.authors" />
            <xsl:apply-templates select="front-matter[title]" mode="bibliography.article.title" />
            <xsl:apply-templates select="front-matter/journal/title" mode="bibliography.journal.title" />
            <xsl:apply-templates select="front-matter/journal/issue" mode="bibliography.journal.issue" />
        </span>
    </xsl:template>
    
    
    
    
    <doc:doc>
        <doc:desc>Preface a bilbiographic entry with it's authors.</doc:desc>
    </doc:doc>
   <xsl:template match="source/front-matter" mode="bibliography.authors">
      
        <xsl:choose>
            <xsl:when test="count(author) &gt; 5">
                <xsl:apply-templates select="author[1]" mode="#current" />
                <xsl:text> et al</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="author" mode="#current" />
            </xsl:otherwise>
        </xsl:choose>       
        <xsl:text>. </xsl:text>
   </xsl:template>
    
    
    <doc:doc>
        <doc:desc>The first author in a bibliography entry.</doc:desc>
    </doc:doc>
    <xsl:template match="author[position() = 1]" mode="bibliography.authors">
        <xsl:apply-templates select="name" mode="#current" />
    </xsl:template>    
    
    
    <doc:doc>
        <doc:desc>Authors (other than the first) in a bibliography entry.</doc:desc>
    </doc:doc>
    <xsl:template match="author[position() &gt; 1]" mode="bibliography.authors">
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
        <doc:desc>Wrap the name of an author in a span.</doc:desc>
    </doc:doc>   
    <xsl:template match="author/name" mode="bibliography.authors" priority="10">
        <span class="author">
            <xsl:next-match />
        </span>
    </xsl:template>   
       
    
    <doc:doc>
        <doc:desc>Format the name of the first author.</doc:desc>
    </doc:doc>
    <xsl:template match="author[1]/name" mode="bibliography.authors">
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
    <xsl:template match="author[position() &gt; 1]/name" mode="bibliography.authors">
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
    <xsl:template match="name/name[@family = 'yes']" mode="bibliography.authors">
        <span class="family-name"><xsl:value-of select="." /></span>    
   </xsl:template>
   
   
    <doc:doc>
        <doc:desc>Format the forenames of an author.</doc:desc>
    </doc:doc>
    <xsl:template match="name/name[not(@family = 'yes')]" mode="bibliography.authors">
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
    <xsl:template match="source/front-matter[journal][title]" mode="bibliography.article.title" priority="50">
        <xsl:value-of select="$ldquo" /><xsl:next-match /><xsl:text>.</xsl:text><xsl:value-of select="$rdquo" /><xsl:text> </xsl:text>
    </xsl:template>  
    
    
    <doc:doc>
        <doc:desc>Append a full stop to the end of the title sequence of a non-serial source.</doc:desc>
    </doc:doc>
    <xsl:template match="source/front-matter[not(journal)][title]" mode="bibliography.title" priority="50">
        <xsl:next-match /><xsl:text>. </xsl:text>
    </xsl:template>  


    <doc:doc>
        <doc:desc>Include the source title in a bilbiographic entry.</doc:desc>
    </doc:doc>
   <xsl:template match="source/front-matter[title]" mode="bibliography.title bibliography.article.title">
       <xsl:choose>
           <xsl:when test="title[@xml:lang = 'en']">
               <xsl:apply-templates select="title[@xml:lang = 'en'][1]" mode="#current" />
           </xsl:when>
           <xsl:otherwise>
               <xsl:apply-templates select="title[not(@xml:lang)][1]" mode="#current" />
           </xsl:otherwise>
       </xsl:choose>
       <xsl:if test="subtitle">
           <xsl:text>: </xsl:text>
           <xsl:choose>
               <xsl:when test="subtitle[@xml:lang = 'en']">
                   <xsl:apply-templates select="subtitle[@xml:lang = 'en'][1]" mode="#current" />
               </xsl:when>
               <xsl:otherwise>
                   <xsl:apply-templates select="subtitle[not(@xml:lang)][1]" mode="#current" />
               </xsl:otherwise>
           </xsl:choose>
       </xsl:if>
   </xsl:template>
        
        
    <doc:doc>
        <doc:desc>Format the title of non-serial source or serial article.</doc:desc>
    </doc:doc>
    <xsl:template match="source/front-matter/title" mode="bibliography.title bibliography.article.title"> 
       <span class="title"><xsl:copy-of select="node()" /></span>
    </xsl:template>   
    
    
    <doc:doc>
        <doc:desc>Format the subtitle of non-serial source or serial article.</doc:desc>
    </doc:doc>
    <xsl:template match="source/front-matter/subtitle" mode="bibliography.title bibliography.article.title">
        <span class="title subtitle"><xsl:copy-of select="node()" /></span>
    </xsl:template>  


    <xsl:template match="source/front-matter[not(title)]" mode="bibliography.title bibliography.article.title" />
    
    
    <doc:doc>
        <doc:desc>Format the series of non-serial source or serial article.</doc:desc>
    </doc:doc>
    <xsl:template match="source/front-matter/series" mode="bibliography.series">
        <span class="series"><xsl:text>(</xsl:text><xsl:copy-of select="node()" /><xsl:text>). </xsl:text></span>
    </xsl:template>  
    
    
    <doc:doc>
        <doc:desc>Format the title of a journal.</doc:desc>
    </doc:doc>
    <xsl:template match="source/front-matter/journal/title" mode="bibliography.journal.title">
        <span class="serial-title"><xsl:copy-of select="node()" /><xsl:text> </xsl:text></span>
    </xsl:template>  
    
    
    <doc:doc>
        <doc:desc>Serial volume and/or issue.</doc:desc>
    </doc:doc>
    <xsl:template match="front-matter/journal/issue" mode="bibliography.journal.issue">
        <xsl:apply-templates select="volume[normalize-space(@number) != '' or normalize-space(.) != '']" mode="#current" />
        <xsl:if test="volume[normalize-space(@number) = '' and normalize-space(.) != ''] and issue"><xsl:text>, </xsl:text></xsl:if>
        <xsl:apply-templates select="issue" mode="#current" />
        <xsl:text> </xsl:text>
        <xsl:apply-templates select="date" mode="#current" />
        <xsl:apply-templates select="pages" mode="#current" />
    </xsl:template>
    
    
    <xsl:template match="front-matter/journal/issue/volume" mode="bibliography.journal.issue" priority="10">
        <span class="volume"><xsl:next-match /></span>
    </xsl:template>
    
    
    <xsl:template match="front-matter/journal/issue/volume[normalize-space(.) != '']" mode="bibliography.journal.issue">
        <xsl:value-of select="." />
    </xsl:template>
    
    <xsl:template match="front-matter/journal/issue/volume[normalize-space(.) = '']" mode="bibliography.journal.issue">
        <xsl:value-of select="@number" />
    </xsl:template>
    
    <xsl:template match="front-matter/journal/issue/issue" mode="bibliography.journal.issue">
        <span class="issue"><xsl:value-of select="." /></span>
    </xsl:template>
    
    <xsl:template match="front-matter/journal/issue/date" mode="bibliography.journal.issue" priority="50">
        <span class="date">
            <xsl:text>(</xsl:text>
                <xsl:next-match />
            <xsl:text>)</xsl:text></span>
    </xsl:template>
    
    <xsl:template match="front-matter/journal/issue/date[@day and @month and @year]" mode="bibliography.journal.issue">
        <xsl:value-of select="@day" />
        <xsl:text> </xsl:text>
        <xsl:value-of select="substring(fn:month-name(@month), 1, 3)" />
        <xsl:text> </xsl:text>
        <xsl:value-of select="@year" />
    </xsl:template>
    
    
    <xsl:template match="front-matter/journal/issue/date[not(@day) and @month and @year]" mode="bibliography.journal.issue">
        <xsl:value-of select="fn:month-name(@month)" />
        <xsl:text> </xsl:text>
        <xsl:value-of select="@year" />
    </xsl:template>
    
    
    <xsl:template match="front-matter/journal/issue/date[not(@day) and not(@month) and @year]" mode="bibliography.journal.issue">
        <xsl:value-of select="@year" />
    </xsl:template>
    
    
    <xsl:template match="front-matter/journal/issue/pages" mode="bibliography.journal.issue">
        <xsl:text>: </xsl:text><span class="pages"><xsl:apply-templates select="@start" mode="#current" /></span>
    </xsl:template>
    
    <xsl:template match="front-matter/journal/issue/pages/@start" mode="bibliography.journal.issue">
        <xsl:value-of select="." />
        <xsl:apply-templates select="parent::pages/@end[. != current()]" mode="#current" />
    </xsl:template>
    
    <xsl:template match="front-matter/journal/issue/pages/@end" mode="bibliography.journal.issue">
        <xsl:text>-</xsl:text><xsl:value-of select="." />
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Include the location in a bibliography entry.</doc:desc>
    </doc:doc>
    <xsl:template match="source/front-matter" mode="bibliography.location">
        <span class="location"><xsl:value-of select="normalize-space(location)" /></span>
        <xsl:if test="publisher"><xsl:text>: </xsl:text></xsl:if>
    </xsl:template>
    
    
    
    <doc:doc>
        <doc:desc>Format the publisher in a bilbiographic entry.</doc:desc>
    </doc:doc>
    <xsl:template match="source/front-matter" mode="bibliography.publisher" priority="10">
        <span class="publisher"><xsl:next-match /></span>
        <xsl:choose>
            <xsl:when test="date[@rel = ('published', 'revised')]"><xsl:text>, </xsl:text></xsl:when>
            <xsl:otherwise><xsl:text>. </xsl:text></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    
    <doc:doc>
        <doc:desc>Include the publisher in a bilbiographic entry.</doc:desc>
    </doc:doc>
    <xsl:template match="source/front-matter[publisher]" mode="bibliography.publisher">
        <xsl:value-of select="publisher" />
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Indicate that the publisher is not known in a bilbiographic entry.</doc:desc>
    </doc:doc>
    <xsl:template match="source/front-matter[not(publisher)]" mode="bibliography.publisher">
        <xsl:text>n.p.</xsl:text>
    </xsl:template>
    
    
    
    <doc:doc>
        <doc:desc>Include the publication or revision date in a bilbiographic entry.</doc:desc>
    </doc:doc>
    <xsl:template match="source/front-matter[not(journal)][date]" mode="bibliography.date">
        <xsl:apply-templates select="date[@rel = 'published']" mode="#current" />
        <xsl:if test="date[@rel = 'published'] and date[@rel = 'revised']">, </xsl:if>
        <xsl:apply-templates select="date[@rel = 'revised']" mode="#current" />
        <xsl:text>.</xsl:text>
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Include the publication date in a bilbiographic entry.</doc:desc>
    </doc:doc>
    <xsl:template match="source/front-matter[not(journal)]/date" mode="bibliography.date">
        <span class="date {@rel}">
            <xsl:value-of select="if (@year) then @year else ." />
            <xsl:if test="@rel = 'revised'"> (rev)</xsl:if>
        </span>
    </xsl:template>
    
   
</xsl:stylesheet>