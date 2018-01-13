xquery version "3.0";
module namespace data = "http://ns.thecodeyard.co.uk/xquery/modules/data";

import module namespace config = "http://ns.thecodeyard.co.uk/xquery/settings/config" at "config.xq";

declare namespace geo = "http://www.w3.org/2003/01/geo/wgs84_pos#";

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
		else if ($param instance of attribute() and $param/name() = ('id', 'ref'))
		then $param/xs:string(.)
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
    for $entry in data:get-app()/(views/* | views/descendant::sub/*)[@path]
	return $entry
};

(: Verify whether an app view exists :)
declare function data:get-view($path as xs:string?) as element()* {
	data:get-views()/self::*[@path = $path]
};


(: Build XML for HTML view :)
declare function data:view-app-xml($path-in as xs:string?, $id-in as xs:string?) as item()? {
	data:view-app-xml($path-in, $id-in, false())
};


(: Build XML for HTML view :)
declare function data:view-app-xml($path-in as xs:string?, $id-in as xs:string?, $for-graph as xs:boolean) as item()? {

	let $app-view-entry as element()? := data:get-view($path-in)

	let $entity as element()? := 
		if ($id-in = '')
		then data:get-entity(xs:string($app-view-entry/content/@ref))
		else data:get-entity($id-in)

	(: 
		Check that the ID is valid
		If it isn't, set ID to empty.
	:)
	let $id as xs:string? :=
		if (count($entity) = 1) 
		then xs:string($entity/@id)
		else ''

	(: 
		Check that the path is valid
		If it isn't, set path to empty.
	:)
	let $path as xs:string? :=
		if ($id != '')
		then (: Entity found, check entity belongs with path :)
			if ($entity/self::content[@id = $app-view-entry/content/@ref])
			then xs:string($app-view-entry/@path) (: Entity is static content and is expected on requested path :)
			else if ($entity/self::*/local-name() = $app-view-entry/@path)
			then xs:string($app-view-entry/@path) (: Entity's element name is expected on requested path :)
			else ''
		else if ($id-in = '' and $app-view-entry[@path])
		then xs:string($app-view-entry/@path)
		else ''
		
	let $methods as element()* := data:get-view($path-in)/self::*/method

	return
		if ($path = '') 
		then () (: No path set. Invalid request made; return nothing :)
		else
			<app>
				{
					data:get-app()/name, 
					element view {
						attribute path {
							if ($id-in != '') 
							then concat($path, '/', $id)
							else $path
						},
						attribute index {
							if ($id-in = '' and $app-view-entry/self::index) 
							then 'true' 
							else 'false'
						},
						attribute class {
							if ($path = '/')
							then 'home'
							else $path
						},
						if ($id-in = '')
						then $app-view-entry/title
						else (),
						$methods,
						<data>{
							if ($id != '')
						    then 
						    	if ($for-graph)
						    	then data:view-graph-xml($entity)
						    	else data:view-entity-xml($entity)
						    else if ($app-view-entry/self::index)
						    then data:view-index-xml($path)
						    else ()
						}
						</data>
					}
				}
				{
					data:get-app()/views,
					data:get-app()/assets
				}
			</app>
		
		(: 
			return <result>{$app-view-entry}<id-in>{$id-in}</id-in><id>{$id}</id><path-in>{$path-in}</path-in><path>{$path}</path><entity>{$entity}</entity></result>
		:)
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
			case "event" return (: Get only the events that involve people in the db :)
				for $entity in data:get-events-involving-people()/self::event[@type != 'historical']
				return data:simplify-entity($entity)
			case "location" return (: Get only the locations that are related to events that involve people in the db :)
				for $location in data:get-locations-involving-people()
				return data:simplify-entity($location)
			default return 
				for $entity in data:get-entities($path)
				return data:simplify-entity($entity)
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
					for $event in $events
					return data:get-related-locations($event)
				return (
					for $entity in ($people, $organisations, $locations)
					let $id := $entity/@id
					group by $id 
					return data:simplify-entity($entity[1])
				)
			default return ()
		return (
			if (count($entities) > 0) 
			then
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
			else ()
		)
};


declare function data:view-graph-xml($param as item()?) as element()? {
	
	for $entity in data:get-entity($param)/self::*
	let $related :=
		let $birth := data:get-entities("event")/self::*[@type = ('birth', 'christening')][person/@ref = $entity/@id]
		let $parents := 
			for $person in $birth/parent
			return data:get-entity($person)
		let $parents-relationship := data:get-entities("event")/self::*[@type = ('marriage', 'unmarried-partnership', 'engagement', 'separation', 'divorce')][person/@ref = $parents/@id]
		let $sibling-births := data:get-entities("event")/self::*[@type = ('birth', 'christening')][parent/@ref = $parents/@id]
		let $siblings :=
			for $person in $sibling-births/person
			return data:get-entity($person)
		let $partner-relationships := data:get-entities("event")/self::*[@type = ('marriage', 'unmarried-partnership', 'engagement', 'separation', 'divorce')][person/@ref = $entity/@id]
		let $partners := 
			for $person in $partner-relationships/person[@ref != $entity/@id]
			return data:get-entity($person[1])
		let $children-births := data:get-entities("event")/self::*[@type = ('birth', 'christening')][parent/@ref = $entity/@id]	
		let $children :=
			for $person in $children-births/person
			return data:get-entity($person)			

		let $people :=
			for $person in ($entity, $parents, $siblings, $partners, $children)
			let $id := $person/@id
			group by $id
			order by $person[1]/number(substring-after(@id, 'PER')) ascending
			return data:simplify-person($person[1])

		let $deaths := data:get-entities("event")/self::*[@type = 'death'][person/@ref = $people/@id]
		let $births := data:get-entities("event")/self::*[@type = ('birth', 'christening')][person/@ref = $people/@id]

		let $events :=
			for $event in ($births, $parents-relationship, $partner-relationships, $deaths)
			let $id := $event/@id
			group by $id
			order by $event[1]/number(substring-after(@id, 'EVE')) ascending
			return data:simplify-event($event[1])
			
		return ($people[@id != $entity/@id], $events)
	return
		element person {
			
			(: Deep copy of existing entity :)
			$entity/@*,
			$entity/persona,
			
			if (count($related) > 0)
			then
				(: Data for referenced entities :)
				<related>{$related}</related>
			else ()
		}
	
};





