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
    
    <xsl:key name="note" match="notes[ancestor::source]/note[@id]" use="@id" />
    
    
    <xsl:include href="../custom/bibliography.xsl" />
    <xsl:include href="../custom/body-matter.xsl" />
    
    
    <doc:doc>
        <doc:desc>
            <doc:ul>
                <doc:ingress>Default match for main modes:</doc:ingress>
                <doc:li>HTML header</doc:li>
                <doc:li>scripts in the html header</doc:li>
                <doc:li>scripts at the foot of the html document</doc:li>
            </doc:ul>
        </doc:desc>
    </doc:doc>
    <!-- xsl:template match="/app[view/data/entities/source] | /app[view/data/source]" mode="html.header html.header.scripts html.footer.scripts"/ -->
    
    
    <doc:doc>
        <doc:desc>Import a style rules specific to sources (in the HTML header).</doc:desc>
    </doc:doc>
    <xsl:template match="/app[view/data/source] | /app[view/data/entities/source]" mode="html.header.style">
        <link href="{$normalised-path-to-css}source.css" type="text/css" rel="stylesheet" /> 
    </xsl:template>
    
    
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
        <xsl:variable name="title">
            <xsl:apply-templates select="data/source/reference[@type = 'bibliographic']/titles/title" mode="view.title" />
        </xsl:variable>
        <xsl:value-of select="xs:string($title)" />
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
        <xsl:param name="locations" as="element()*" tunnel="yes" />
        
        <xsl:apply-templates select="front-matter" />
        <xsl:apply-templates select="body-matter" />
        <xsl:apply-templates select="end-matter" />
        <xsl:apply-templates select="related[person]" mode="people" />
        <xsl:apply-templates select="related[organisation]" mode="organisations" />
        <xsl:apply-templates select="related[count($locations) &gt; 0]" mode="locations" />
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
    
    
    <xsl:template match="related" mode="sources">
        <xsl:param name="sources" select="source" as="element()*"/>
        
        <div class="sources">
            <h2>Sources</h2>
            <ul>
                <xsl:apply-templates select="fn:sort-sources($sources)" mode="source.summary" />                 
            </ul>
        </div>
    </xsl:template>
    
    <xsl:template match="source" mode="source.summary" priority="50">
        <xsl:next-match>
            <xsl:with-param name="summary" select="ancestor::data[1]/event/sources/source[@ref = current()/@id]/summary" as="element()?" />
            <xsl:with-param name="extract-id" select="ancestor::data[1]/event/sources/source[@ref = current()/@id]/@extract" as="xs:string?" tunnel="yes" />
         </xsl:next-match>
    </xsl:template>
    
    
    <xsl:template match="source" mode="source.summary">
        <xsl:param name="summary" as="element()?" />
        
        <li>
            <xsl:if test="count($summary) &gt; 0">
                <xsl:attribute name="class">with-summary</xsl:attribute>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="count($summary) &gt; 0">
                    <p class="source"><xsl:apply-templates select="self::*" mode="href-html" /></p>
                    <xsl:apply-templates select="$summary" mode="source.summary" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="self::*" mode="href-html" />
                </xsl:otherwise>
            </xsl:choose>
        </li>         
    </xsl:template>
    
    <xsl:template match="event/sources/source/summary" mode="source.summary">
        <p class="summary"><xsl:value-of select="." /></p>
    </xsl:template>

    
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
        <xsl:param name="extract-id" select="@extract" as="xs:string?" tunnel="yes" />
        
        <xsl:call-template name="href-html">
            <xsl:with-param name="path" select="concat('source/', @id)" as="xs:string"/>
            <xsl:with-param name="bookmark" select="$extract-id" as="xs:string?" />
            <xsl:with-param name="content" as="item()*">
                <xsl:apply-templates select="reference"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    
    
   
    
    <xsl:template match="source/front-matter">
        <div class="bibliographic-data">
            <xsl:apply-templates select="subtitle" mode="source.profile" />
            <xsl:apply-templates select="series" mode="source.profile" />
            <xsl:apply-templates select="self::*[descendant::author]" mode="source.profile.contributors" />
            <xsl:apply-templates select="serial" mode="source.profile" />    
            <xsl:apply-templates select="descendant::publisher" mode="source.profile" />
            <xsl:apply-templates select="descendant::location" mode="source.profile" />
            <xsl:apply-templates select="date[@rel = 'published']" mode="source.profile" />
            <xsl:apply-templates select="date[@rel = 'revised']" mode="source.profile" />
            <xsl:apply-templates select="descendant::date[@rel = 'survey']" mode="source.profile" />
            <xsl:apply-templates select="descendant::scale" mode="source.profile" />
            <xsl:apply-templates select="descendant::sheet" mode="source.profile" />
            <xsl:apply-templates select="descendant::pages" mode="source.profile" />
            <xsl:apply-templates select="descendant::link" mode="source.profile" />
        </div>
    </xsl:template>
    
    
    <xsl:template match="source/front-matter/subtitle" mode="source.profile">
        <div class="sub-title">
            <h2>Subtitle</h2>
            <p><xsl:apply-templates /></p>
        </div>
    </xsl:template>
    
    <xsl:template match="source/front-matter/series/title" mode="source.profile">
        <div class="series">
            <h2>Series</h2>
            <p><xsl:value-of select="." /></p>                        
        </div>
    </xsl:template>
    
    <xsl:template match="source/front-matter/series/volume" mode="source.profile">
        <div class="volume">
            <h2>Volume</h2>
            <p>
                <xsl:choose>
                    <xsl:when test="@number"><xsl:value-of select="@number" /></xsl:when>
                    <xsl:otherwise><xsl:value-of select="." /></xsl:otherwise>
                </xsl:choose>
            </p>
        </div>
    </xsl:template>
    
    <xsl:template match="source/front-matter" mode="source.profile.contributors">
        <div class="contributors">
            <h2>Contributor(s)</h2>
            <ul>
                <xsl:for-each select="descendant::*[name() = ('author', 'editor', 'contributor')]">
                    <li>
                        <xsl:apply-templates select="name | organisation/name" mode="#current" />
                        <xsl:if test="name() != 'contributor'">
                            <xsl:text> </xsl:text>
                            <span class="role">
                                <xsl:text>(</xsl:text>
                                <xsl:value-of select="name()" />
                                <xsl:text>)</xsl:text>
                            </span>
                        </xsl:if>
                    </li>
                </xsl:for-each>
            </ul>
        </div>
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Contributor's name.</doc:desc>
    </doc:doc>
    <xsl:template match="*[name() = ('author', 'editor', 'contributor')]/*" mode="source.profile.contributors">
        <xsl:value-of select="string-join(*, ' ')"/>
    </xsl:template>
    
    
    <xsl:template match="publisher[ancestor::front-matter/parent::source]" mode="source.profile">
        <div class="publisher">
            <h2>Publisher</h2>
            <p><xsl:apply-templates /></p>
        </div>
    </xsl:template>
    
    
    
    <xsl:template match="location[ancestor::front-matter/parent::source]" mode="source.profile">
        <div class="location">
            <h2>Location</h2>
            <p><xsl:apply-templates /></p>
        </div>
    </xsl:template>
    
    
    <xsl:template match="source/front-matter/serial" mode="source.profile">
        <div class="{if (@type = 'map') then 'map-series' else @type}">
            <xsl:apply-templates select="title" mode="#current" />
            <xsl:apply-templates select="part/volume" mode="#current" />
            <xsl:choose>
                <xsl:when test="@type = 'death-certificate'">
                    <xsl:apply-templates select="part/date[@rel = 'issue']" mode="#current" />
                    <xsl:apply-templates select="part/issue" mode="#current" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="part/issue" mode="#current" />
                    <xsl:apply-templates select="part/date[not(@rel = 'survey')]" mode="#current" />
                </xsl:otherwise>
            </xsl:choose>      
        </div>
    </xsl:template>
    
    
    <xsl:template match="source/front-matter/serial/title" mode="source.profile">
        <div class="title">
            <h2><xsl:choose>
                <xsl:when test="parent::serial/@type = 'newspaper'">Newspaper</xsl:when>
                <xsl:when test="parent::serial/@type = 'journal'">Journal</xsl:when>
                <xsl:when test="parent::serial/@type = 'map'">Map Series</xsl:when>
                <xsl:otherwise>Serial Publication</xsl:otherwise>
            </xsl:choose></h2>
            <p><xsl:apply-templates select="self::*" /></p>
        </div>
    </xsl:template>
    
    <xsl:template match="source/front-matter/serial/part/volume | source/front-matter/serial/part/issue" mode="source.profile" priority="5">
        <div class="{name()}">
            <h2><xsl:next-match /></h2>
            <p><xsl:apply-templates /></p>
        </div>
    </xsl:template>
 
    <xsl:template match="source/front-matter/serial[not(@type = 'death-certificate')]/part/volume" mode="source.profile">
        <xsl:text>Volume</xsl:text>
    </xsl:template>
 
    <xsl:template match="source/front-matter/serial[@type = 'death-certificate']/part/volume" mode="source.profile">
        <xsl:text>Registration District</xsl:text>
    </xsl:template>
    
    <xsl:template match="source/front-matter/serial[not(@type = 'death-certificate')]/part/issue" mode="source.profile">
        <xsl:text>Issue</xsl:text>
    </xsl:template>
    
    <xsl:template match="source/front-matter/serial[@type = 'death-certificate']/part/issue" mode="source.profile">
        <xsl:text>Number</xsl:text>
    </xsl:template>
    
    
    
    
    <xsl:template match="scale[ancestor::front-matter/parent::source]" mode="source.profile">
        <div class="scale">
            <h2>Scale</h2>
            <p><xsl:value-of select="if (@ratio) then @ratio else ." /></p>
        </div>
    </xsl:template>
    
    <xsl:template match="sheet[ancestor::front-matter/parent::source]" mode="source.profile">
        <div class="sheet">
            <h2>Sheet</h2>
            <p><xsl:value-of select="." /></p>
        </div>
    </xsl:template>
    
    
    <xsl:template match="date[ancestor::front-matter/parent::source]" mode="source.profile" priority="10">
        <div class="date">
            <h2><xsl:next-match /></h2>
            <p>
                <xsl:choose>
                    <xsl:when test="normalize-space(.) != ''">
                        <xsl:value-of select="." />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="@day, @month, @year" mode="#current" />
                    </xsl:otherwise>
                </xsl:choose>
            </p>
        </div>
    </xsl:template>
 
    
    <xsl:template match="date[not(@rel) or @rel = 'published'][ancestor::front-matter/parent::source]" mode="source.profile">
        <xsl:text>Publication Date</xsl:text>
    </xsl:template>
 
    <xsl:template match="date[@rel = 'issue'][ancestor::front-matter/parent::source]" mode="source.profile">
        <xsl:text>Issue Date</xsl:text>
    </xsl:template>
 
    <xsl:template match="date[@rel = 'revised'][ancestor::front-matter/parent::source]" mode="source.profile">
        <xsl:text>Revision Date</xsl:text>
    </xsl:template>
    
    <xsl:template match="date[@rel = 'survey'][ancestor::front-matter/parent::source]" mode="source.profile">
        <xsl:text>Survey Date</xsl:text>
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Date.</doc:desc>
    </doc:doc>
    <xsl:template match="date[ancestor::front-matter/parent::source]/@*[name() = ('day', 'year')]" mode="source.profile">
        <xsl:value-of select="." />
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Date.</doc:desc>
    </doc:doc>
    <xsl:template match="date[ancestor::front-matter/parent::source]/@month" mode="source.profile">
        <xsl:text> </xsl:text>
        <xsl:value-of select="fn:month-name(.)" />
        <xsl:text> </xsl:text>
    </xsl:template>
    
    
    <xsl:template match="pages[ancestor::*[name() = ('front-matter', 'body-matter')]/parent::source]" mode="source.profile">
        <div class="pages">
            <xsl:element name="{if (ancestor::front-matter) then 'h2' else 'h3'}">
                <xsl:if test="ancestor::body-matter"><xsl:attribute name="class">heading</xsl:attribute></xsl:if>
                <xsl:text>Page</xsl:text>
                <xsl:if test="@end[number(.) != number(parent::pages/@start)]">
                    <xsl:text> Range</xsl:text>
                </xsl:if>
            </xsl:element>
            <p><xsl:apply-templates select="self::*" /></p>
        </div>
    </xsl:template>
    
    
    <xsl:template match="source/front-matter/link" mode="source.profile">
        <div class="link">
            <h2>Link</h2>
            <p><xsl:apply-templates select="self::link, date" /></p>
        </div>
    </xsl:template>
    

    <xsl:template match="date[@rel = 'revised'][ancestor::front-matter/parent::source]" priority="20">
        <xsl:if test="parent::*/date[@rel = 'published']"><xsl:text>, </xsl:text></xsl:if>
        <xsl:next-match />
        <xsl:text> (rev)</xsl:text>
    </xsl:template>

    <xsl:template match="date[@rel = 'retrieved'][ancestor::front-matter/parent::source]" priority="20">
        <xsl:text> (retrieved: </xsl:text><xsl:next-match /><xsl:text>)</xsl:text>
    </xsl:template>

    <xsl:template match="date[ancestor::front-matter/parent::source]" priority="10">
        <span class="date {@rel}"><xsl:next-match /></span>
    </xsl:template>
    
    <xsl:template match="date[normalize-space(.) != ''][ancestor::front-matter/parent::source]">
        <xsl:value-of select="." />
    </xsl:template>
    
    <xsl:template match="date[normalize-space(.) = ''][@day and @month and @year][ancestor::front-matter/parent::source]">
        <xsl:value-of select="@day" />
        <xsl:text> </xsl:text>
        <xsl:value-of select="substring(fn:month-name(@month), 1, 3)"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="@year" />
    </xsl:template>
    
    <xsl:template match="date[normalize-space(.) = ''][not(@day) and @month and @year][ancestor::front-matter/parent::source]">
        <xsl:value-of select="substring(fn:month-name(@month), 1, 3)"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="@year" />
    </xsl:template>
    
    <xsl:template match="date[normalize-space(.) = ''][not(@day) and not(@month) and @year][ancestor::front-matter/parent::source]">
        <xsl:value-of select="@year" />
    </xsl:template>
    
    
    <xsl:template match="link[ancestor::source]">
        <a href="{@href}"><xsl:value-of select="@href" /></a>
    </xsl:template>
    
    
    
    <xsl:template match="source/body-matter[body]">
        <h2>Content</h2>
        <xsl:apply-templates select="body" />
    </xsl:template>
    
    <xsl:template match="source/body-matter[not(body)][summary]">
        <h2>Summary</h2>
        <p class="summary"><xsl:apply-templates /></p>    
    </xsl:template>
    
    <xsl:template match="source/body-matter[extract]">
        <h2 class="heading">Extract(s)</h2>
        <xsl:apply-templates select="extract">
            <xsl:sort select="pages/@start" data-type="number" order="ascending" />
        </xsl:apply-templates>        
    </xsl:template>
    
    <xsl:template match="source/body-matter/extract">
        <div class="extract">
            <xsl:if test="@id"><xsl:attribute name="id" select="@id" /></xsl:if>
            <xsl:apply-templates select="pages" mode="source.profile" />
            <xsl:apply-templates select="if (body) then body else summary" />            
        </div>
    </xsl:template>
    
    <xsl:template match="source/body-matter/extract/summary">
       <div class="summary">
           <h3 class="heading">Summary</h3>
           <p class="summary"><xsl:apply-templates /></p>
       </div>
    </xsl:template>


    <doc:doc>
        <doc:desc>Bibliography section in the end matter of a source document.</doc:desc>
        <doc:note>
            <doc:p>The entries are formatted as they were in the original source document, so just need to be copied out; inappropriate to restructure, etc.</doc:p>
        </doc:note>
    </doc:doc>
    <xsl:template match="source/end-matter/bibliography[citation]">
        <div class="bibliography">
            <h2>Bibliography</h2>
            <ul>
                <xsl:for-each select="citation">
                    <li><p><xsl:apply-templates select="node()" mode="body" /></p></li>
                </xsl:for-each>
            </ul>
        </div>
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>An empty bibliography section in the end matter of a source document.</doc:desc>
        <doc:note>
            <doc:p>Shouldn't occur.  Can this be deleted?</doc:p>
        </doc:note>
    </doc:doc>
    <xsl:template match="source/end-matter/bibliography[not(citation)]" />

    <xsl:template match="source/end-matter[bibliography or notes]" priority="50">
        <div class="end-matter">
            <xsl:next-match />
        </div>
    </xsl:template>
    
    
    <xsl:template match="source/end-matter/notes">
        <div class="notes">
            <h2>Source Notes</h2>
            <xsl:apply-templates select="note" />
        </div>
    </xsl:template>
    
    <xsl:template match="notes[ancestor::source]/note[@id]">
        <div id="{@id}" class="note">
            <h3>
                <a href="#{@id}-ref" class="nav" title="Continue reading">▴</a>
                <xsl:text> </xsl:text>
                <xsl:value-of select="label" />
            </h3>
            <xsl:apply-templates select="*[name() != 'label']" mode="body" />
        </div>
    </xsl:template>
    
   
    
</xsl:stylesheet>