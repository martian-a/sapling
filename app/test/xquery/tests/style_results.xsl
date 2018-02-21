<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    
    <xsl:template match="/">
        <html>
            <head>
                <title>Test Results</title>
            </head>
            <body>
                <h1>Test Results</h1>
                <xsl:for-each-group select="testsuites/testsuite" group-by="number(@failures) = 0">
                    <div>
                        <h2>
                            <xsl:choose>
                                <xsl:when test="current-grouping-key()">Passed</xsl:when>
                                <xsl:otherwise>Failed</xsl:otherwise>
                            </xsl:choose>
                        </h2>
                        <xsl:apply-templates select="current-group()"/>
                    </div>
                </xsl:for-each-group>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="testsuite">
        <div>
            <h3>
                <xsl:value-of select="@package"/>
            </h3>
            <table class="tests">
                <tr>
                    <th>Status</th><th>Total</th>
                </tr>
                <tr>
                    <td>Pending</td><td><xsl:value-of select="@pending" /></td>
                </tr>
                <tr>
                    <td>Passed</td><td><xsl:value-of select="number(@tests) - number(@failures)" /></td>
                </tr>
                <tr>
                    <td>Failed</td><td><xsl:value-of select="@failures" /></td>
                </tr>
            </table>
            <div class="testcases">
                <h4>Tests</h4>  
                <ul>
                    <xsl:for-each-group select="testcase" group-by="@class">
                        <li>
                            <p class="class"><xsl:value-of select="current-grouping-key()" /></p>
                            <p>Total Cases: <xsl:value-of select="count(current-group())" /></p>
                            <xsl:apply-templates select="current-group()[failure]" />
                        </li>
                    </xsl:for-each-group>
                </ul>
            </div>
        </div>
    </xsl:template>
    
    
    <xsl:template match="testcase[failure]">
        <div class="failure">
            <xsl:apply-templates select="failure" />
            <xsl:apply-templates select="output" />
        </div>
    </xsl:template>
    
    <xsl:template match="testcase/failure">
        <xsl:apply-templates select="@*" />
        <div class="expected">
            <p>Expected</p>
            <div>
                <xsl:apply-templates select="node()" mode="sample" />
            </div>
        </div>
    </xsl:template>
    
    <xsl:template match="testcase/failure/@*">
        <p><xsl:value-of select="name()" />: <xsl:value-of select="." /></p>
    </xsl:template>
    
    <xsl:template match="testcase/output">
        <div class="result">
            <p>Result</p>
            <div>
                <xsl:variable name="result" as="xs:string*">
                    <xsl:apply-templates select="node()" mode="sample" />                    
                </xsl:variable>
                <xsl:copy-of select="string-join($result, '')" />
            </div>
        </div>
    </xsl:template>
        
    <xsl:template match="element()" mode="sample">
        <xsl:text>&lt;</xsl:text><xsl:value-of select="name()" /><xsl:apply-templates select="@*" mode="#current" />
        <xsl:choose>
            <xsl:when test="node()">
                <xsl:text>&gt;</xsl:text>
                <xsl:apply-templates select="node()" mode="#current" />
                <xsl:text>&lt;/</xsl:text><xsl:value-of select="name()" /><xsl:text>&gt;</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text> /&gt;</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
       
    </xsl:template>
    
    <xsl:template match="attribute()" mode="sample">
        <xsl:text> </xsl:text><xsl:value-of select="name()" /><xsl:text>="</xsl:text><xsl:value-of select="." /><xsl:text>"</xsl:text>
    </xsl:template>
    
    <xsl:template match="text()" mode="sample">
        <xsl:value-of select="." />
    </xsl:template>

    <xsl:template match="comment()" mode="sample">
        <xsl:text>&lt;!-- </xsl:text><xsl:value-of select="." /><xsl:text> --&gt;</xsl:text>
    </xsl:template>
    
    <xsl:template match="processing-instruction()" mode="sample">
        <xsl:text>&lt;?</xsl:text><xsl:value-of select="name()" /><xsl:text> </xsl:text><xsl:value-of select="." /><xsl:text>?&gt;</xsl:text>
    </xsl:template>

</xsl:stylesheet>