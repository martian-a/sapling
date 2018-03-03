<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://ns.thecodeyard.co.uk/functions"
    exclude-result-prefixes="#all"
    version="2.0">
    
    <xsl:include href="../../utils/identity.xsl" />
    
    <xsl:output encoding="UTF-8" indent="yes" />
    <xsl:strip-space elements="*" />
    
    <xsl:key name="node" match="/network/nodes/node" use="@id" />
    
    
    <xsl:template match="/">
        <xsl:result-document>
            <xsl:apply-templates />
        </xsl:result-document>
    </xsl:template>
    
    
    <xsl:template match="/app/data[people]">
        
        <!-- Create a graph of nodes and edges from people and event data. -->
        <xsl:variable name="network-graph" as="document-node()">
          <xsl:document>
              <network>
                  <xsl:apply-templates select="people" mode="filter" />
                  <xsl:apply-templates select="events" mode="filter" />
              </network>
          </xsl:document>
        </xsl:variable>
                    
        <!-- Merge together clusters of adjacent nodes to identify sub-networks and orphan nodes. -->
        <xsl:variable name="clusters" as="document-node()">
            <xsl:document>
                <clusters>
                    <xsl:sequence select="fn:consolidate-clusters(fn:adjacent-nodes($network-graph/network))" />
                </clusters>
            </xsl:document>
        </xsl:variable>		
        
        <!-- Identify the largest cluster. -->
        <xsl:variable name="largest-cluster" as="element()*">
            <xsl:for-each select="$clusters/clusters/cluster">
                <xsl:sort select="count(*)" data-type="number" order="descending" />
                <xsl:if test="position() = 1">
                    <xsl:sequence select="self::cluster" />
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <include>
                <xsl:apply-templates select="people" mode="include">
                    <xsl:with-param name="largest-cluster" select="$largest-cluster" as="element()*" />
                </xsl:apply-templates>
            </include>
            <exclude>
                <xsl:apply-templates select="people" mode="to-temp">                
                    <xsl:with-param name="largest-cluster" select="$largest-cluster" as="element()*" />
                </xsl:apply-templates>
                <xsl:apply-templates select="*[name() != 'people']" />
            </exclude>
        </xsl:copy>
               
   </xsl:template>
    
    
    <xsl:template match="people" mode="include">
        <xsl:param name="largest-cluster" as="element()*" />
        
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:apply-templates select="person[@id = $largest-cluster/node/@ref]" />
        </xsl:copy>
        
    </xsl:template>
    
    
    <xsl:template match="people" mode="to-temp">
        <xsl:param name="largest-cluster" as="element()*" />
        
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:apply-templates select="person[not(@id = $largest-cluster/node/@ref)]" />
        </xsl:copy>
       
    </xsl:template>

    
    <xsl:template match="people" mode="filter">
        <nodes>
            <xsl:apply-templates select="person" mode="#current" />
        </nodes>
    </xsl:template>
    
    <xsl:template match="people/person" mode="filter">
        <node id="{@id}">
            <xsl:value-of select="persona[1]/name/string-join(*, ' ')" />
        </node>
    </xsl:template>
    
    <xsl:template match="events" mode="filter">
        <edges>
            <xsl:apply-templates select="event[count(descendant::*/@ref[starts-with(., 'PER')]) &gt; 1]" mode="#current" />
        </edges>
    </xsl:template>
    
    <xsl:template match="temp/*" mode="filter">
        <node ref="{@ref}" />
    </xsl:template>
    
    <xsl:template match="event" mode="filter">
        <xsl:variable name="event-id" select="@id" as="xs:string" />
        <xsl:variable name="people" as="document-node()">
            <xsl:document>
                <temp>
                    <xsl:for-each-group select="descendant::*[name() = ('parent', 'person')][@ref]" group-by="@ref">
                        <xsl:copy-of select="current-group()[1]" />
                    </xsl:for-each-group>
                </temp>
            </xsl:document>
        </xsl:variable>
        
        <xsl:for-each select="$people/temp/*">
            <xsl:variable name="person" select="self::*" as="element()" />
            
            <xsl:for-each select="$person/following-sibling::*">
                <xsl:variable name="other-person" select="self::*" as="element()" />
                <xsl:variable name="id" select="concat($event-id, '-', $person/@ref, '-', $other-person/@ref)" as="xs:string" />
                
                <edge id="{$id}" length="1">
                    <xsl:apply-templates select="$person" mode="#current" />
                    <xsl:apply-templates select="$other-person" mode="#current" />
                </edge>
            </xsl:for-each>
            
        </xsl:for-each>
        
    </xsl:template>
   
    
    <xsl:function name="fn:adjacent-nodes" as="element()">
        <xsl:param name="network" as="element()" />
        
        <network>
             <xsl:for-each select="$network/nodes/node">
              <xsl:variable name="self" select="self::node" as="element()" />
              
              <xsl:variable name="cluster" as="element()">        
                <cluster>
                    <node ref="{$self/@id}" />
                    <xsl:sequence select="fn:get-connected-nodes($self)" />
                </cluster>
              </xsl:variable>
              
              <xsl:sequence select="fn:dedupe-clusters($cluster)" />
              
             </xsl:for-each>
        </network>
    </xsl:function>
    
    
    <xsl:function name="fn:get-connected-nodes" as="element()*">
        <xsl:param name="subject" as="element()" />
        
        <xsl:sequence select="$subject/ancestor::network/edges/edge[node/@ref = $subject/(@id | @ref)]/node" />
        
    </xsl:function>    
    
    
    <xsl:function name="fn:dedupe-clusters" as="element()*">
        <xsl:param name="clusters-in" as="element()*" />
        
        <xsl:for-each select="$clusters-in/self::cluster">
            <xsl:copy>
                <xsl:copy-of select="@*" />
                <xsl:for-each select="node[not(@ref = preceding-sibling::node/@ref)]">
                    <xsl:copy-of select="self::node" />
                </xsl:for-each>
            </xsl:copy>
        </xsl:for-each>
    </xsl:function>
    
    
    
    <xsl:function name="fn:consolidate-clusters-single-pass" as="element()*">
        <xsl:param name="network-in" as="element()" />
                
        <xsl:variable name="merged" as="element()*">
            <xsl:for-each select="$network-in/cluster[node/@ref = following-sibling::cluster/node/@ref][1]">
             <xsl:variable name="current" select="self::cluster/node" as="element()*" />
             <xsl:copy>
                 <xsl:copy-of select="@*, node()" />
                 <xsl:copy-of select="following-sibling::cluster[node/@ref = $current/@ref]/node" />
             </xsl:copy>
            </xsl:for-each>
        </xsl:variable>
       
       <xsl:sequence select="fn:dedupe-clusters($merged)" />  
        
        <xsl:for-each select="$network-in/cluster[node[not(@ref = $merged/node/@ref)]]">
            <xsl:copy-of select="self::cluster" />
        </xsl:for-each>
        
    </xsl:function>
    
    
    <xsl:function name="fn:clusters-overlap" as="xs:boolean">
        <xsl:param name="network-in" as="element()" />
        
        <xsl:variable name="overlap" as="element()*">
            
            <xsl:for-each select="$network-in/cluster">
                <xsl:variable name="self" select="self::cluster" as="element()" />
                <xsl:if test="preceding-sibling::cluster[node/@ref = $self/node/@ref]">
                    <xsl:copy-of select="self::cluster" />
                </xsl:if>
            </xsl:for-each>
            
        </xsl:variable>
        
        <xsl:choose>
            <xsl:when test="count($overlap) &gt; 0">
                <xsl:value-of select="true()" />            
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="false()" />
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:function>
    
    
    <xsl:function name="fn:consolidate-clusters" as="element()*">
        <xsl:param name="network-in" as="element()" />
        
        <xsl:variable name="single-pass" as="element()">
            <network>
                <xsl:sequence select="fn:consolidate-clusters-single-pass($network-in)" />
            </network>
        </xsl:variable>    
        
        <xsl:variable name="overlap" select="fn:clusters-overlap($single-pass)" as="xs:boolean" />
        
       <xsl:choose>
         <xsl:when test="$overlap">
             <xsl:sequence select="fn:consolidate-clusters($single-pass)" />            
         </xsl:when>
           <xsl:otherwise> 
               <xsl:sequence select="$single-pass/cluster" />
           </xsl:otherwise>
       </xsl:choose> 
        
    </xsl:function>
    
</xsl:stylesheet>