<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fn="http://ns.thecodeyard.co.uk/functions"
	xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#"
	xmlns:doc="http://ns.kaikoda.com/documentation/xml" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="#all" 
	version="2.0">
	
	<doc:doc scope="stylesheet">
		<doc:desc>Templates specific to formatting a bibliography entry.</doc:desc>
	</doc:doc>


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
    <xsl:template match="source/reference/contributors">
        <xsl:apply-templates select="*" />
        <xsl:text>. </xsl:text>
    </xsl:template>
    

    <doc:doc>
        <doc:desc>Append et al where required.</doc:desc>
    </doc:doc>   
    <xsl:template match="source/reference/contributors/*[@et-al = 'true']" priority="20">
        <xsl:next-match />
        <xsl:text> </xsl:text><span class="author et-al">et al</span>
    </xsl:template>  
    

    <doc:doc>
        <doc:desc>The first author in a bibliography entry.</doc:desc>
        <doc:note>Surname first, then forenames.</doc:note>
    </doc:doc>
    <xsl:template match="source/reference/contributors/*[position() = 1]" priority="10">        
        <xsl:next-match />
    </xsl:template>    
    
 
    
    
    <doc:doc>
        <doc:desc>Authors (other than the first) in a bibliography entry.</doc:desc>
        <doc:note>Fornames first, then surname.</doc:note>
    </doc:doc>
    <xsl:template match="source/reference/contributors/*[position() &gt; 1]" priority="10">
        <xsl:choose>
            <xsl:when test="following-sibling::*">
                <xsl:text>, </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text> and </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:next-match />
    </xsl:template>
    
       
       
    <doc:doc>
        <doc:desc>Wrap the name of each contributor in a span.</doc:desc>
    </doc:doc>   
    <xsl:template match="source/reference/contributors/*">
        <span class="contributor {name()}">
            <xsl:apply-templates mode="#current" />
        </span>
    </xsl:template>  
       
    
    <doc:doc>
        <doc:desc>Format the name of the first contributor.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference/contributors/*[1]/name">
        <!-- Surname -->
        <xsl:apply-templates select="name[@family = 'yes']" mode="#current" />
        <!-- Comma and non-breaking space -->
        <xsl:text>,</xsl:text><xsl:value-of select="codepoints-to-string(160)" />
        <!-- Forename(s) -->
        <xsl:apply-templates select="name[not(@family = 'yes')]" mode="#current" />
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Format the name of an contributor other than the first contributor.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference/contributors/*[position() &gt; 1]/*">
        <xsl:for-each select="*">
            <xsl:apply-templates select="self::*" mode="#current"/>
            <xsl:if test="position() != last()">
                <!-- Non-breaking space -->
                <xsl:value-of select="codepoints-to-string(160)"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
   
    <doc:doc>
        <doc:desc>Format the surname of an contributor.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference/contributors/*/name/name[@family = 'yes']">
        <span class="family-name"><xsl:value-of select="." /></span>    
   </xsl:template>
   
   
    <doc:doc>
        <doc:desc>Format the forenames of an contributor.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference/contributors/*/name/name[not(@family = 'yes')]">
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
        <doc:desc>Format the name of an organisation contributor.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference/contributors/*/organisation/name">
        <span class="name organisation"><xsl:value-of select="." /></span>    
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Append a space after a source title.</doc:desc>
        <doc:note>
            <doc:p>For a serial source, this needs to be after closing quote of the title of a serial source (not the full stop).</doc:p>
            <doc:p>For a book source, this should be after the full stop at the end of the title sequence (which may include a subtitle).</doc:p>
        </doc:note>
    </doc:doc>
    <xsl:template match="source/reference/titles/*[position() = last()]" priority="70">
        <xsl:next-match /><xsl:text> </xsl:text>
    </xsl:template> 
    
   
    <doc:doc>
        <doc:desc>Wrap the title of serial source in quote marks.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference[@style = ('journal', 'newspaper')]/titles/title" priority="60">
        <xsl:value-of select="$ldquo" /><xsl:next-match /><xsl:value-of select="$rdquo" />
    </xsl:template>  
    
    
    <doc:doc>
        <doc:desc>Append a space after a source title.</doc:desc>
        <doc:note>
            <doc:p>For a serial source, this needs to be after closing quote of the title of a serial source (not the full stop).</doc:p>
            <doc:p>For a book source, this should be after the full stop at the end of the title sequence (which may include a subtitle).</doc:p>
        </doc:note>
    </doc:doc>
    <xsl:template match="source/reference[@style = 'map']/titles/*[position() = last()]" priority="55">
        <xsl:next-match /><xsl:text> </xsl:text><span class="map-label">Map. </span>
    </xsl:template> 
    
    <doc:doc>
        <doc:desc>Append a full stop to the end of the title of a source.</doc:desc>
        <doc:note>
            <doc:p>For a serial source, this needs to be inside the closing quote mark.</doc:p>
        </doc:note>
    </doc:doc>
    <xsl:template match="source/reference/titles/*[position() = last()]" priority="50">
        <xsl:next-match /><xsl:text>.</xsl:text>
    </xsl:template> 

        
    <doc:doc>
        <doc:desc>Wrap the source title in a span.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference/titles/title" priority="20"> 
       <span class="title"><xsl:next-match /></span>
    </xsl:template>   
    
    
    <doc:doc>
        <doc:desc>Format the title of a journal.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference[@style = 'journal']/publication/title | source/front-matter/serial[@type = 'journal']/title" priority="30">
        <span class="journal-title"><xsl:next-match /></span><xsl:text> </xsl:text>
    </xsl:template>  
    
    
    <doc:doc>
        <doc:desc>Wrap an inferred title in square brackets.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference[@style = 'death-certificate']/titles/title" priority="20" mode="view.title"> 
        <xsl:text>Death certificate for </xsl:text><xsl:next-match />
    </xsl:template>  
    
    <doc:doc>
        <doc:desc>Wrap an inferred title in square brackets.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference[@style = 'death-certificate']/titles/title" priority="15"> 
        <xsl:next-match /><xsl:text>. [Death Certificate]</xsl:text>
    </xsl:template>   
    
    
    
    <doc:doc>
        <doc:desc>Wrap an inferred title in square brackets.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference/titles/title[@status = 'inferred']" priority="10" mode="#default view.title"> 
        <xsl:text>[</xsl:text><xsl:next-match /><xsl:text>]</xsl:text>
    </xsl:template>   
    
    <doc:doc>
        <doc:desc>Output a source or journal title.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference/titles/title | source/front-matter/serial/title"> 
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
        <span class="series">
            <xsl:text>(</xsl:text>
            <xsl:for-each select="*">
                <xsl:apply-templates select="self::*" />
                <xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if>
            </xsl:for-each>
            <xsl:text>)</xsl:text>
        </span><xsl:text>. </xsl:text>
    </xsl:template>  
    
    <xsl:template match="source/reference/series/*" priority="50">
        <span class="{name()}"><xsl:next-match /></span>
    </xsl:template>
    
    
    <xsl:template match="source/reference/scale">
        <span class="scale"><xsl:value-of select="@ratio" /><xsl:text> scale. </xsl:text></span>
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Format the publication data.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference/publication" priority="20">
        <span class="publication"><xsl:next-match /></span>
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Format the publication data for a newspaper.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference[@style = 'newspaper']/publication">
        <xsl:for-each select="*">
            <xsl:apply-templates select="self::*" />
            <xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Append a full-stop and space to the publisher data for a death certificate.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference[@style = 'death-certificate']/publication[location or publisher]/part" priority="20">
        <xsl:text>. </xsl:text><xsl:next-match />
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Format the serial volume, issue and date of a journal.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference[@style = 'journal']/publication/part | source/front-matter/serial[@type = 'journal']/part">
        <xsl:for-each select="volume, issue">
            <xsl:apply-templates select="self::*" mode="#current" />
            <xsl:choose>
                <xsl:when test="position() = last()"><xsl:text> </xsl:text></xsl:when>
                <xsl:otherwise>
                    <xsl:text>, </xsl:text>
                </xsl:otherwise>
            </xsl:choose>            
        </xsl:for-each>       
        <xsl:apply-templates select="date" mode="#current" />
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Format the volume, date of issue and number of a death certificate.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference[@style = 'death-certificate']/publication/part">
        <xsl:for-each select="*">
            <xsl:apply-templates select="self::*" mode="#current" />
            <xsl:choose>
                <xsl:when test="position() = last()"><xsl:text> </xsl:text></xsl:when>
                <xsl:otherwise>
                    <xsl:text>, </xsl:text>
                </xsl:otherwise>
            </xsl:choose>            
        </xsl:for-each>       
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Wrap the volume of serial source in a span.</doc:desc>
    </doc:doc>
    <xsl:template match="volume[ancestor::reference/parent::source]" priority="10">
        <span class="volume"><xsl:next-match /></span>
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Output a custom volume label.</doc:desc>
    </doc:doc>
    <xsl:template match="volume[ancestor::reference/parent::source][normalize-space(.) != '']">
        <xsl:value-of select="." />
    </xsl:template> 
    
    
    <doc:doc>
        <doc:desc>Output a standard numbered volume label.</doc:desc>
    </doc:doc>
    <xsl:template match="volume[ancestor::*[name() = ('reference', 'front-matter')]/parent::source][normalize-space(.) = '']">
        <xsl:value-of select="@number" />
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Wrap the issue of serial source in a span.</doc:desc>
    </doc:doc>
    <xsl:template match="issue[ancestor::*[name() = ('reference', 'front-matter')]/parent::source]">
        <span class="issue"><xsl:value-of select="." /></span>
    </xsl:template>
        
    
    <doc:doc>
        <doc:desc>Prepend a colon before journal page numbers.</doc:desc>
    </doc:doc>
    <xsl:template match="pages[ancestor::reference[@style = 'journal']/parent::source]" priority="10">
        <xsl:text>: </xsl:text><xsl:next-match />
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Prepend a colon before journal page numbers.</doc:desc>
    </doc:doc>
    <xsl:template match="publication[ancestor::reference[not(@style = ('journal', 'newspaper'))]/parent::source]/date" priority="10">
        <xsl:if test="preceding-sibling::*">
            <xsl:text>, </xsl:text>
        </xsl:if>
        <xsl:next-match />
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Format the page numbers of serial source.</doc:desc>
    </doc:doc>
    <xsl:template match="pages[ancestor::*[name() = ('reference', 'body-matter')]/parent::source]" priority="5">
        <span class="pages"><xsl:next-match /></span>
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Format the page numbers of serial source.</doc:desc>
    </doc:doc>
    <xsl:template match="pages[ancestor::source]">
       <xsl:apply-templates select="@start" mode="#current" />
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Format the starting page number of serial source.</doc:desc>
    </doc:doc>
    <xsl:template match="pages[ancestor::source]/@start">
        <xsl:value-of select="." />
        <xsl:apply-templates select="parent::pages/@end[. != current()]" mode="#current" />
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Format the end page number of serial source.</doc:desc>
    </doc:doc>
    <xsl:template match="pages[ancestor::source]/@end">
        <xsl:text>-</xsl:text><xsl:value-of select="." />
    </xsl:template>
 
    
    
    <doc:doc>
        <doc:desc>Include the location in a bibliography entry.</doc:desc>
    </doc:doc>
    <xsl:template match="location[ancestor::reference/parent::source]">
        <span class="location"><xsl:value-of select="normalize-space(.)" /></span>
    </xsl:template>
 
 
    <doc:doc>
        <doc:desc>Insert a colon between the location and publisher's name when both are present.</doc:desc>
    </doc:doc>
    <xsl:template match="publication[location]/publisher[ancestor::reference/parent::source]" priority="50">
        <xsl:text>: </xsl:text>
        <xsl:next-match />
    </xsl:template>
 
    
    <doc:doc>
        <doc:desc>Format the publisher in a bilbiographic entry.</doc:desc>
    </doc:doc>
    <xsl:template match="publisher[ancestor::reference/parent::source]" priority="10">
        <span class="publisher"><xsl:next-match /></span>
    </xsl:template>
   
    
    
 
    
    
    <doc:doc>
        <doc:desc>Include the publication or revision date in a book reference.</doc:desc>
    </doc:doc>
    <xsl:template match="date[ancestor::reference[@style = 'book']/parent::source]">
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
    <xsl:template match="source/reference[@style = ('newspaper', 'death-certificate')]/publication/part/date" priority="50">
        <span class="date published">
            <xsl:next-match />
        </span>
    </xsl:template>
        
    
    <doc:doc>
        <doc:desc>Include the publication or revision date in a journal reference.</doc:desc>
    </doc:doc>
    <xsl:template match="date[ancestor::publication/parent::reference[@style = 'journal']/parent::source]" priority="50">
        <span class="date published">
            <xsl:text>(</xsl:text>
            <xsl:next-match />
            <xsl:text>)</xsl:text></span>
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Format the publication date in a newspaper reference.</doc:desc>
    </doc:doc>
    <xsl:template match="date[@day and @month and @year][ancestor::publication/parent::reference[@style = 'newspaper']/parent::source]">
        <xsl:value-of select="substring(fn:month-name(@month), 1, 3)" />
        <xsl:text> </xsl:text>
        <xsl:value-of select="@day" />
        <xsl:text>, </xsl:text>
        <xsl:value-of select="@year" />
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Format the publication date in a serial reference (other than a newspaper) when day, month and year are all present.</doc:desc>
    </doc:doc>
    <xsl:template match="date[@day and @month and @year][ancestor::publication/parent::reference[not(@style = ('newspaper', 'book'))]/parent::source]">
        <xsl:value-of select="@day" />
        <xsl:text> </xsl:text>
        <xsl:value-of select="substring(fn:month-name(@month), 1, 3)" />
        <xsl:text> </xsl:text>
        <xsl:value-of select="@year" />
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Format the publication date for a serial reference (other than a newspaper) when only month and year are present.</doc:desc>
    </doc:doc>
    <xsl:template match="date[not(@day) and @month and @year][ancestor::publication/parent::reference[not(@style = 'book')]/parent::source]">
        <xsl:value-of select="fn:month-name(@month)" />
        <xsl:text> </xsl:text>
        <xsl:value-of select="@year" />
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Format the publication date for a serial reference (other than a newspaper) when only year is present.</doc:desc>
    </doc:doc>
    <xsl:template match="date[not(@day) and not(@month) and @year][ancestor::publication/parent::reference[not(@style = 'book')]/parent::source]">
        <xsl:value-of select="@year" />
    </xsl:template>


</xsl:stylesheet>