(:==============
  Custom Methods
================:)

declare function data:simplify-entity($param as element()) as element() {

	switch ($param/name())
	case "person" return data:simplify-person($param)
	case "organisation" return data:simplify-organisation($param)
	case "location" return data:simplify-location($param)
	case "event" return data:simplify-event($param)
	case "name" return data:simplify-derived-name($param)
	default return $param

};


declare function data:simplify-person($param as element()) as element()? {
	
	for $entity in $param/self::person[starts-with(@id, 'PER')]
	return
		<person>{
			$entity/@*,
			$entity/persona[1]
		}</person>
};

declare function data:simplify-organisation($param as element()) as element()? {
	
	for $entity in $param/self::organisation[starts-with(@id, 'ORG')]
	return
		<organisation>{
			$entity/@*,
			$entity/name[1]
		}</organisation>
};

declare function data:simplify-location($param as element()) as element()? {
	
	for $entity in $param/self::location[starts-with(@id, 'LOC')]
	return
		<location>{
			$entity/@*,
			$entity/name[1],
			$entity/geo:point,
			$entity/within
		}</location>
};

declare function data:simplify-event($param as element()) as element()? {
	
	for $entity in $param/self::event[starts-with(@id, 'EVE')]
	return
		<event>{
			$entity/@*,
			$entity/*[not(name() = ('preceded-by'))]
		}</event>
};

declare function data:simplify-derived-name($param as element()) as element()? {
	
	for $entity in $param/self::name[starts-with(@id, 'NAM')]
	return
		<name>{
			$entity/@*,
			$entity/name[1]
		}</name>
};


declare function data:augment-entity($param as element()) as element()? {
	
	for $entity in $param/self::*
	let $related :=
		let $events := data:get-related-events($entity)
		let $people := data:get-related-people($entity, $events)
		let $organisations := data:get-related-organisations($entity, $events)
		let $locations := data:get-related-locations($entity, $events, ())
		return (  
			for $related-entity in ($events, $people, $organisations, $locations)
			return data:simplify-entity($related-entity)
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
		case "content" return
			for $ref in $entity/descendant::event/@ref/xs:string(.)
			return data:get-entity($ref)
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
	data:get-related-locations($entity, (), ())
};

declare function data:get-related-locations($entity as element(), $related-events as element()*, $related-people as element()*) as element()* {

	let $entities := ($entity, $related-events, $related-people)
	let $related := (
		let $direct :=
			for $location in $entities/descendant::location
			let $id := $location/@ref
			group by $id
			return data:get-entity($location[1])
		let $indirect :=
			let $near :=
				if ($entity/name() = 'location')
				then data:get-locations-near($entity)
				else ()
			let $context :=
				for $location in ($entity, $direct, $near)
				return data:get-location-context($location)
			let $within :=
				if ($entity/name() = 'location')
				then data:get-locations-within($entity)
				else ()
			
			for $location in ($context, $within, $near)
			let $id := $location/@id
			group by $id
			return $location[1]
		return ($direct, $indirect)
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

	let $entities := 
	   switch ($entity/name())
	   case "location" return ($entity, $related-events, data:get-locations-within($entity))
	   default return ($entity, $related-events)
	let $references-to-organisations := $entities/descendant::organisation/@ref/xs:string(.)
	let $references-from-organisations := data:get-entities('organisation')/self::organisation[descendant::*/@ref = $entities/@id]/@id/xs:string(.)
	for $ref in distinct-values(($references-to-organisations, $references-from-organisations))
	let $organisation := data:get-entity($ref)/self::organisation[@id != $entity/@id]
	order by $organisation/number(substring-after(@id, 'ORG')) ascending
	return $organisation

};


declare function data:get-events-involving-people() as element()* {

	data:get-entities("event")/self::*[descendant::person[@ref] or descendant::parent[@ref]]

};


declare function data:get-locations-involving-people() as element()* {
	
	let $related-locations :=
		for $event in data:get-events-involving-people()
		let $id := $event/@id
		group by $id
		return data:get-related-locations($event[1])
	return 
		for $location in $related-locations/self::location
		let $id := $location/@id
		group by $id
		return $location[1]
	
};


declare function data:get-location-context($location as element()?) as element()* {

	for $ancestor in $location/self::location[starts-with(@id, 'LOC')]/descendant::within/data:get-entity(@ref/xs:string(.))
	return ($ancestor, data:get-location-context($ancestor))
			
};

declare function data:get-locations-within($location as element()?) as element()* {

	for $descendant in data:get-entities('location')[within/@ref = $location/@id]
	return ($descendant, data:get-locations-within($descendant))

};

declare function data:get-locations-near($location-in as element()?) as element()* {
	
	let $referenced-by-location-in :=
		for $location in $location-in/near
		return data:get-entities('location')/self::location[@id = $location/@ref]
		
	let $references-location-in := data:get-entities('location')/self::location[near/@ref = $location-in/@id]
		
	for $location in ($referenced-by-location-in, $references-location-in)/self::location[@id != $location-in/@id]
	let $id := $location/@id
	group by $id
	order by $location[1]/number(substring-after(@id, 'LOC')) ascending
	return $location[1]

};