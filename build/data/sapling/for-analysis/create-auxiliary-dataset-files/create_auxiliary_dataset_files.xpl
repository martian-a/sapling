<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step" 
    xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
    xmlns:void="http://rdfs.org/ns/void#"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    name="create-auxiliary-dataset-files"
    type="tcy:create-auxiliary-dataset-files"
    version="3.0">
        
	<p:import href="../../sapling-to-network/family-tree/sapling2network.xpl" />
	<p:import href="../../../network/filter-to-largest-sub-network/filter_network_to_largest_sub_network.xpl" />
	<p:import href="../../../network/filter-sapling-by-network/filter_sapling_by_network.xpl" />
	<p:import href="../../../network/filter-by-direction/filter_network_by_direction.xpl" />
	<p:import href="../../../../utils/collate-output-file-locations/collate-output-file-locations.xpl" />
	<p:import href="../../../../utils/store.xpl" />
    
    <p:input port="source" primary="true" sequence="false">
    	<p:document href="../../../../../../bluegumtree-data/output/20220925/barnard.20220925.sapling.xml" />
    	<!-- p:document href="../../../../../../fortunes-olive-data/output/warr.20220806.sapling.xml" /-->
    </p:input>    
	
	<p:output port="result" sequence="false" />
      
	<p:option name="anchor-person-id" select="'I302059700731'" />  
	<p:option name="path-to-output-folder" select="'../../output/'" />
	<p:option name="generated-by-user" required="false" />    
    <p:option name="debug" select="'true'" />

  
	<tcy:sapling-to-family-tree-network with-node-for-parent-group="true" />	
	
	<tcy:store path-to-output-folder="{$path-to-output-folder}" filename="family_tree_with_node_for_parent_groups" name="network-with-node-for-parent-groups" />
	
	<p:sink />
	
	
	<tcy:sapling-to-family-tree-network with-node-for-parent-group="false">
		<p:with-input port="source">
			<p:pipe step="create-auxiliary-dataset-files" port="source" />
		</p:with-input>
	</tcy:sapling-to-family-tree-network>	
		
	<tcy:store path-to-output-folder="{$path-to-output-folder}" filename="family_tree_without_node_for_parent_groups" name="network-without-node-for-parent-groups" />		
	

	<tcy:filter-network-to-largest-sub-network />
	
	<p:add-attribute match="/network" attribute-name="subset-name" attribute-value="core" />
	
	<tcy:store path-to-output-folder="{$path-to-output-folder}" filename="family_tree_without_node_for_parent_groups" name="core-network-without-node-for-parent-groups" />
	
	<p:sink />
	
		
	<tcy:filter-sapling-by-network>
		<p:with-input port="network">
			<p:pipe step="core-network-without-node-for-parent-groups" port="result" />
		</p:with-input>
		<p:with-input port="source">
			<p:pipe step="create-auxiliary-dataset-files" port="source" />
		</p:with-input>
	</tcy:filter-sapling-by-network>
	
	<p:add-attribute match="/data/void:dataset" attribute-name="subset-name" attribute-value="core" />
	
	<tcy:store path-to-output-folder="{$path-to-output-folder}" name="core-sapling" />
	
	
	<tcy:sapling-to-family-tree-network with-node-for-parent-group="true">
		<p:with-input port="source">
			<p:pipe step="core-sapling" port="result" />
		</p:with-input>
	</tcy:sapling-to-family-tree-network>	
	
	<p:add-attribute match="/network" attribute-name="subset-name" attribute-value="core" />
	
	<tcy:store path-to-output-folder="{$path-to-output-folder}" filename="family_tree_with_node_for_parent_groups" name="core-network-with-node-for-parent-groups" />
	
	<p:sink />	
	
	
	<p:if test="normalize-space($anchor-person-id) != '' and /data[people/person/@id = $anchor-person-id]" name="filter-by-direction">
		
		<p:with-input>
			<p:pipe step="core-sapling" port="result" />
		</p:with-input>
		
		<p:output port="result" sequence="true">
			<p:pipe step="filter-by-direction-sub-pipeline" port="result" />
		</p:output>
		
		<p:group name="filter-by-direction-sub-pipeline">
			
			<p:output port="result" sequence="true">
				<p:pipe step="pedigree-network-without-node-for-parent-groups" port="result-uri" />
				<p:pipe step="descendants-network-without-node-for-parent-groups" port="result-uri" />
				<p:pipe step="pedigree-sapling" port="result-uri" />
				<p:pipe step="pedigree-network-with-node-for-parent-groups" port="result-uri" />
			</p:output>
	
			<tcy:filter-network-by-direction>
				<p:with-input port="source">
					<p:pipe step="core-network-without-node-for-parent-groups" port="result" />
				</p:with-input>
				<p:with-option name="anchor-person-id" select="$anchor-person-id" />
			</tcy:filter-network-by-direction>
			
			<p:add-attribute match="/network" attribute-name="subset-name" attribute-value="pedigree" />
			
			<tcy:store path-to-output-folder="{$path-to-output-folder}" filename="family_tree_without_node_for_parent_groups" name="pedigree-network-without-node-for-parent-groups" />
			
			<p:sink />
			
			
			<tcy:filter-network-by-direction direction="descendants">
				<p:with-option name="anchor-person-id" select="$anchor-person-id" />
				<p:with-input port="source">
					<p:pipe step="core-network-without-node-for-parent-groups" port="result" />
				</p:with-input>
			</tcy:filter-network-by-direction>
			
			<p:add-attribute match="/network" attribute-name="subset-name" attribute-value="descendants" />
			
			<tcy:store path-to-output-folder="{$path-to-output-folder}" filename="family_tree_without_node_for_parent_groups" name="descendants-network-without-node-for-parent-groups" />
			
			<p:sink />	
			
			<tcy:filter-sapling-by-network>
				<p:with-input port="network">
					<p:pipe step="pedigree-network-without-node-for-parent-groups" port="result" />
				</p:with-input>
				<p:with-input port="source">
					<p:pipe step="core-sapling" port="result" />
				</p:with-input>
			</tcy:filter-sapling-by-network>	
			
			<p:add-attribute match="/data/void:dataset" attribute-name="subset-name" attribute-value="pedigree" />
			
			<tcy:store path-to-output-folder="{$path-to-output-folder}" name="pedigree-sapling" />
			
			
			<tcy:sapling-to-family-tree-network with-node-for-parent-group="true" />
			
			<p:add-attribute match="/network" attribute-name="subset-name" attribute-value="pedigree" />
			
			<tcy:store path-to-output-folder="{$path-to-output-folder}" filename="family_tree_with_node_for_parent_groups" name="pedigree-network-with-node-for-parent-groups" />
			
			<p:sink />			
			
		</p:group>
		
	</p:if>
	
	<p:sink />
	
	
	<tcy:collate-output-file-locations>
		<p:with-input port="source">
			<p:pipe port="result-uri" step="network-with-node-for-parent-groups" />
			<p:pipe port="result-uri" step="network-without-node-for-parent-groups" />
			<p:pipe port="result-uri" step="core-sapling" />
			<p:pipe port="result-uri" step="core-network-with-node-for-parent-groups" />
			<p:pipe port="result-uri" step="core-network-without-node-for-parent-groups" />
			<p:pipe port="result" step="filter-by-direction" />			
		</p:with-input>
	</tcy:collate-output-file-locations>
	
</p:declare-step>