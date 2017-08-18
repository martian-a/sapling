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
	
	<p:import href="../utils/generate_xquery_config.xpl" />
	
	<tcy:generate-xquery-config>
		<p:input port="config">
			<p:pipe port="config" step="generate-name-entities" />
		</p:input>
		<p:with-option name="target" select="substring-after(resolve-uri('.'), ':')" />
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
								
								import module namespace config = "http://ns.thecodeyard.co.uk/xquery/settings/config" at "config.xq";
								import module namespace data = "http://ns.thecodeyard.co.uk/xquery/modules/data" at "../../app/modules/data.xq";
								
								let $named-entities := (data:get-entities('person') | data:get-entities('location') | data:get-entities('organisation'))
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
								return
									if (count($names) = 0)
									then ()
									else 
										<names>
											{
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
													<name id="{$normalised}">
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
			<p:input port="source">
				<p:pipe port="result" step="generate-xml" />
			</p:input>
			<p:with-option name="href" select="$target" />
		</p:store>
		
	</p:group>
	
</p:declare-step>