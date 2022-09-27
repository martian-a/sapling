<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step" 
    xmlns:prov="http://www.w3.org/ns/prov#"
    xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
    xmlns:void="http://rdfs.org/ns/void#"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    name="create-leeds-method-network"
    type="tcy:create-leeds-method-network"
    version="3.0">
    
	<p:import href="../../../build/utils/collate-output-file-locations/collate-output-file-locations.xpl" />
	<p:import href="../../../build/data/network/filter-by-direction/filter_network_by_direction.xpl" />
	<p:import href="../../../build/utils/store.xpl" />
	<p:import href="../../../build/utils/debug.xpl" />
    
	<p:input port="source" primary="true">
		<p:document href="../../../../fortunes-olive-data/import/leeds-matches/data/matches_2.xml" />
	</p:input>
    
	<p:input port="full-network">
		<p:document href="../../../../fortunes-olive-data/output/20220926/warr.20220926.family_tree_without_node_for_parent_groups.network.xml" />
	</p:input>    

	<p:input port="pedigree-network">
		<p:document href="../../../../fortunes-olive-data/output/20220926/pedigree/warr.20220926.pedigree.family_tree_without_node_for_parent_groups.network.xml" />
	</p:input>
	
    <p:output port="result" sequence="true" />
    
	<p:option name="path-to-output-folder" select="'../../output/'" />
	<p:option name="generated-by-user" required="false" />    
	<p:option name="debug" select="'true'" />
	
	<p:variable name="dna-subject-id" select="/dna-analysis/dna-test/dna-subject/personId" as="xs:string" />
	<p:variable name="dna-match-id-elements" select="/dna-analysis/dna-test/dna-match/personId[normalize-space(.) != '']" as="element()*" />
	<p:variable name="pipeline-start-time" select="current-dateTime()" />
	
	<p:for-each>
		
		<p:with-input select="$dna-match-id-elements/text()" />
		
		<p:output port="result" sequence="true" />
		
		<p:group>
			
			<p:variable name="dna-match-id" select="." as="xs:string" />
			
			<p:sink />
			
			<p:if test="/network/nodes/node[@id = $dna-match-id]">
				
				<p:with-input>
					<p:pipe step="create-leeds-method-network" port="full-network" />
				</p:with-input>
				
				<tcy:filter-network-by-direction anchor-person-id="{$dna-match-id}" name="dna-match-pedigree">
					<p:with-input port="source">
						<p:pipe step="create-leeds-method-network" port="full-network" />
					</p:with-input>
				</tcy:filter-network-by-direction>	
								
			</p:if>
								
		</p:group>
		
	</p:for-each>
	
	<p:wrap-sequence wrapper="networks" />

	<p:insert name="pedigree-with-dna-analysis" match="/networks" position="first-child">
		<p:with-input port="insertion">
			<p:pipe port="pedigree-network" step="create-leeds-method-network" />
		</p:with-input>
	</p:insert>
	
	<p:xslt>
		<p:with-input port="stylesheet">
			<p:document href="../../../build/data/network/merge-networks/merge_networks.xsl" />
		</p:with-input>
	</p:xslt>  
	
	<p:add-attribute attribute-name="subset-name" attribute-value="leeds-method" />
	
	<p:xslt>
		<p:with-input port="stylesheet">
			<p:document href="style.xsl" />
		</p:with-input>
		<p:with-option name="parameters" select="map{'anchor-person-id' : $dna-subject-id, 'dna-match-ids' : distinct-values($dna-match-id-elements/text())}" />
	</p:xslt>
       
</p:declare-step>