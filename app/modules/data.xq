xquery version "3.0";
module namespace data = "http://ns.thecodeyard.co.uk/xquery/modules/data";

import module namespace config = "http://ns.thecodeyard.co.uk/xquery/settings/config" at "config.xq";


(:==================
  Anonymous Entities 
====================:)


(: Less direct that with path. Uses entity-specific methods for consistency as they return different content to raw DB. :) 
declare function data:get-entity($param as item()?) as element()? {
	
	let $id as xs:string? := 
		if ($param instance of xs:string)
		then $param
		else if ($param instance of element() and $param[@id or @ref])
		then 
			if ($param/@id)
			then $param/@id/xs:string(.)
			else $param/@ref/xs:string(.)
		else ''
	return
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
						attribute class {
							if ($path = '/')
							then 'home'
							else $path
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



declare function data:view-entity-xml($param as item()?) as element()? {
	
	for $entity in data:get-entity($param)/self::*
	return data:augment-entity($entity)
	
};

declare function data:view-index-xml($path as xs:string) as element()? {
	if ($path = '/')
	then 
		<indices>{data:get-views()}</indices>
	else
		let $entities := 
			switch ($path)
			case "event" return data:get-entities($path)[@type != 'historical' or descendant::person[@ref]]
			default return data:get-entities($path)
		let $related :=
			switch ($path)
			case "event" return
				let $events := $entities
				let $people := 
					for $event in $events
					return data:get-related-people($event)
				let $organisations := 
					for $event in $events[@type = 'historical']
					return data:get-related-organisations($event)
				let $locations := 
					for $event in $events[@type = 'historical']
					return data:get-related-locations($event)
				return (
					for $person in $people
					let $id := $person/@id
					group by $id 
					return data:simplify-person($person[1]), 
					for $entity in ($organisations, $locations)
					let $id := $entity/@id
					group by $id
					return $entity[1]
				)
			default return ()
		return
			<entities>{
				for $entity in $entities
				return $entity,
				if (count($related) > 0)
				then
					<related>{
						for $entity in $related
						let $id := $entity/@id
						group by $id
						return $entity
					}</related>
				else ()
			}</entities>
		
};





(:==============
  Custom Methods
================:)


declare function data:simplify-person($param as element()) as element()? {
	
	for $entity in $param/self::person[starts-with(@id, 'PER')]
	return
		<person>{
			$entity/@*,
			$entity/persona[1]
		}</person>
};

declare function data:augment-entity($param as element()) as element()? {
	
	for $entity in $param/self::*
	let $related :=
		switch ($entity/name())
		case "location" return 
			let $events := data:get-related-events($entity)
			let $people := data:get-related-people($entity, $events)
			let $organisations := data:get-related-organisations($entity, $events)
			let $locations := data:get-related-locations($entity)[@id != $entity/@id]
			return (
				$events,
				for $person in $people
				return data:simplify-person($person), 
				$organisations,
				$locations
			)
		default return 
			let $events := data:get-related-events($entity)
			let $people := data:get-related-people($entity)
			let $organisations := data:get-related-organisations($entity, $events)
			let $locations := data:get-related-locations($entity)
			return (
				$events, 
				for $person in $people
				return data:simplify-person($person), 
				$organisations,
				$locations
			)
			
return
		element {$entity/name()} {
			
			(: Deep copy of existing entity :)
			$entity/@*,
			$entity/*,
			
			if (count($related) > 0)
			then
				(: Data for referenced entities :)
				<related>{$related}</related>
			else ()
		}
};


declare function data:get-related-events($entity as element()) as element()* {

	let $unsorted :=
		switch ($entity/name()) 
		case "event" return
			for $ref in distinct-values($entity/descendant::preceded-by/@ref/xs:string(.))
			return data:get-entity($ref)
		case "person" return
			for $event in data:get-entities("event")[descendant::*[name() = ('person', 'parent')]/@ref = $entity/@id]
			return $event
		case "location" return
			let $locations := ($entity, data:get-locations-within($entity))
			for $event in data:get-entities("event")[descendant::location/@ref = $locations/@id]
			return $event
		case "organisation" return
			for $event in data:get-entities("event")[descendant::organisation/@ref = $entity/@id]
			return $event
		default return ()
	for $event in $unsorted/self::event[@id != $entity/@id]
	order by $event/number(substring-after(@id, 'EVE')) ascending
	return $event

};


declare function data:get-related-people($entity as element()) as element()* {
	data:get-related-people($entity, data:get-related-events($entity))
};

declare function data:get-related-people($entity as element(), $related-events as element()*) as element()* {

	let $entities := ($entity, $related-events)
	let $references :=
		let $direct-references := $entities/descendant::*[name() = ('person', 'parent')]/@ref/xs:string(.)
		let $indirect-references := data:get-entities('person')/self::person[descendant::note/descendant::*/@ref = $entity/@id]/@id/xs:string(.)
		return distinct-values(($direct-references, $indirect-references))
	for $ref in $references
	let $person := data:get-entity($ref)/self::person[@id != $entity/@id]
	order by $person/number(substring-after(@id, 'PER')) ascending
	return $person

};


declare function data:get-related-locations($entity as element()) as element()* {
	data:get-related-locations($entity, data:get-related-events($entity), data:get-related-people($entity))
};

declare function data:get-related-locations($entity as element(), $related-events as element()*, $related-people as element()*) as element()* {

	let $entities := ($entity, $related-events, $related-people)
	let $related := (
		let $direct :=
			for $ref in distinct-values($entities/descendant::location/@ref/xs:string(.)) 
			return data:get-entity($ref)
		let $indirect :=
			for $location in $direct
			return data:get-location-context($location)
		let $within :=
			if ($entity/name() = 'location')
			then data:get-locations-within($entity)
			else ()
		return ($direct, $indirect, $within)
	)
	for $location in $related/self::location[@id != $entity/@id]
	let $id := $location/@id
	group by $id
	order by $location[1]/number(substring-after(@id, 'LOC')) ascending
	return $location[1]

};


declare function data:get-related-organisations($entity as element()) as element()* {
	data:get-related-organisations($entity, data:get-related-events($entity))
};

declare function data:get-related-organisations($entity as element(), $related-events as element()*) as element()* {

	let $entities := ($entity, $related-events)
	for $ref in distinct-values($entities/descendant::organisation/@ref/xs:string(.))
	let $organisation := data:get-entity($ref)/self::organisation[@id != $entity/@id]
	order by $organisation/number(substring-after(@id, 'ORG')) ascending
	return $organisation

};


declare function data:get-location-context($location as element()?) as element()* {

	for $ancestor in $location/self::location[starts-with(@id, 'LOC')]/descendant::within/data:get-entity(@ref/xs:string(.))
	return ($ancestor, data:get-location-context($ancestor))
			
};

declare function data:get-locations-within($location as element()?) as element()* {

	for $descendant in data:get-entities('location')[within/@ref = $location/@id]
	return ($descendant, data:get-locations-within($descendant))

};