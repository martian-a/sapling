xquery version "1.0";
declare namespace request="http://exist-db.org/xquery/request";
declare namespace xs="http://www.w3.org/2001/XMLSchema";

let $id := request:get-parameter("id",'')
let $people := collection("/db/apps/sapling-test/data")/people
let $events := collection("/db/apps/sapling-test/data")/events
let $locations := collection("/db/apps/sapling-test/data")/locations

return
    <sapling>
    	{
    		for $person in $people/person[@id = $id]
			let $related-event-ids := distinct-values($events/event[*[self::person or self::parent]/@ref = $person/@id]/@id)
			let $related-events := $events/event[@id = $related-event-ids]
			let $related-people-ids := distinct-values($people/person[@id != $id and @id = $related-events/*[self::person or self::parent]/@ref]/@id)
			let $related-location-ids := distinct-values($locations//location[@id = $related-events/location/@ref]/@id)
			return
        		<person id="{$person/@id}" year="{$person/@year}">               
            		{$person/*}
            		<related>
		                <events>
		                    {
		                        for $event in $related-events
		                        order by xs:integer(substring-after($event/@id, 'EVE')) ascending
		                        return $event
		                    }
		                </events>
		                <people>
		                    {
		                        for $related-person in $people/person[@id = $related-people-ids]
		                        order by xs:integer(substring-after($related-person/@id, 'PER')) ascending
		                        return $related-person                        
		                    }
		                </people>
		                <locations>
		                    {
		                        for $location in $locations//location[@id = $related-location-ids]
		                        order by xs:integer(substring-after($location/@id, 'LOC')) ascending
		                        return
		                            <location id="{$location/@id}">
		                                {$location/name}
		                            </location>                
		                    }
		                </locations>
		            </related>
		        </person>        
		}
    </sapling>