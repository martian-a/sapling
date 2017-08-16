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
								
								let $names := (data:get-entities('person')/persona/name/name | data:get-entities('location')/name | data:get-entities('organisation')/name)
								return
									if (count($names) = 0)
									then ()
									else 
										<names>
											{
												for $name in $names/self::name
												let $normalised as xs:string := 
													translate(
														if (xs:string($name) = '')
														then '_unknown'
														else if (ends-with(xs:string($name), '.'))
														then lower-case(substring(xs:string($name), 1, string-length(xs:string($name)) - 1))
														else lower-case($name),
														' ',
														'_'
													)	
												group by $normalised
												order by $normalised ascending
												return
													<name id="{$normalised}">
														{
															if (ends-with(xs:string($name[1]), '.'))
															then
																attribute abbreviation {'true'}
															else ()
														}
														<name>{
															if ($normalised = '_unknown')
															then 'Unknown'
															else if (ends-with(xs:string($name[1]), '.'))
															then substring(xs:string($name[1]), 1, string-length(xs:string($name[1])) - 1)
															else xs:string($name[1])
														}</name>
														{
															let $entities :=
																for $entity in $name/ancestor::*[name() = ('person', 'location')][1]
																let $id := $entity/@id
																group by $id
																return $entity
															return
																for $entity in $entities
																let $class := $entity/name()
																group by $class
																return
																	<associated>{
																		for $id in $entity/@id
																		return
																			element {$class} {
																				attribute ref {$id}
																			}
																	}</associated>
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