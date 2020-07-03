<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    
    <xsl:template match="/">
       <html>
           <head>
               <title>Distinct XPaths: <xsl:value-of select="paths/@href" /></title>
           </head>
           <body>
               <h1>Distinct XPaths</h1>
               <h2>File: <xsl:value-of select="paths/@href" /></h2>
               <section>
                   <h3>Contents</h3>
                   <ol>
                       <li><a href="#paths">Paths</a></li>
                       <li><a href="#elements">Elements</a></li>                         
                   </ol>
               </section>  
               <xsl:apply-templates />
           </body>
       </html>        
    </xsl:template>
    
    <xsl:template match="paths/frequency">
        <section id="paths">
            <h3>Paths</h3>
            <xsl:call-template name="paths-table" />
        </section>
    </xsl:template>
    
    <xsl:template match="paths/elements">
        <section id="elements">
            <h3>Elements</h3>
            <div class="toc">
                <ol>
                    <xsl:for-each select="node">
                        <xsl:sort select="@name" data-type="text" order="ascending" />
                        <xsl:sort select="sum(path/@occurrences)" data-type="number" order="descending" />
                        <xsl:sort select="count(path)" data-type="number" order="descending" />                        
                        <li><a href="#node_{@name}"><xsl:value-of select="@name" /></a></li>
                    </xsl:for-each>
                </ol>
            </div>
            <div class="content">
                <xsl:apply-templates select="node">
                    <xsl:sort select="sum(path/@occurrences)" data-type="number" order="descending" />
                    <xsl:sort select="count(path)" data-type="number" order="descending" />                    
                    <xsl:sort select="@name" data-type="text" order="ascending" />
                </xsl:apply-templates>
            </div>
        </section>
    </xsl:template>
    
    <xsl:template match="paths/elements/node">
        <section id="node_{@name}">
            <h4><xsl:value-of select="@name" /></h4>
            <xsl:call-template name="paths-table" />
        </section>
    </xsl:template>
    
    <xsl:template name="paths-table">
        <table>
            <tr>
                <th>XPath</th>
                <th>Occurrences</th>
            </tr>
            <xsl:for-each select="path">
                <tr>
                    <td><xsl:value-of select="text()" /></td>
                    <td><xsl:value-of select="@occurrences" /></td>
                </tr>
            </xsl:for-each>
        </table>
    </xsl:template>
    
</xsl:stylesheet>