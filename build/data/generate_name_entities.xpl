<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step
	xmlns:p="http://www.w3.org/ns/xproc"
	xmlns:c="http://www.w3.org/ns/xproc-step"
	xmlns:d="http://ns.kaikoda.com/documentation/xml"
	xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
	type="tcy:generate-name-entities"
	name="generate-name-entities"
	version="2.0">
	
	<p:input port="config" primary="true" />
	
	<p:option name="target" required="true" />
	
	<p:output port="result" sequence="true" />
	
	<p:option name="role" select="'core'" />
	
	
	<p:import href="../utils/xquery/generate_config.xpl" />
	
	<tcy:generate-xquery-config>
		<p:input port="config">
			<p:pipe port="config" step="generate-name-entities" />
		</p:input>
		<p:with-option name="role" select="$role" />
	</tcy:generate-xquery-config>
	
	<p:sink />
	
	<p:group>
		
		<p:output port="result" sequence="true">
			<p:pipe port="result" step="store" />
		</p:output>
		
		<p:xquery name="generate-xml">
			<p:input port="source">
				<p:inline><app /></p:inline>
			</p:input>
			<p:input port="query">
				<p:inline>
					<c:query>
						<![CDATA[
								xquery version "3.0";
								declare namespace c="http://www.w3.org/ns/xproc-step";
								declare namespace xs="http://www.w3.org/2001/XMLSchema";
								
								import module namespace config = "http://ns.thecodeyard.co.uk/xquery/settings/config" at "../utils/xquery/config.xq";
								import module namespace data = "http://ns.thecodeyard.co.uk/xquery/modules/data" at "../../app/modules/data.xq";
								
								let $named-entities := (data:get-entities('person') | data:get-locations-involving-people() | data:get-entities('organisation'))
								let $names := 
									for $entity in $named-entities
									return
										if ($entity/name() = 'person')
										then $entity/persona/name/descendant-or-self::name[not(descendant::name)]
										else $entity/name
								let $name-parts :=
									for $part in $names/self::name/tokenize(., ' ')
									group by $part
									return $part
								let $derived-names as element()* :=
									for $name-part in $name-parts
									let $normalised as xs:string := 													
										if (xs:string($name-part) = '')
										then '_unknown'
										else if (ends-with(xs:string($name-part), '.'))
										then lower-case(substring(xs:string($name-part), 1, string-length(xs:string($name-part)) - 1))
										else lower-case($name-part)
									group by $normalised
									order by $normalised ascending
									return
									
										(: 
											If normalised value of a derived name isn't a blacklisted value (eg. 2 or &), create an entity
											to represent that derived name.
										:)
										if (
											translate($normalised, concat('1234567890', codepoints-to-string(38)), '') = '' or
											replace(lower-case($normalised), 'of', '') = '' or
											replace(lower-case($normalised), 'the', '') = ''
										) 
										then () (: Blacklisted value :)
										else
											<name key="{$normalised}">
												{
													if (ends-with(xs:string($name-part[1]), '.'))
													then
														attribute abbreviation {'true'}
													else ()
												}
												<name>{
													if ($normalised = '_unknown')
													then 'Unknown'
													else if (ends-with(xs:string($name-part[1]), '.'))
													then substring(xs:string($name-part[1]), 1, string-length(xs:string($name-part[1])) - 1)
													else xs:string($name-part[1])
												}</name>
												{
													let $entities :=
														for $entity in $named-entities[
															descendant::name[
																ancestor::persona or ancestor-or-self::name/parent::*[name() = ('location', 'organisation')]
															][tokenize(., ' ') = $name-part]
														]
														let $id := $entity/@id
														group by $id
														return $entity
													return
														<derived-from>{
															for $entity in $entities
															let $class := $entity/name()
															group by $class
															return
																for $id in $entity/@id
																return
																	element {$class} {
																		attribute ref {$id}
																	}
														}</derived-from>
												}
										</name>
								return
									if (count($derived-names) = 0)
									then ()
									else 
										<names>
											{
												for $derived-name at $position in $derived-names
												return 
													element {$derived-name/name()} {
														attribute id {concat('NAM', $position)},
														$derived-name/@*,
														$derived-name/node()
													}
											}
										</names>									
							]]>
					</c:query>
				</p:inline>		
			</p:input>
			<p:input port="parameters">
				<p:empty />
			</p:input>
		</p:xquery>
		
		
		<p:xslt name="add-schema-refs">
			<p:input port="stylesheet">
				<p:document href="../utils/associate_schemas.xsl" />
			</p:input>
			<p:input port="parameters">
				<p:empty />
			</p:input>
		</p:xslt>
		
		<p:documentation>
			<d:doc scope="step">
				<d:desc>Store the index data.</d:desc>
			</d:doc>
		</p:documentation>
		<p:store name="store"
			method="xml"
			encoding="utf-8"
			media-type="text/xml"
			indent="true" 
			omit-xml-declaration="false"
			version="1.0">
			<p:with-option name="href" select="$target" />
		</p:store>
		
	</p:group>
	
</p:declare-step>