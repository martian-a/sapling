<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step
	xmlns:c="http://www.w3.org/ns/xproc-step"
	xmlns:d="http://ns.kaikoda.com/documentation/xml"
	xmlns:p="http://www.w3.org/ns/xproc"
	xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
	xmlns:void="http://rdfs.org/ns/void#"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	type="tcy:store"
	version="3.0">
	
	
	<p:input port="source" primary="true" sequence="false" />
	
	<p:output port="result" primary="true" sequence="false" />
	<p:output port="result-uri" sequence="false">
		<p:pipe port="result-uri" step="store" />
	</p:output>

	<p:option name="path-to-output-folder" required="true" />
	<p:option name="filename" required="false" />
	<p:option name="file-extension" select="'xml'" required="false" />
	<p:option name="serialization" select="map{'method' : 'xml', 'encoding' : 'utf-8', 'indent' : 'true', 'media-type' : 'text/xml'}" required="false" />
	<p:option name="dataset-name" required="false" />
	<p:option name="dataset-date" required="false" />
	
	<p:variable name="schema" select="if (/*/local-name() = 'data') then 'sapling' else /*/local-name()" as="xs:string" />
	<p:variable name="dataset-name" select="($dataset-name, /*/void:dataset/@void:name, /*/@void:name, /html/head/meta[@name = 'dataset-name']/@content)[1]" as="xs:string?" />
	<p:variable name="dataset-date" select="($dataset-date, translate(substring((/*/*:document/*:activity/*:startTime, /html/head/meta[@name = 'dataset-creation-date']/@content)[1], 1, 10), '-', ''))[1]" as="xs:string?" />	
	<p:variable name="subset-name" select="(/*/void:dataset/@subset-name, /*/@subset-name, /html/head/meta[@name = 'subset-name']/@content)[1]" as="xs:string?" />
	<p:variable name="qualified-filename" select="string-join(($dataset-name, $dataset-date, $subset-name, $filename, $schema, if ($serialization('method') = 'xml') then 'xml' else ())[normalize-space(.) != ''], '.')" as="xs:string" />

	<p:store name="store">
		<p:with-option name="serialization" select="$serialization" />
		<p:with-option name="href" select="string-join((
				(if (ends-with($path-to-output-folder, '/')) then substring($path-to-output-folder, 1, string-length($path-to-output-folder) - 1) else $path-to-output-folder), 
				$dataset-date, 
				$subset-name, 
				$qualified-filename
			)[normalize-space() != ''], '/')" />
	</p:store>	
		
</p:declare-step>
