xquery version "3.0";
module namespace data = "http://ns.thecodeyard.co.uk/xquery/modules/data";

import module namespace config = "http://ns.thecodeyard.co.uk/xquery/settings/config" at "config.xq";



(:==================
  Anonymous Entities 
====================:)


(: Less direct that with path. Uses entity-specific methods for consistency as they return different content to raw DB. :) 
declare function data:get-entity($id as xs:string?) as element()? {
	
	if ($id != '')
	then data:get-entities()/self::*[@id = $id]
	else ()
	
};

declare function data:get-entities() as element()* {
	$config:db/*/*[@id]
};

declare function data:get-entities($path as xs:string?) as element()* {

	if (normalize-space($path) != '') 
	then
		for $entity in data:get-entities()/self::*[local-name() = $path]
		return $entity
	else ()
};

declare function data:get-entity-list($path) as element()* {
	
	<index path="{$path}">{
		for $entity in data:get-entities($path) 
		return 
			<entity id="{$entity/@id}" />
	}</index>	
	
};


declare function data:is-valid-id($path as xs:string?, $id as xs:string?) as xs:boolean {
	let $entity := data:get-entity($id)
	return
		if (count($entity) > 0 and $entity/self::*/local-name() = $path)
		then true()
		else false()	
};


declare function data:get-augmented-entity($simple as element()?) as element()? {  
	
	if (not($simple))
	then ()
	else $simple
};



(:=========
  App Views
===========:)

(: Get app XML :)
declare function data:get-app() as element() {
    $config:db/app
};



(: Get all app index views :)
declare function data:get-views() as element()* {
    data:get-app()/views/index[@path]
};

(: Verify whether an app view exists :)
declare function data:get-view($path as xs:string?) as element()* {
	data:get-views()/self::*[@path = $path]
};



(: Build XML for HTML view :)
declare function data:view-app-xml($path-in as xs:string?, $id-in as xs:string?) as item()? {

	let $entity as element()? := data:get-entity($id-in)

	(: 
		Check that the ID is valid
		If it isn't, set ID to empty.
	:)
	let $id as xs:string? :=
		if (count($entity) = 1) 
		then $id-in 
		else ''

	(: 
		Check that the path is valid
		If it isn't, set path to empty.
	:)
	let $path as xs:string? :=
		if ($id != '')
		then (: Entity found, check path matches element name :)
			if ($entity/self::*/local-name() = $path-in)
			then $path-in (: Element name matches path, so path must be valid :)
			else ''
		else if ($id-in != $id)
		then '' (: Entity sought but not found, so path irrelevant :)
		else
			let $index := data:get-views()/self::*[@path = $path-in]
			return
				if (count($index) = 1)
				then $path-in
				else ''


	return
		if ($path = '') 
		then () (: No path set. Invalid request made; return nothing :)
		else
			<app>
				{
					data:get-app()/name,
					element view {
						attribute path {
							if ($id != '') 
							then concat($path, '/', $id)
							else $path
						},
						attribute index {
							if ($id = '') 
							then 'true' 
							else 'false'
						},
						<method type="html" />,
						<method type="xml" />,
						<data>{
							if ($id != '')
						    then data:view-entity-xml($entity)
						    else data:view-index-xml($path)			
						}
						</data>
					}	
				}
				{
					data:get-app()/views,
					data:get-app()/assets
				}
			</app>            

};



declare function data:view-entity-xml($param as item()?) {
	
	let $entity :=
		if ($param instance of xs:string)
		then data:get-entity($param)
		else if ($param instance of element())
		then $param
		else ()
	
	return data:get-augmented-entity($entity)
	
};

declare function data:view-index-xml($path as xs:string) as element()? {
	if ($path = '/')
	then 
		<indices>{data:get-views()}</indices>
	else
		let $entities := data:get-entities($path) 
		return
			<entities>{
				for $entity in $entities
				return data:build-entity-reference($entity)
			}</entities>
};

declare function data:build-entity-reference($entity as element()) as element()* {

	switch ($entity/name()) 
	case "person"
		return
			for $persona in $entity/persona
			return
				element {$entity/name()} {
					attribute ref {$entity/@id},
					$persona/name
				}
	case "name"
		return
			for $name in $entity/name
			return
				element {$entity/name()} {
					attribute ref {$entity/@id},
					xs:string($name)
				}
	default
		return
			element {$entity/name()} {
				attribute ref {$entity/@id},
				$entity/*[name() = ('title', 'name')]
			}
};
