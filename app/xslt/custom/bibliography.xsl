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
    <xsl:template match="source/reference/creators/author/name/name[@family = 'yes'] | source/front-matter/author/name/name[@family = 'yes']">
        <span class="family-name"><xsl:value-of select="." /></span>    
   </xsl:template>
   
   
    <doc:doc>
        <doc:desc>Format the forenames of an author.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference/creators/author/name/name[not(@family = 'yes')] | source/front-matter/author/name/name[not(@family = 'yes')]">
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
    <xsl:template match="source/reference/journal/title | source/front-matter/journal/title" priority="30">
        <span class="journal-title"><xsl:next-match /></span>
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
    <xsl:template match="source/reference/titles/title | source/reference/journal/title | source/front-matter/journal/title"> 
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
    <xsl:template match="source/reference[@style = 'journal']/journal/issue | source/front-matter/journal/issue">
        <xsl:apply-templates select="volume[normalize-space(@number) != '' or normalize-space(.) != '']" mode="#current" />
        <xsl:if test="volume[normalize-space(@number) != '' or normalize-space(.) != ''] and issue"><xsl:text>, </xsl:text></xsl:if>
        <xsl:apply-templates select="issue" mode="#current" />
        <xsl:text> </xsl:text>
        <xsl:apply-templates select="date[not(@rel = 'retrieved')]" mode="#current" />
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Format the volume of serial source.</doc:desc>
    </doc:doc>
    <xsl:template match="source/reference/journal/issue/volume | source/front-matter/journal/issue/volume" priority="10">
        <span class="volume"><xsl:next-match /></span>
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Output a custom volume label.</doc:desc>
    </doc:doc>
    <xsl:template match="journal[ancestor::source]/issue/volume[normalize-space(.) != '']">
        <xsl:value-of select="." />
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Output a standard numbered volume label.</doc:desc>
    </doc:doc>
    <xsl:template match="journal[ancestor::source]/issue/volume[normalize-space(.) = '']">
        <xsl:value-of select="@number" />
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Format the issue of serial source.</doc:desc>
    </doc:doc>
    <xsl:template match="journal[ancestor::source]/issue/issue">
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
    <xsl:template match="source/reference/journal/pages | source/body-matter/extract/pages" priority="5">
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