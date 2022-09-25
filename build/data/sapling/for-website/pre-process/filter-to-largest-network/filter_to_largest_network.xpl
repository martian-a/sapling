<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step
	xmlns:c="http://www.w3.org/ns/xproc-step"
	xmlns:cxf="http://xmlcalabash.com/ns/extensions/fileutils"
	xmlns:d="http://ns.kaikoda.com/documentation/xml"
	xmlns:p="http://www.w3.org/ns/xproc"
	xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
	name="filter-to-largest-network"
	type="tcy:filter-to-largest-network"
	version="3.0">
	
	
	<p:documentation>
		<d:desc>
			<d:p>Reduce the data in the file to just those entities that are in or directly associated with the largest network of people in the file.</d:p>
			<d:list>
				<d:li>Organise all people in the file into networks, using their birth/christening events.</d:li>
				<d:li>Work out which network is largest.</d:li>
				<d:li>Find all the other entities associated with largest network</d:li>
				<d:li>Delete all entities that aren't in or directly associated with the largest network of people.</d:li>
			</d:list>
		</d:desc>
	</p:documentation>
	
	<p:import href="../../../../network/sapling-to-network/sapling2network.xpl" />
	<p:import href="../../../../network/filter-to-largest-sub-network/filter_network_to_largest_sub_network.xpl" />
	<p:import href="../../../../network/filter-sapling-by-network/filter_sapling_by_network.xpl" />
	
	
	<p:input port="source" sequence="false" primary="true" />
	
	<p:output port="result" sequence="false" />
	
	<!-- Create a network serialisation of the tree data -->
	<tcy:sapling-to-network with-node-for-parent-group="false" />
	
	<!-- Find the largest sub-network in the graph and 
		filter out all nodes that aren't in it. -->
	<tcy:filter-network-to-largest-sub-network />
	
	<tcy:filter-sapling-by-network>
		<p:with-input port="network" />
		<p:with-input port="source">
			<p:pipe step="filter-to-largest-network" port="source" />
		</p:with-input>
	</tcy:filter-sapling-by-network>			
	
</p:declare-step>